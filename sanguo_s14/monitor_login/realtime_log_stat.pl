#!/usr/bin/perl


use DBI;
require "/usr/local/script/sanguo/set_db.pl";
$dbh_stat = &setDBStat();

sub ReadNewFiles
{
	my ($Date) = @_;
	my $i=0;
	for($i=1;$i<=30;$i++)
	{
		if($i>7 && $i!=14 && $i!=30){next;}
		#my $cmd = sprintf("date -d \"%d days ago\" +%Y%m%d",$i);
		$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
		$myDate =~ tr/\r\n//d;
		$myFile = sprintf("/usr/local/monitor_sanguo/data/return/new_%s.txt",$myDate);
		unless(open(NEWFILE, $myFile))
		{
			print 'read new Files:can not open file ' . $myFile. "!\n";
			#exit -1;
		}
		while ($line=<NEWFILE>) 
		{
			$line =~ tr/\r\n//d;
			$ReturnDaysByUid{$line} = $i;
		}
		close(NEWFILE);		
	}
	
}


sub RealtimeLogStat
{
	my ($line) = @_;
	foreach $key ( keys(%Value))
	{
		delete ($Value{$key});
	}
	my @list=split(/\|/,$line);
	my $number = @list;
	#print $line;
	$op = $list[1];
	$direction = $list[3];	
	if($op ne "promotion"){return;}
	$Value{"iopenid"} = "";
	@list2 = split(/\&/,$list[4]);
	my $i=0;
	for($i=0;$i<@list2;$i++)
	{
		@pair = split(/\=/,$list2[$i]);
		$Value{$pair[0]} = $pair[1];
	}
	if($Value{"uId"} !~ /^\d+$/)
	{
		$Value{"uId"} = $Value{"uid"};
		if($Value{"uId"} !~ /^\d+$/)
		{
			return;
		}
	}
	if($Value{"iopenid"} eq "B007A635E0D52CA1B2FF405C19EEAC0A")
	{
		$cp = 'js';
		$uId = $Value{"uId"};
		if($Value{"uId"})
		{
			if(!$UidMarkedJs{$uId})
			{
				$IsUidMarkedJs{$uId} = 1;
				if($ReturnDaysByUid{$uId}) #old user
				{
					$ReturnCountByDayJS{$ReturnDaysByUid{$uId}}++;
				}
				else #new user
				{
					$all_rookie_count_js++;			
					$IsNew{$uId} = 1;
				}
			}
		}
	}
	elsif($Value{"iopenid"} eq "0000000000000000000000000C997000")
	{
		$cp = 'sz';
		$uId = $Value{"uId"};
		if($Value{"uId"})
		{
			if(!$UidMarkedSz{$uId})
			{
				$IsUidMarkedSz{$uId} = 1;
				if($ReturnDaysByUid{$uId}) #old user
				{
					$ReturnCountByDaySZ{$ReturnDaysByUid{$uId}}++;
				}
				else #new user
				{
					$all_rookie_count_sz++;					
					$IsNew{$uId} = 1;
				}
			}
		}
	}
	else
	{
		return;
	}
}

sub WriteRealtimeResult
{
	my ($Date) = @_;
	$myFile = sprintf(">/usr/local/monitor_sanguo/data/return/new_%s.txt",$Date);
	unless(open(PK_OUTFILE, $myFile))
	{
		print 'can not open file ' . $myFile. "!\n";
		#exit -1;
	}
	my $i=0;
	foreach $uId (keys(%IsNew)) {
		my $sTemp = sprintf("%d\n",$uId);
		print PK_OUTFILE $sTemp;
	}
	close(PK_OUTFILE);
	
	$i=0;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("replace into table_other_return(date,all_rookie_count,d1,d2,d3,d7,cp) values(\'%s\',%d,0,0,0,0,\'js\')", $myDate,$all_rookie_count_js,);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=1;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d1=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"1"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=2;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d2=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"2"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=3;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d3=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"3"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=4;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d4=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"4"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=5;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d5=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"5"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=6;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d6=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"6"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=7;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d7=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"7"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=14;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d14=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"14"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=30;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d30=%d where date=\'%s\' and cp=\'js\'",$ReturnCountByDayJS{"30"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	
	
	$i=0;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("replace into table_other_return(date,all_rookie_count,d1,d2,d3,d7,cp) values(\'%s\',%d,0,0,0,0,\'sz\')", $myDate,$all_rookie_count_sz,);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=1;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d1=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"1"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=2;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d2=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"2"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=3;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d3=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"3"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=4;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d4=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"4"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=5;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d5=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"5"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=6;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d6=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"6"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=7;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d7=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"7"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=14;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d14=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"14"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	$i=30;
	$myDate = `date -d "$i days ago $Date" +%Y%m%d`;
	$myDate =~ tr/\r\n//d;	
	$sql = sprintf("update table_other_return set d30=%d where date=\'%s\' and cp=\'sz\'",$ReturnCountByDaySZ{"30"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
}
1;

