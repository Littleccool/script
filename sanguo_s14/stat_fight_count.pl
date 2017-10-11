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

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sanguo = &setDBSanguo();
$dbh_stat = &setDBStat();

$sql = sprintf("select substring(from_unixtime(start_time),1,10) from attack");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	my $myDate = $row[0];
	$FightCount{$myDate}++;
}
$sth->finish();

$dbh = $dbh_stat;
foreach $myDate ( sort keys(%FightCount))
{
	$fight_count = $FightCount{$myDate};
	$myDate =~ tr/\-//d;
	$sql = sprintf("update table_user_day_data_stat set DVC=%d where date=\'%s\'",
		$fight_count,$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
}

$dbh_sanguo->disconnect();
$dbh_stat->disconnect();


