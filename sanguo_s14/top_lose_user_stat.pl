#!/usr/bin/perl

$numbers=@ARGV;



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

$begin_second=`date -d $Date +%s`;
$end_second=`date -d "$Date 23:59:59" +%s`;
$begin_second =~ tr/\r\n//d;
$end_second =~ tr/\r\n//d;
$sql = sprintf("select uid,substring(from_unixtime(register_time),1,10),(unix_timestamp(now())-last_login_time)/86400 as unlogin_days,level,(last_login_time-register_time)/84000 from user");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$RegDate{$uId} = $row[1];
	$UnloginDays{$uId} = $row[2];
	$LevelByUid{$uId} = $row[3];
	$LiveDaysByUid{$uId} = $row[4];
}
$sth->finish();

$i=0;
$sql = sprintf("select uid,sum(credit) as pay from pay_history where status=1 group by uid order by pay desc");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$Credit{$uId} = $row[1];
	
	if($UnloginDays{$uId}>7)
	{
		printf("%s\t%s\t%s\t%s\t%d\t%d\n",$uId,$Credit{$uId},$LevelByUid{$uId},$RegDate{$uId},$LiveDaysByUid{$uId},$UnloginDays{$uId});
		$i++;
		if($i>100)
		{
			last;
		}
	}
}
$sth->finish();

$dbh_sanguo->disconnect();


