#!/usr/bin/perl

$numbers=@ARGV;

$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/log/business";
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

$sql = "select uid,sum(credit) as total from pay_history where status=1 and time<=$DateEnd and time>=$DateBegin group by uid order by total desc limit 10;";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i = 0;
$topCredit = "";
while (@row = $sth->fetchrow_array){
	if ($i > 0){
		$topCredit .= ",";
	}
	$topCredit .= $row[0] . "_" . $row[1];
	$i++;
}
$sth->finish();

$FileName = sprintf("%s/orders_%s.log",$log_path,$Date);
unless(open(MYFILE, $FileName)){
	print "can not open file" . $FileName . "!\n";
	exit -1;
}
while (my $line=<MYFILE>) {
	$line =~ tr/\r\n//d;
	my @list=split(/\|/,$line);
	$number = @list;
	if($number!=2)
	{
		next;
	}
	foreach my $key ( keys(%Value)){
		delete ($Value{$key});
	}
	my @list2 = split(/\&/,$list[1]);
	for($i=0; $i<@list2; $i++)
	{
		my @pair = split(/\=/,$list2[$i]);
		$Value{$pair[0]} = $pair[1];
	}
	if($Value{"uid"} !~ /^\d+$/){
		next;
	}
	if ($Value{"amount"} > 0){
		if ($Value{"price"} < 0){
			$orders{$Value{"uid"}} += 0 - $Value{"price"} * $Value{"amount"};
		} elsif ($Value{"price"} > 0){
			$ordersSend{$Value{"uid"}} += $Value{"price"} * $Value{"amount"};
		}
	}
}
$i = 0;
$topOrders = "";
foreach my $uid (sort {$orders{$b} <=> $orders{$a} }keys(%orders)) {
	if ($i > 0){
		$topOrders .= ",";
	}
	$topOrders .= $uid . "_" . $orders{$uid};
	$i++;
	if ($i >= 10){
		last;
	}
}
$i = 0;
$topOrdersSend = "";
foreach my $uid (sort {$ordersSend{$b} <=> $ordersSend{$a} }keys(%ordersSend)) {
	if ($i > 0){
		$topOrdersSend .= ",";
	}
	$topOrdersSend .= $uid . "_" . $ordersSend{$uid};
	$i++;
	if ($i >= 10){
		last;
	}
}

$logfile = sprintf("%s/data/rmbuserpay/topuser_%s.log", $monitor_path, $Date);
$outfile = ">" . $logfile;
open(MYFILE, $outfile) || die("write fail");
print MYFILE $topCredit,"|",$topOrders,"|",$topOrdersSend;
close(MYFILE);
`chmod 777 $logfile`
