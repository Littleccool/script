#! /usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;
use Time::Local;
require "/usr/local/script/sub.pl";

#####################################################################
#说明:分析充值玩家充值金额分布
#参数:appId或者无参数
#####################################################################
my @chargeLevel=(10,20,50,100,200,500,1000,2000,5000,10000,20000,50000); 
my $appId = defined $ARGV[0] ? $ARGV[0] : 10000;

my $sql = "";
if ($appId > 10000){
	$sql = "select appId,uid,balance from game_user where appId =$appId group by uid";
}else{
	$sql = "select appId,uid,balance from game_user group by appId,uid";
}

my $sth = getStatDb()->prepare($sql);
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
my %hash;
my $chargeCount = 0;
while (my @row = $sth->fetchrow_array)
{
	my $pay=$row[2] + 0;
	if($pay eq 0){
#		next;
	}
#print $row[0] . " " . $row[1] . " " . $row[2] . "\n";	
	$chargeCount++;
	my $value;
	foreach $value (@chargeLevel){  
		if($pay < $value){
			$hash{$value}++;
			last;
		}		
	}
}

$sth->finish();

my $charge10=0;
my $charge20=0;
my $charge50=0;
my $charge100=0;
my $charge200=0;
my $charge500=0;
my $charge1000=0;
my $charge2000=0;
my $charge5000=0;
my $charge10000=0;
my $charge20000=0;
my $charge50000=0;

while(my ($key,$value) = each %hash){

	print $key ." "  . $value . "\n";
	if($key eq 10){
		$charge10 += $value;
	}elsif($key eq 20){
		print "charge20 " . $key ." "  . $value . "\n";
		$charge20 += $value;
	}elsif($key eq 50){
		$charge50 += $value;
	}elsif($key eq 100){
		$charge100 += $value;
	}elsif($key eq 200){
		$charge200 += $value;
	}elsif($key eq 500){
		$charge500 += $value;
	}elsif($key eq 1000){
		$charge1000 += $value;
	}elsif($key eq 2000){
		$charge2000 += $value;
	}elsif($key eq 5000){
		$charge5000 += $value;
	}elsif($key eq 10000){
		$charge10000 += $value;
	}elsif($key eq 20000){
		$charge20000 += $value;
	}else {
		$charge50000 += $value;
	}
}

$sql = "replace balance_distribute values($appId,$charge10,$charge20,$charge50,$charge100,$charge200,$charge500,$charge1000,$charge2000,$charge5000,$charge10000,$charge20000,$charge50000)";
$sth = getStatDb()->prepare($sql);
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
print $sql . "\n";
printInfo($0,2);
