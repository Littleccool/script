#! /usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;
use Time::Local;
require "/usr/local/script/sub.pl";

#####################################################################
#说明:每日的普通数据总结
#参数:日期或者无参
#####################################################################

if(@ARGV ne 2){
	print "usage: newuser_pay_stat.pl appId date";
	exit;
}

my $appId = defined $ARGV[0] ? $ARGV[0] : 0;

my $date = defined $ARGV[1] ? $ARGV[1] : `date -d "1 days ago" +"%Y%m%d"`;
   $date =~ tr/\n//d;
die "date error\n" unless (length($date) == 8);

my $year = substr($date,0,4) + 0;
my $month = substr($date,4,2) + 0;
my $day = substr($date,6,2) + 0;
my $dayBegTime = timelocal(0,0,0,$day,$month - 1,$year - 1900);
my $dayEndTime = timelocal(59,59,23,$day,$month - 1,$year - 1900);

my $all = 0;
my $dau = 0;
my $dou = 0;
my $dnu = 0;
my $mau = 0;
my $wau = 0;

my $sql = "";
	if($appId eq 10000){
		$sql = "select count(1) from stat.game_user where regTs>= $dayBegTime and regTs <= $dayEndTime ";
	}else{
		$sql = "select count(1) from stat.game_user where appId = $appId and regTs>= $dayBegTime and regTs <= $dayEndTime ";
	}
my $sth = getStatDb()->prepare($sql);
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
   while (my @row = $sth->fetchrow_array)
   {
	$dnu = defined $row[0] ? $row[0] : 0;
   }
   $sth->finish();

	if($appId eq 10000){
		$sql = "select count(1) from stat.game_user where regTs <= $dayEndTime";
	}else{
		$sql = "select count(1) from stat.game_user where appId = $appId and regTs <= $dayEndTime";
	}
#   $sql = "select count(1) from stat.game_user where appId = $appId and regTs <= $dayEndTime";
   $sth = getStatDb()->prepare($sql);
   $sth->execute();
   if($DBI::errstr){print $sql . "\n";}
   while (my @row = $sth->fetchrow_array)
   {
	$all = defined $row[0] ? $row[0] : 0;
   }
   $sth->finish();  

   my $weekBegin = dateTimeToString2($dayBegTime - 6 * 3600 * 24);
   my $monthBegin = dateTimeToString2($dayBegTime - 30 * 3600 * 24);
	if($appId eq 10000){
		$sql = "select count(distinct(uid))  from stat.user_login where loginDate=$date";
	}else{
		$sql = "select count(distinct(uid))  from stat.user_login where appId = $appId and loginDate=$date";
	}
   print $sql."\n";
   $sth = getStatDb()->prepare($sql);
   $sth->execute();
   if($DBI::errstr){print $sql . "\n";}
   while (my @row = $sth->fetchrow_array)
   {
	$dau = $row[0];
   }
   $sth->finish();  

   	if($appId eq 10000){
		$sql = "select count(distinct(uid)) from stat.user_login where loginDate<=$date and loginDate>=$weekBegin";
	}else{
		$sql = "select count(distinct(uid)) from stat.user_login where loginDate<=$date and loginDate>=$weekBegin and appId=$appId";
	}
	
   $sth = getStatDb()->prepare($sql);
   $sth->execute();
   if($DBI::errstr){print $sql . "\n";}
   while (my @row = $sth->fetchrow_array)
   {
	$wau = defined $row[0] ? $row[0] : 0;
   }
   $sth->finish();  

    if($appId eq 10000){
		$sql = "select count(distinct(uid)) from stat.user_login where loginDate<=$date and loginDate>=$monthBegin";
	}else{
		$sql = "select count(distinct(uid)) from stat.user_login where loginDate<=$date and loginDate>=$monthBegin and appId=$appId";
	}
   $sth = getStatDb()->prepare($sql);
   $sth->execute();
   if($DBI::errstr){print $sql . "\n";}
   while (my @row = $sth->fetchrow_array)
   {
	$mau = defined $row[0] ? $row[0] : 0;
   }
   $sth->finish();
 
   $dou = $dau - $dnu;
   my $newFee = 0; 
   my $newMoney = 0;
   my $oldFee = 0; 
   my $oldMoney = 0;
   my $money = 0;
   my $fee = 0;
   my %hash1;
   my %hash2;

   $sql = "select A.uid,A.rmb,B.regTs from pay_history as A,stat.game_user as B where A.chargeTs>= $dayBegTime and A.chargeTs <= $dayEndTime and A.appId = B.appId and A.uid = B.uid";
   
    if($appId eq 10000){
		$sql = "select A.uid,A.rmb,B.regTs from pay_history as A,stat.game_user as B where A.chargeTs>= $dayBegTime and A.chargeTs <= $dayEndTime and A.appId = B.appId and A.uid = B.uid";		
	}else{
		$sql = "select A.uid,A.rmb,B.regTs from pay_history as A,stat.game_user as B where A.chargeTs>= $dayBegTime and A.chargeTs <= $dayEndTime and A.appId = B.appId and A.uid = B.uid and A.appId=$appId";	
   }
   $sth = getStatDb()->prepare($sql);
   $sth->execute();
   if($DBI::errstr){print $sql . "\n";}
   my $curCount = 0;
   while (my @row = $sth->fetchrow_array)
   {
	$hash1{$row[0]} += $row[1];
	$hash2{$row[0]} = $row[2];
   }
   $sth->finish();
   print scalar keys %hash2;
   while( my ($key, $value) = each %hash1 )
   {
	if($hash2{$key}>= $dayBegTime && $hash2{$key} <= $dayEndTime)
	{
	    	$newFee++;
	        $newMoney += $hash1{$key};
	}
   }

  
   if($appId eq 10000){
		  $sql = "select sum(rmb) from stat.pay_history where chargeTs >= $dayBegTime and chargeTs <=$dayEndTime";
	
	}else{
		  $sql = "select sum(rmb) from stat.pay_history where chargeTs >= $dayBegTime and chargeTs <=$dayEndTime and appId=$appId";	
   }
   
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  while (my @row = $sth->fetchrow_array)
  {
	$money = defined $row[0] ? $row[0] : 0;
  }
  
     if($appId eq 10000){
  $sql = "select count(distinct(uid)) from stat.pay_history where chargeTs>= $dayBegTime and chargeTs <=$dayEndTime";
	
	}else{
  $sql = "select count(distinct(uid)) from stat.pay_history where chargeTs>= $dayBegTime and chargeTs <=$dayEndTime and appId = $appId";
   }
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  while (my @row = $sth->fetchrow_array)
  {
	$fee = defined $row[0] ? $row[0] : 0;
  }
	
  $oldFee = $fee - $newFee;
  $oldMoney += $money - $newMoney;	
  
  
  #开局局数统计
  
  $sql = "select count(1) juShu from stat.game_play_record where ts>= $dayBegTime and ts <=$dayEndTime ";
  if($appId ne 10000){
   $sql = "select count(1) juShu from stat.game_play_record where appId = $appId and ts>= $dayBegTime and ts <=$dayEndTime ";
  }
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  my $juShu = 0;
  while (my @row = $sth->fetchrow_array)
  {
	$juShu = defined $row[0] ? $row[0] : 0;
  }
  $sth->finish();
 

#结算局数
   $sql="select times from game_play_times where date=$date and appId=$appId";
   if($appId eq 10000){
   	$sql = "select sum(times) times from game_play_times where date=$date";
   } 
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  my $jieSuanJuShu = 0;
  while (my @row = $sth->fetchrow_array)
  {
        $jieSuanJuShu = defined $row[0] ? $row[0] : 0;
  }
  $sth->finish();

#print $sql . " " . $jieSuanJuShu . "\n";
#cash change

  $sql="select sum(cash)  total from cash_change_hisroty where  ts>= $dayBegTime and ts <=$dayEndTime and cash< 0";
  if($appId ne 10000){
	$sql="select sum(cash) total from cash_change_hisroty where  ts>= $dayBegTime and ts <=$dayEndTime and cash < 0 and appId=$appId"; 
 }
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  my $cash = 0;
  while (my @row = $sth->fetchrow_array)
  {
        $cash = defined $row[0] ? $row[0] : 0;
  }
  $sth->finish();
	$cash*=-1;

#bind user stat

  $sql="select count(1) bind_count from stat.agency where bind_ts > $dayBegTime and bind_ts <= $dayEndTime and level=0 and stat=0";
  if($appId ne 10000){
	$sql="select count(1) bind_count from stat.agency where bind_ts > $dayBegTime and bind_ts <= $dayEndTime and level=0 and upper_id > 0 and game_id = $appId and stat=0";
  }
	print $sql . "\n";
  $sth = getStatDb()->prepare($sql);
  $sth->execute();
  if($DBI::errstr){print $sql . "\n";}
  my $bind_count = 0;
  while (my @row = $sth->fetchrow_array)
  {
        $bind_count = defined $row[0] ? $row[0] : 0;
  }
  $sth->finish();

  $sql = "replace into stat.key_data (appId,date,allUser,newUser,dau,dou,fee,feeCount,juShu,jieSuanJuShu,cash,bindCount) values($appId,$date,$all,$dnu,$dau,$dou,$money,$fee,$juShu,$jieSuanJuShu,$cash,$bind_count)";
 print $sql; 
	$sth = getStatDb()->prepare($sql);
  $sth->execute();
  printInfo($0,2);
