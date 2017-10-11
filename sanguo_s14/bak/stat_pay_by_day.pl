#!/usr/bin/perl

$numbers=@ARGV;

use JSON;
use Data::Dumper;
my $json = new JSON;

$script_path="/usr/local/script/sanguo";
$log_path="/data/release/sanguo/datalog";
$monitor_path="/usr/local/monitor_sanguo";
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

require "/usr/local/script/sanguo/set_db.pl";
$dbh_sanguo = &setDBSanguo();
$dbh_stat = &setDBStat();

$sql = sprintf("select uid,register_time from user where substring(from_unixtime(register_time),1,10)>='2012-01-17'");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	my $uId = $row[0];
	$register_time{$uId} = $row[1];
}
$sth->finish();

$sql = sprintf("select uid,credit,time from pay_history");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	if(!$register_time{$uId}){next;}
	$credit = $row[1];
	$time_pass = $row[2]-$register_time{$uId};
	$day_pass = $time_pass/(24*60*60);
	if($day_pass<0.5)
	{
		$fee_day = 0.5;
	}
	elsif($day_pass<1)
	{
		$fee_day = 1;
	}
	elsif($day_pass<2)
	{
		$fee_day = 2;
	}
	elsif($day_pass<3)
	{
		$fee_day = 3;
	}
	elsif($day_pass<4)
	{
		$fee_day = 4;
	}
	elsif($day_pass<5)
	{
		$fee_day = 5;
	}
	elsif($day_pass<6)
	{
		$fee_day = 6;
	}
	elsif($day_pass<7)
	{
		$fee_day = 7;
	}
	elsif($day_pass<8)
	{
		$fee_day = 8;
	}
	elsif($day_pass<9)
	{
		$fee_day = 9;
	}
	else
	{
		$fee_day = "9+";
	}
	$PayCountByDay{$fee_day} ++;
	$PayAllByDay{$fee_day} += $credit;
	$all_pay_count++;
	$all_pay_sum += $credit;
	
}
$sth->finish();


printf("all pay count:%s,pay sum:%.2fRMB\n",$all_pay_count,$all_pay_sum/100);
foreach $key ( sort keys(%PayCountByDay))
{
	printf("%s:%d,%d\t\t%.2f%%\t\t%.2f%%\n",$key,$PayCountByDay{$key},$PayAllByDay{$key},100*$PayCountByDay{$key}/$all_pay_count,100*$PayAllByDay{$key}/$all_pay_sum);
}
