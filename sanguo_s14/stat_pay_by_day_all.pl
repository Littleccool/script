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
$dbh_sgonline_s14 = &setDBSanguo();

$sql = "select uid,from_unixtime(register_time,'%Y%m%d') from user where register_time<=$DateEnd and register_time>=$DateBegin-24*60*60*99;";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$minUid = 2000000000;
$maxUid = 0;
$newUsers = 0;
while (@row = $sth->fetchrow_array)
{
	my $uId = $row[0];
	$register_date{$uId} = $row[1];
	if ($row[1] == $Date){
		$newUsers++;
		if ($uId < $minUid){$minUid = $uId};
		if ($uId > $maxUid){$maxUid = $uId};
	}
}
$sth->finish();

$vipAmount = 0;
if ($minUid <= $maxUid){
	$sql = "select count(DISTINCT uid) from user_basic where vip_type<>0 and uid>=$minUid and uid<=$maxUid;";
	$dbh = $dbh_sgonline_s14;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	@row = $sth->fetchrow_array;
	$vipAmount = $row[0];
	$sth->finish();
}

$sql = "select uid,sum(credit) from pay_history where status=1 and time<=$DateEnd and time>=$DateBegin group by uid;";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array){
	$uId = $row[0];
	$credit = $row[1];
	if ($register_date{$uId}){
		my $dateTmp = $register_date{$uId};
		$datePayUsers{$dateTmp}++;
		$datePaySum{$dateTmp} += $credit;
	}
}
$sth->finish();

$logfile = sprintf("%s/data/rmbuserpay/paybyday_%s.log", $monitor_path, $Date);
$outfile = ">" . $logfile;
if (open(MYFILE, $outfile)){
	print MYFILE $newUsers,"|";
	$i = 0;
	foreach $key ( keys(%datePayUsers)){
		if ($i > 0){
			print MYFILE ",";
		}
		printf MYFILE ("%s_%d_%d",$key,$datePayUsers{$key},$datePaySum{$key});
		$i++;
	}
	print MYFILE "|",$vipAmount;
	close(MYFILE);
}
`chmod 777 $logfile`
