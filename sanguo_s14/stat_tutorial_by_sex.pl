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

$sql = sprintf("select uid,name,figure_url,platform,gender from user_basic");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$Name{$uId} = $row[1];
	$Figure{$uId} = $row[2];
	$platform{$uId} = $row[3];
	$gender{$uId} = $row[4];
}
$sth->finish();

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
	if($CreateTime{$uId}>=$DateBegin  && $CreateTime{$uId}<=$DateEnd && $last_login_platform!=7) #new user;
	{

		$all_rookie_count++;
		if($invite_uid > 0)
		{
			$DIUed++;
		}
		if(!$InviteUserMarked{$invite_uid})
		{
			$DIU++;
			$InviteUserMarked{$invite_uid} = 1;
		}
		($RookieTutorialstage->{$Tutorialstage{$uId}})++;
		if($gender{$uId} == 1)
		{
			$male_count++;
		}
		else
		{
			$female_count++;
		}
		if($Tutorialstage{$uId} == 10000)
		{
			if($gender{$uId} == 1)
			{
				$male_sucess_count++;
			}
			else
			{
				$female_sucess_count++;
			}
		}
		if($Tutorialstage{$uId} == 1)
		{
			if($gender{$uId} == 1)
			{
				$male_1_count++;
			}
			else
			{
				$female_1_count++;
			}
		}
		if($Tutorialstage{$uId} == 10)
		{
			if($gender{$uId} == 1)
			{
				$male_10_count++;
			}
			else
			{
				$female_10_count++;
			}
		}
	}
}
$sth->finish();
$DNU=$all_rookie_count;
printf("total:%d,male:%d,female:%d\n",$all_rookie_count,$male_count,$female_count);
printf("percentage all :%.2f%%,male:%.2f%%,female:%.2f%%\n",100*($male_sucess_count+$female_sucess_count)/$all_rookie_count,100*$male_sucess_count/$male_count,100*$female_sucess_count/$female_count);
printf("stage 1:%.2f%%,male:%.2f%%,female:%.2f%%\n",100*($male_1_count+$female_1_count)/$all_rookie_count,100*$male_1_count/$male_count,100*$female_1_count/$female_count);
printf("stage 2:%.2f%%,male:%.2f%%,female:%.2f%%\n",100*($male_10_count+$female_10_count)/$all_rookie_count,100*$male_10_count/$male_count,100*$female_10_count/$female_count);

