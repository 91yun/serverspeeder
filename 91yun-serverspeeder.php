<?php 
/*
Plugin Name: 91yun serverspeeder
Plugin URI: 
Description: serverspeeder一键安装包
Version: 0.0.1
Author: 91yun
Author URI: 
Text Domain: 91yun.org
*/
//require_once("ss.php");


//echo var_dump($ss);
//exit;

class serverspeeder91yun{
		
	//析构函数
	function __construct() {
		
		//插件激活时候的处理
		register_activation_hook( __FILE__, Array($this,'myplugin_activate'));	
		//判断是否该页面
		add_filter('the_content', array($this,'check_page'));	

	}


	
	
function check_page($text){
	if(is_page("serverspeeder91yun")){
		$release = $_GET["release"];
		$releasever = $_GET["releasever"];
		$kernel_result = $_GET["kernel_result"];
		$bit = $_GET["bit"];
		$serverspeederver = $_GET["serverspeederver"];
		$binfile = $_GET["binfile"];
		$text = file_get_contents("http://rs.91yun.pw/serverspeederlist.php?release=$release&releasever=$releasever&kernel_result=$kernel_result&bit=$bit&serverspeederver=$serverspeederver&binfile=$binfile");				
		return $text;
	}
	else
	{
		return $text;
	}


}








		//插件激活时执行的内容
	function myplugin_activate(){
		//如果page不存在，就创建page
		$soldout = get_page_by_title("锐速安装一键包");
		if (Null == $soldout)
		{
			$page = array(
			 'post_title' => '锐速安装一键包',
			 'post_content' => '锐速安装一键包',
			 'post_name' => 'serverspeeder91yun',
			 'post_status' => 'publish',
			 'post_author' => 1,
			 'post_type' => 'page'
			);
			 wp_insert_post($page);
		}


	}

}

$serverspeeder = new serverspeeder91yun();

?>
