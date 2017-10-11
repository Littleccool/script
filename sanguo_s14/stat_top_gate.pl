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

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sanguo = &setDBSanguo();

$sql = sprintf("select uid,data from gate ");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$userid = $row[0];
	$data = $row[1];
	my $obj = decode_json($data);
	$gate_id = $obj->{id};
	$win = $obj->{w};
	$score = $obj->{s};
	if($win>0)
	{
		$cmd = sprintf('$S%s{"%s"}=%d',$gate_id,$userid,$score);
		#printf("%s\n",$cmd);
		eval($cmd);
		$IsGate{$gate_id} = 1;
	}
}
$sth->finish();

$sql = sprintf("select uid,name from user_basic");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$userid = $row[0];
	$name = $row[1];
	$NameOfId{$userid} = $name;
}
$sth->finish();

foreach $key ( keys(%IsGate))
{
	$FileName = sprintf(">/usr/local/monitor_sanguo_s14/data/gate/top_%d.txt",$key);
	unless(open(TOPFILE, $FileName)) 
	{
		print "can not open file " . $FileName . "!\n";
		exit -1;
	}
	$cmd = sprintf('
		foreach $uid (sort {$S%s{$b} <=> $S%s{$a} }keys(%S%s))
		{
			$sTemp = sprintf("$uid\t$NameOfId{$uid}\t$S%s{$uid}\n");
			print TOPFILE $sTemp;
		}
	',$key,$key,$key,$key,$key);
	#printf("%s\n",$cmd);
	eval($cmd);
	close(TOPFILE);
}

$dbh->disconnect();
