#!/usr/bin/perl
use Time::Local;
#use CGI;
use DBI;
use Switch;
use Data::Dumper;
require "/usr/local/script/sub.pl";

$sql = "select appId ,uid,sum(rmb) total from  pay_history  group by appId,uid";		
print $sql . "\n";
my @array=();
my $sth = getStatDb()->prepare($sql);
$sth->execute();
my $index = 0;
while (my @row = $sth->fetchrow_array)
{
	$sql = "update game_user set rmb=$row[2] where appId=$row[0] and uid=$row[1] limit 1";
	print $sql . "\n" ;
	my $sth1 = getStatDb()->prepare($sql);
	$sth1->execute();
	$sth1->finish();

}
$sth->finish();



		
printInfo($0,2);

