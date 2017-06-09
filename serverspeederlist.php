<?php
if(!empty($_GET["release"])){
	$release = $_GET["release"];
	$releasever = $_GET["releasever"];
	$kernel_result = $_GET["kernel_result"];
	$bit = $_GET["bit"];
	$serverspeederver = $_GET["serverspeederver"];
	$binfile = $_GET["binfile"];
	echo '请在服务器上执行以下命令：';
	echo '<br>';
	echo '<pre class="lang:sh decode:true " style="overflow: auto; overflow-y:hidden">';
	echo "wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/test/serverspeeder-v.sh && bash serverspeeder-v.sh $release $releasever $kernel_result $bit $serverspeederver $binfile";
	echo '</pre>';
	echo "<BR>";
	echo "<a href='?'>选择其他的内核</a>";
	exit(0);
}

$c=file_get_contents("https://raw.githubusercontent.com/91yun/serverspeeder/test/serverspeederbin.txt");
$caar=preg_split("/\n/",$c);
echo "<BR>";
echo "如果你不知道这个页面是干嘛的，请使用自动安装脚本：<a href='https://www.91yun.org/archives/683' target=_blank>https://www.91yun.org/archives/683</a>";
echo "<BR>";
echo "<font color=red>善用Ctrl+F搜索</font>";
echo "<BR>";
echo "<BR>";
for($i=0;$i<count($caar);$i++)
{

	$pram=preg_split("/\//",$caar[$i]);
	$release = $pram[0];
	$releasever = $pram[1];
	$kernel_result = $pram[2];
	$bit = $pram[3];
	$serverspeederver = $pram[4];
	$binfile = $pram[6];
	echo "<a href='?release=$release&releasever=$releasever&kernel_result=$kernel_result&bit=$bit&serverspeederver=$serverspeederver&binfile=$binfile'>";
	echo $caar[$i];
	echo "</a>";
	echo "<BR>";
}

?>