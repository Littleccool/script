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
#$dbh_toy = &setDBToy();
$dbh_sanguo = &setDBSanguo();
$dbh_stat = &setDBStat();

$sql = sprintf("select uid,time from pay_history where status=1 order by time");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$userid = $row[0];
	if(!$FirstPayTime{$userid})
	{
		$FirstPayTime{$userid} = $row[1];
	}
	$LastPayTime{$userid} = $row[1];
}
$sth->finish();

$sql = sprintf("select uid,register_time,last_login_time from user where from_unixtime(register_time)>\'2012-01-17\'");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$userid = $row[0];
	$all_stat_user_count++;
	if(!$FirstPayTime{$userid})
	{
		next;
	}
	$register_time = $row[1];
	$days_first_paid = ($FirstPayTime{$userid} - $register_time)/(24*60*60);
	if($days_first_paid>20)
	{
		printf("%d:\t%.2f\n",$userid,$days_first_paid);
	}
	$all_fee_count++;
	$all_fee_time += $days_first_paid;
	if($days_first_paid < 0.5)
	{
		$FirstPayDay{"0.5"}++;
	}
	elsif($days_first_paid < 1)
	{
		$FirstPayDay{"1"}++;
	}
	elsif($days_first_paid < 2)
	{
		$FirstPayDay{"2"}++;
	}
	elsif($days_first_paid < 3)
	{
		$FirstPayDay{"3"}++;
	}
	elsif($days_first_paid < 4)
	{
		$FirstPayDay{"4"}++;
	}
	elsif($days_first_paid < 5)
	{
		$FirstPayDay{"5"}++;
	}
	elsif($days_first_paid < 6)
	{
		$FirstPayDay{"6"}++;
	}
	elsif($days_first_paid < 7)
	{
		$FirstPayDay{"7"}++;
	}
	elsif($days_first_paid < 8)
	{
		$FirstPayDay{"8"}++;
	}
	elsif($days_first_paid < 9)
	{
		$FirstPayDay{"9"}++;
	}
	else
	{
		$FirstPayDay{"9+"}++
	}
}
$sth->finish();
$dbh->disconnect();


printf("all stat user:%s,fee user:%d\t%.4f%%\n",$all_stat_user_count,$all_fee_count,$all_fee_count/$all_stat_user_count);
printf("all fee user:%s,average first fee day:%.2f\n",$all_fee_count,$all_fee_time/$all_fee_count);
foreach $key ( sort keys(%FirstPayDay))
{
	printf("%s:%d\t%.2f%%\n",$key,$FirstPayDay{$key},100*$FirstPayDay{$key}/$all_fee_count);
}

