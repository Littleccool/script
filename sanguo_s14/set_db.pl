#!/usr/bin/perl

#use DBI;
sub setDBStat{
	my $dsn = 'DBI:mysql:database=db_sanguo_stat_s14:10.142.17.30';
	my $db_user = "root";
	my $db_pass = "1234";
	my $dbh = DBI->connect($dsn, $db_user, $db_pass);
	if($DBI::errstr){print "can not connect the db\n";exit;}
	return $dbh;
}

sub setDBSanguo{
	my $dsn = 'DBI:mysql:database=sgonline_s13:10.207.252.58';
	my $db_user = "root";
	my $db_pass = "1234";
	my $dbh = DBI->connect($dsn, $db_user, $db_pass);
	if($DBI::errstr){print "can not connect the db\n";exit;}
	return $dbh;
}

1;

