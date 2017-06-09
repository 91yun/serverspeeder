#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH


#定义变量
#授权文件自动生成url
APX=http://rs.91yun.pw/apx1.php
#安装包下载地址
INSTALLPACK=https://github.com/91yun/serverspeeder/blob/test/91yunserverspeeder.tar.gz?raw=true
#判断版本支持情况的地址
CHECKSYSTEM=https://raw.githubusercontent.com/91yun/serverspeeder/test/serverspeederbin.txt
#bin下载地址
BINURL=http://rs.91yun.pw/



#取操作系统的名称
Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        release='CentOS'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        release='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        release='Ubuntu'
        PM='apt'		
	else
        release='unknow'
    fi
    
}

Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        bit='x64'
    else
        bit='x32'
    fi
}

Get_Dist_Name
Get_OS_Bit
kernel=`uname -r`
kernel_result=""

echo -e "\r\n"
echo "===============System Info======================="
echo "$release "
echo "$kernel "
echo "$bit "
echo "================================================="
echo -e "\r\n"



release=$1
releasever=$2
kernel_result=$3
bit=$4
serverspeederver=$5
BINFILE=$1"/"$2"/"$3"/"$4"/"$5"/"$6




BIN=${BINURL}${BINFILE}


echo "installing ServerSpeeder, please wait for a moment..."
echo -e "\r\n"


MACSTR="LANG=C ifconfig eth0 | awk '/HWaddr/{ print \$5 }' "
MAC=$(eval $MACSTR)
if [ "$MAC" == "" ]; then
	MACSTR="LANG=C ifconfig eth0 | awk '/ether/{ print \$2 }' "
	MAC=$(eval $MACSTR)
fi	
if [ "$MAC" == "" ]; then
	echo "The name of network interface is not eth0, please retry after changing the name."
	exit 1
fi


#如果自动取不到就退出
if [ "$MAC" = "" ]; then
	echo "Unable to get MAC address. Installation terminated."
	exit 1
fi

	
#下载安装包
wget -N --no-check-certificate -O 91yunserverspeeder.tar.gz  $INSTALLPACK  > /dev/null 2>&1
tar xfvz 91yunserverspeeder.tar.gz  > /dev/null 2>&1 || { echo "Unable to download Installation package. Installation terminated.";exit 1; }

#下载授权文件
wget -N --no-check-certificate -O apx.lic "$APX?mac=$MAC"  > /dev/null 2>&1 || { echo "Unable to download lic file, please check: $APX?mac=$MAC";exit 1;}
mv apx.lic 91yunserverspeeder/apxfiles/etc/


#取得序列号

wget -N --no-check-certificate -O serverspeedersn.txt "$APX?mac=$MAC&sno"  > /dev/null 2>&1
SNO=$(cat serverspeedersn.txt)
rm -rf serverspeedersn.txt
sed -i "s/serial=\"sno\"/serial=\"$SNO\"/g" 91yunserverspeeder/apxfiles/etc/config
sed -i "s/apx-20341231/apx/g" 91yunserverspeeder/apxfiles/etc/config
rv=$release"_"$kernel_result
sed -i "s/acce-3.10.61.0-\[Debian_7_3.2.0-4-amd64\]/acce-$serverspeederver-[$rv]/g" 91yunserverspeeder/apxfiles/etc/config

#下载bin文件
wget -N --no-check-certificate -O "acce-"$serverspeederver"-["$release"_"$kernel_result"]" $BIN  > /dev/null 2>&1
mv "acce-"$serverspeederver"-["$release"_"$kernel_result"]" 91yunserverspeeder/apxfiles/bin/

#切换目录执安装文件
cd 91yunserverspeeder
bash install.sh  > /dev/null 2>&1

#禁止修改授权文件
#chattr +i /serverspeeder/etc/apx*
bash /serverspeeder/bin/serverSpeeder.sh status