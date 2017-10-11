#! /usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;
use Time::Local;
require "/usr/local/script/sub.pl";

if(@ARGV ne 2){
	print "usage: return_rate.pl appId date";
	exit;
}

my $appId = defined $ARGV[0] ? $ARGV[0] : 0;

my $date = defined $ARGV[1] ? $ARGV[1] : `date -d "1 days ago" +"%Y%m%d"`;
   $date =~ tr/\n//d;
die "date error" unless (length($date) == 8);

my $year = substr($date, 0, 4) + 0;
my $month = substr($date, 4, 2) + 0;
my $day = substr($date, 6, 2) + 0;
my $dayBegTime = timelocal(0, 0, 0, $day, $month - 1, $year - 1900);
my $dayEndTime = timelocal(59, 59, 23, $day, $month - 1, $year - 1900);
for(my $i = 1; $i < 31; $i++)
{
	my $time1 = $dayBegTime - $i * 3600 * 24;
	my $time2 = $dayEndTime - $i * 3600 * 24;
    my $date1 = dateTimeToString2($time1);
	if($date1 < 20170720)
	{
		last;
	}

	my $sql;
	my $sth;
	my $dnu = 0;
	my $noRole = 0;
	
	if($i == 1)
	{
	    $sql = "select count(*) from stat.game_user where appId = $appId and regTs>=$time1 and regTs<=$time2";
	#print $sql . "\n";		
		if($appId eq 10000){
			$sql = "select count(*) from stat.game_user where  regTs>=$time1 and regTs<=$time2";
		}else{
			$sql = "select count(*) from stat.game_user where appId = $appId and regTs>=$time1 and regTs<=$time2";
		}
		$sth = getStatDb()->prepare($sql);
		$sth->execute();
		if($DBI::errstr){print $sql . "\n";}
		while (my @row = $sth->fetchrow_array)
		{
		  $dnu = $row[0];
		}
		$sth->finish();

	    $sql = "replace into return_rate values($appId,$date1,$dnu,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)"; 
		$sth = getStatDb()->prepare($sql);
		$sth->execute();
		if($DBI::errstr){print $sql . "\n";}
		$sth->finish();
	}
	else	
	{
	
		$sql = "select dnu from return_rate where appId = $appId and date=$date1";
		$sth = getStatDb()->prepare($sql);
		$sth->execute();
		if($DBI::errstr){print $sql . "\n";}
		while (my @row = $sth->fetchrow_array)
		{
		  $dnu = $row[0];
		}
		$sth->finish();
		
#		print $sql  . "  " ;	
	}

	my $count = 0;
 
	
	if($appId eq 10000){
  	$sql = "select count(A.uid) from user_login as A,game_user as B where A.loginDate=$date and B.regTs >= $time1 and B.regTs <= $time2 and A.appId = B.appId and A.uid = B.uid";	
	}else{
  	$sql = "select count(A.uid) from user_login as A,game_user as B where A.loginDate=$date and B.regTs >= $time1 and B.regTs <= $time2 and A.appId = $appId and A.appId = B.appId and A.uid = B.uid";	
	}
	
	$sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	while (my @row = $sth->fetchrow_array)
	{
	   $count = $row[0];
	}

	my $sum = 0;
	if($dnu != 0)
	{
		$sum = $count/$dnu;
	}
	
	print $sql . "  " . $i . "  " . $dnu . "   " . $sum . "  ";	
	$sql = sprintf("update stat.return_rate set d%d=%0.3f where appId = %d and date='%s'",$i,$sum,$appId,$date1);
	$sth = getStatDb()->prepare($sql);
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	print $sql . "\n";
}
 printInfo($0,2);

