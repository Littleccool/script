<?php
require "/usr/local/script/config.php";
function curlRequest($params){
	global $config;
	$destUrl = $config["reportUrl"];
	$index = 0;
	foreach($params as $key => $value){
		$delStr= $index++ == 0 ? '?' : '&';
		$destUrl .=  $delStr . $key . "=" . $value;
	}
	//$data_string = json_encode($post_data);

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $destUrl);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	//curl_setopt($ch, CURLOPT_POST, 1);
	//curl_setopt($ch, CURLOPT_POSTFIELDS,$data_string);
	$result = curl_exec($ch);
	echo $result;
	print_r($params);
	curl_close($ch);
}

function register(){
	$appId = 100001;
	$uid = rand(10000000,80000000);
	$openId = $uid ;
	$nickName = "测试账号" . $uid ;
	$regTs = time();
	$action="register";
	$params = array ("appId" => $appId,"uid" => $uid,"openId" => $openId, "nickName"=>$nickName,"regTs"=>$regTs,"action"=>$action);
	curlRequest($params);	
}

function login($date,$list){
	$size = count($list);
	if($size < 3) {	// 数据文件格式有误
		break;
	}
	
	$action=$list[1];
	if($action != "login"){
		continue;
	}
	global $config;
	$appId = $config["appId"];
	$uid = $list[2];
	$openId = $list[2] ;
	$hourStr = $list[0];
	$name = $list[3];
	$dateStr = $date . " " . $hourStr;
	$loginTs = strtotime($dateStr);
	$action="login";
	$params = array ("appId" => $appId,"uid" => $uid,"openId" => $openId,"name"=>$name, "loginTs"=>$loginTs,"action"=>$action);
	curlRequest($params);	
}

function createRoom($date,$list){
	$size = count($list);
	if($size < 3) {	// 数据文件格式有误
		break;
	}
	
	$action=$list[1];
	if($action != "create_room"){
		continue;
	}
	global $config;
	$appId = $config["appId"];
	$hourStr = $list[0];
	$dateStr = $date . " " . $hourStr;
	$count=$list[2];
	$juShu=$list[3];
	$ts = strtotime($dateStr);
	$action="createRoom";
	$params = array ("appId" => $appId, "juShu"=>$juShu,"count"=>$count,"ts"=>$ts,"action"=>$action);
	curlRequest($params);	
}

function cashChange($date,$list){
	global $config;
	$size = count($list);
	if($size < 3) {	// 数据文件格式有误
		continue;
	}
	
	$action=$list[1];
	if($action != "cash_change"){
		continue;
	}
	//	20170729 15:12:11|register|100001|64405888|64405888|测试账号64405888|1501312331
	//	15:23:55|cash_change|107742|-24|11215:28:27|
	//	LOG_BUSI("cash_change|%d|%d|%d|3|\n",pUser->get_user_id(),stu.var,stu.cardNums);
	$appId = $config["appId"];
	$uid = $list[2];
	$openId = $list[2] ;
	$cash = $list[3];
	$action="cashChange";
	$balance=$list[4];
	$hourStr = $list[0];
	$dateStr = $date . " " . $hourStr;
	$chargeTs = strtotime($dateStr);
	$reason=$list[5];;
	$params = array ("appId" => $appId,"uid" => $uid,"openId" => $openId, "cash"=>$cash,"action"=>$action,"balance"=>$balance,"reason"=>$reason,"ts"=>$chargeTs);
	curlRequest($params);
}

function gameInfo($date,$list){
	global $config;
	$size = count($list);
	if($size < 3) {	// 数据文件格式有误
		return ;
	}
	
	$action=$list[1];
	if($action != "game_over"){
		return ;
	}
/*	LOG_BUSI("game_over|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|\n",
				m_table_players[i]->get_user_id(),
				this->getMahJongRule().m_juShu,
				this->getMahJongRule().m_playCount,
				playTime,
				settentInfo[i].zimoCount,
				settentInfo[i].fangpaoCount,
				settentInfo[i].jiepaoCount,
				settentInfo[i].mingGangCount,
				settentInfo[i].xuGangCount,
				settentInfo[i].anGangCount,
				settentInfo[i].total);*/
	$action="playInfo";
	$appId = $config["appId"];
	$uid = $list[2];
	$openId = $list[2] ;
	$juShu = $list[3];
	$playCount=$list[4];
	$playTime = $list[5];
	$ziMo=$list[6];
	$fangPao=$list[7];
	$jiePao=$list[8];
	$mingGang=$list[9];
	$xuGang=$list[10];
	$anGang=$list[11];
	$total=$list[12];
	$roomId=$list[13];
	$hourStr = $list[0];
	$dateStr = $date . " " . $hourStr;
	$ts = strtotime($dateStr);
	$params = array ("appId" => $appId,"uid" => $uid,"openId" => $openId, "ziMo"=>$ziMo,"fangPao"=>$fangPao,"jiePao"=>$jiePao,"mingGang"=>$mingGang,"xuGang"=>$xuGang,"anGang"=>$anGang,"action"=>$action,"total"=>$total,"ts"=>$ts,"playTime"=>$playTime,"juShu"=>$juShu,"count"=>$playCount,"roomId"=>$roomId);
	curlRequest($params);
}


function charge($date,$list){
	$size = count($list);
	if($size < 3 ) {	// 数据文件格式有误
		return ;
	}
	
	$action=$list[1];
	if($action != "charge"){
		return;
	}
	
	global $config;	
	$appId = $config["appId"];
	$uid = $list[2];
	$openId = $list[2] ;
	$rmb = $list[3];
	$cash = $list[4];
	$action="charge";
	$balance=$list[5];
	$hourStr = $list[0];
	$dateStr = $date . " " . $hourStr;
	$chargeTs = strtotime($dateStr);
	$params = array ("appId" => $appId,"uid" => $uid,"openId" => $openId, "cash"=>$cash,"action"=>$action,"rmb"=>$rmb,"awardCash"=>0,"ts"=>$chargeTs);
	curlRequest($params);	
}

function report($date){

	global $config;
	$file = $config["busilog"] . $date . ".log";
	echo $file . "</br>";
	$handle = fopen($file, "r");
	$index = 0;
	while(!feof($handle)) { // 循环显示每一个行
		$str = fgets($handle);
		$list = explode("|", $str);
		$size = count($list);
		if($size < 3 ) {	// 数据文件格式有误
			continue;
		}
		
		$action=$list[1];
		if($action == "login"){
			login($date,$list);
		}	

		if($action == "cash_change"){
			cashChange($date,$list);
		}
		
		if($action == "game_over"){
			gameInfo($date,$list);
		}
		
		if($action == "create_room"){
			createRoom($date,$list);
		}
		
		if($action == "charge"){
			charge($date,$list);
		}
	}
	
}


	$date=$argv[1];
	report($date);

?>


