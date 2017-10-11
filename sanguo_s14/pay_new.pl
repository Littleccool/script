#!/usr/bin/perl

$numbers=@ARGV;

use JSON;
use Data::Dumper;
my $json = new JSON;

$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/datalog";
$monitor_path="/usr/local/monitor_sanguo_s14";
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ tr/\r\n//d;
}
$DateYesterday = `date -d "1 days ago $Date" +%Y%m%d`;
$DateYesterday =~ tr/\r\n//d;
$DateBegin = `date -d "$Date" +%s`;
$DateBegin =~ tr/\r\n//d;
$DateEnd = `date -d "$Date 23:59:59" +%s`;
$DateEnd =~ tr/\r\n//d;

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sanguo = &setDBSanguo();
$dbh_stat = &setDBStat();

$sql = sprintf("select uid from pay_history where status=1");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$IsPayedUser{$uId} = 1;
}
$sth->finish();

$myAllUserFile = sprintf(">%s/data/newuser/pay_%s.txt",$monitor_path,$Date);
unless(open(PAYNEWUSERFILE, $myAllUserFile))
{
	print 'can not open file ' . $myAllUserFile . "!\n";
	exit -1;
}

$begin_second=`date -d $Date +%s`;
$end_second=`date -d "$Date 23:59:59" +%s`;
$begin_second =~ tr/\r\n//d;
$end_second =~ tr/\r\n//d;
$sql = sprintf("select uid,register_time,point,level,tutorial_stage,0,invite_uid,last_login_platform from user");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	
	$CreateTime{$uId} = $row[1];
	$Points{$uId} = $row[2]+$row[5];
	$Level{$uId} = $row[3];
	$Tutorialstage{$uId} = $row[4];
	$invite_uid = $row[6];
	$last_login_platform = $row[7];
	$Openid{$uId} = '';
	if($CreateTime{$uId}>=$DateBegin  && $CreateTime{$uId}<=$DateEnd) #new user;
	{
		if($IsPayedUser{$uId})
		{
			print PAYNEWUSERFILE $uId . "\n";
		}
	}
}
$sth->finish();
$DNU=$all_rookie_count;

close(PAYNEWUSERFILE);
$dbh_sanguo->disconnect();
exit;

