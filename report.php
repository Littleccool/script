<?php
date_default_timezone_set("PRC");
$ss_log_filename = '/data/tmp/report/report.' . date('Ymd') . '.log';
$dateStr=date('Ymd H:i:s');

$action =$_REQUEST["action"];
if($action == "register"){
    registerReport();
}else if($action == "login"){
    loginReport();
}else if($action == "createRoom"){
    createRoomReport();
}else if($action == "cashChange"){
    cashChangeReport();
}else if($action == "charge"){
    chargeReport();
}else if($action == "playInfo"){
    playInfoReport();
}else{
    echo "invalid action ";
    exit;
}

function registerReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $regTs = $_REQUEST["regTs"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $regTs;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line. "\n", FILE_APPEND);
}

function loginReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $loginTs = $_REQUEST["loginTs"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $loginTs;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line. "\n", FILE_APPEND);
}

function createRoomReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $type = $_REQUEST["type"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $type;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line. "\n", FILE_APPEND);
}

function cashChangeReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $cash = $_REQUEST["cash"];
    $balance = $_REQUEST["balance"];
    $reason = $_REQUEST["reason"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $cash;
    $line = $line . "|" . $balance;
    $line = $line . "|" . $reason;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line. "\n", FILE_APPEND);
}

function chargeReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $cash = $_REQUEST["cash"];
    $rmb = $_REQUEST["rmb"];
    $awardCash = $_REQUEST["awardCash"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $cash;
    $line = $line . "|" . $rmb;
    $line = $line . "|" . $awardCash;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line. "\n", FILE_APPEND);
}

function playInfoReport()
{
    $action = $_REQUEST["action"];
    $appId = $_REQUEST["appId"];
    $uid = $_REQUEST["uid"];
    $openId = isset($_REQUEST["openId"]) ? $_REQUEST["openId"] : "";
    $time = $_REQUEST["time"];
    $type = $_REQUEST["type"];
    $count = $_REQUEST["count"];
    $huTimes = $_REQUEST["huTimes"];
    $points = $_REQUEST["points"];

    global   $dateStr;
    $line =  $dateStr;
    $line = $line . "|" . $action;
    $line = $line . "|" . $appId;
    $line = $line . "|" . $uid;
    $line = $line . "|" . $openId;
    $line = $line . "|" . $time;
    $line = $line . "|" . $type;
    $line = $line . "|" . $count;
    $line = $line . "|" . $huTimes;
    $line = $line . "|" . $points;

    global $ss_log_filename;
    file_put_contents($ss_log_filename, $line . "\n", FILE_APPEND);
}

?>

