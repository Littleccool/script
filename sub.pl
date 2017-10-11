#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use Data::Dumper;

#最大服数
$::MSC = 200;
#DB连接
$::STATCON = 0;
$::DBCON = 0;
$::INFOFILENAME = "/usr/local/script/script.log";
#内部号uid
#内部号rid
$::notFeeRid = {};

my $dbIp = "10.135.72.229";
my $statIp = "10.135.72.229";
my $db_user = "root";
my $db_pass = "1234";

sub getDb()
{
	if($::DBCON){return $::DBCON}
	my $dsn = "DBI:mysql:database=stat:$dbIp";
	$::DBCON = DBI->connect($dsn,$db_user,$db_pass);
	$::STATCON->do("set names utf8mb4");
	return $::DBCON;
}

sub getStatDb()
{
	if($::STATCON){return $::STATCON}
	my $dsn = "DBI:mysql:database=stat:$statIp";
	$::STATCON = DBI->connect($dsn,$db_user,$db_pass);
	$::STATCON->do("set names utf8mb4");
	return $::STATCON;
}

sub dateTimeToString2
{
        my ($sec, $min, $hour, $day, $mon, $year) = localtime($_[0]);
        $year += 1900;
        $mon += 1;
        return sprintf("%04d%02d%02d", $year, $mon, $day);
}

sub printInfo
{
	my $call = shift;
	my $info = shift;
	my $str = qx (date +'%Y-%m-%d %H:%M:%S');
	chomp($str);
	print qx (echo '$str|$call|$info' >> $::INFOFILENAME);
}
