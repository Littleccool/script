#! /usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;
use Time::Local;
require "/usr/local/script/sub.pl";

my $g_lastPlayTime = 0;
my $g_lastRoomId = 0;
#my $g_allZiMoTimes = 0;
sub register(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
	if($action ne "register"){
		return ;
	}
	
	my $appId = $listInfo[2];
	my $uid = $listInfo[3];
	my $openId = $listInfo[4];
	my $nickName=$listInfo[5];
	my $regTs = $listInfo[6];

	my $sql = "replace into game_user values($appId,$uid,'$nickName','$openId',0,0,$regTs,0,0)";
	print $sql . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	my $isNameValed=0;
	if($DBI::errstr){
		print $sql . "\n";
		$isNameValed=1;
	}	
	$sth->finish();
	if($isNameValed == 1){
	$sql="replace into game_user values($appId,$uid,' ','$openId',0,0,$regTs,0,0)";
	$sth = getStatDb()->prepare($sql);
        $sth->execute();
	}
}


sub login(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
#	print $action;
	if($action ne "login"){
		return ;
	}
	
	my $appId = $listInfo[2];
	my $uid = $listInfo[3];
	my $openId = $listInfo[4];
	my $nickName=$listInfo[5];
	my $loginTs = $listInfo[6];
	my $count = 0;
    	$loginTs =~ tr/\r\n//d;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($loginTs);
	if($mon < 10){
	$mon = "0" . $mon ;
	}
	if($mday < 10){
		$mday = "0" . $mday;
	}
	my $loginDate = $year+1900 . $mon+1 . $mday;
	my $sql = "replace into user_login values($loginDate,$appId,$uid)";
	print $sql ."    " .  $mon ." ". $loginTs . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){
		print $sql . "\n";
	}
	$sth->finish();
	
	$sql = "select count(uid) from game_user where appId=$appId and uid=$uid";
	$sth = getStatDb()->prepare($sql);
	$sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
        $count = defined $row[0] ? $row[0] : 0;
	}
    	$sth->finish();
	
	if($count == 0){
		$sql = "replace into game_user values($appId,$uid,'$nickName','$openId',0,0,$loginTs,0,100)";
		print $sql . "\n";
		my $sth = getStatDb()->prepare($sql);
		$sth->execute();
		my $isNameValed = 0;
		if($DBI::errstr){
			#print $sql . "\n";
			$isNameValed=1;
		}
		$sth->finish();
        	if($isNameValed == 1){
        		$sql="replace into game_user values($appId,$uid,'special name','$openId',0,0,$loginTs,0,0)";
        		$sth = getStatDb()->prepare($sql);
        		$sth->execute();
       		}	
	}
}

sub createRoom(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
	if($action ne "createRoom"){
		return;
	}
	
	my @crtTime=split(/ /,$listInfo[0]);
	
	my $appId = $listInfo[2];
	my $juShu = $listInfo[3];
	my $count = $listInfo[4];
	my $creatTime = $listInfo[5];

	my $sql = "replace into game_record values($appId,$juShu,$count,$creatTime)";
	print $sql . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){
		print $sql . "\n";
	}
}

sub cashChange(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
	if($action ne "cashChange"){
		return;
	}
	
	my $appId = $listInfo[2];
	my $uid = $listInfo[3];
	my $openId = $listInfo[4];
	my $balance = $listInfo[6];
	my $chargeTs = $listInfo[8];;
	my $cash = $listInfo[5];
	my $sql = "update  game_user set balance = $balance where appId = $appId and uid=$uid limit 1";
	print $sql . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){
		print $sql . "\n";
	}
	$sth->finish();

	#update cash history
	$sql="replace into cash_change_hisroty values($appId,$uid,$chargeTs,$cash,$balance)";
	 print $sql . "\n";
        my $sth = getStatDb()->prepare($sql);
        $sth->execute();
        if($DBI::errstr){
                print $sql . "\n";
        }
        $sth->finish();
}

sub charge(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
	if($action ne "charge"){
		return;
	}
	#print "\n line". $_ . " \n";	
	my $appId = $listInfo[2];
	#print(@listInfo,"\n");
	my $uid = $listInfo[3];
	my $openId = $listInfo[4];
	my $cash = $listInfo[5];
	my $rmb = $listInfo[6];
	my $awardCash = $listInfo[7];
	my $chargeTs = $listInfo[8];
	$chargeTs =~ tr/\r\n//d;
	my $sql = "replace into pay_history values($chargeTs,$appId,$uid,$rmb,$cash,$awardCash)";
	print $sql . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){
		print $sql . "\n";
	}
}

sub playInfo(@)
{
	my @listInfo = @_;
	my $action = $listInfo[1];
	if($action ne "playInfo"){
		return;
	}
	####################################
	#global   $dateStr;
    #$line =  $dateStr;
    #$line = $line . "|" . $action;
    #$line = $line . "|" . $appId;
    #$line = $line . "|" . $uid;
    #$line = $line . "|" . $time;
	#$line = $line . "|" . $roomId;
    #$line = $line . "|" . $juShu;
    #$line = $line . "|" . $count;
    #$line = $line . "|" . $huTimes;
    #$line = $line . "|" . $points;
	######################################
	my $appId = $listInfo[2];
	my $uid = $listInfo[3];
	my $openId = $listInfo[3];
	my $playTs = $listInfo[16];
	my $roomId = $listInfo[15];
	my $juShu = $listInfo[12];
	my $count = $listInfo[13];
	my $huTimes = $listInfo[8];
	my $points = $listInfo[9];
	my $playTime = $listInfo[11];
	

#	print "lastTime " . $g_lastPlayTime . "lastId " . $g_lastRoomId . "\n";
#	print "roomId " . $roomId . "div " . ($playTs  - $g_lastPlayTime) . "\n";
#	$g_allZiMoTimes = $roomId == $g_lastRoomId && $roomId > 0 ? $g_allZiMoTimes+$huTimes : $huTimes;	
	#重复roomId 只记录一次
	if($roomId == $g_lastRoomId && abs($playTs  - $g_lastPlayTime) < 5){
		return ;
	}
	
	
	$g_lastPlayTime = $playTs;
	$g_lastRoomId = $roomId;
	#create table game_play_record(appId int unsigned ,roomId int unsigned ,ts int unsigned ,juShu int ,renShu int ,primary key(appId,roomId,ts));
	my $sql = "replace into game_play_record values($appId,$roomId,$playTs,$juShu,$count,$playTime)";
	print "sql=" . $sql . "\n";
	my $sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){
		print $sql . "\n";
	}
}


my $date = defined $ARGV[0] ? $ARGV[0] : `date -d "1 days ago" +"%Y%m%d"`;
   $date =~ tr/\n//d;
if(length($date) != 8)
{
    die "Date param error";
}

my $loginLog = "/data/tmp/report/report.$date.log";
open(OFH, $loginLog) || print "file not exist:$loginLog";
while(<OFH>)
{
	$_ =~ tr/\r\n//d;
	
	my @arrayInfo=split(/\|/,$_);
	if(@arrayInfo < 4){
		next;
	}
	
	login(@arrayInfo);
	cashChange(@arrayInfo);
	charge(@arrayInfo);	
	playInfo(@arrayInfo);
}

printInfo($0,2);
