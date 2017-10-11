#!/usr/bin/perl


use DBI;
require "/usr/local/script/sanguo/set_db.pl";
$dbh_stat = &setDBStat();

$numbers=@ARGV;
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date +%Y%m%d`;
	$Date =~ tr/\r\n//d;
}

&ReadNewFiles($Date);
$log_path="/usr/local/script/sanguo/log";
$myTodayData=sprintf("%s/red_%s.log",$log_path,$Date);
unless(open(TODAYDATA,$myTodayData))
{
	#print "can not open file $myTodayData";
	exit -1;
}
while ($line=<TODAYDATA>) 
{
	#$line=<TODAYDATA>; 
	
	$line =~ tr/\r\n//d;
	@list=split(/\|/,$line);
	$numbers=@list;
	if($numbers != 3)
	{
		#printf("skipping..number:%d:%s\n",$numbers,$line);
		next;
	}
	
	&RealtimeLogStat($line);
}
&WriteRealtimeResult($Date);
close(TODAYDATA);

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
			#print 'read new Files:can not open file ' . $myFile. "!\n";
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
	@list2 = split(/\&/,$list[1]);
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

	{
		$cp = 'sl';
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
	$sql = sprintf("replace into table_other_return(date,all_rookie_count,d1,d2,d3,d7,cp) values(\'%s\',%d,0,0,0,0,\'sl\')", $myDate,$all_rookie_count_js,);
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
	$sql = sprintf("update table_other_return set d1=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"1"},$myDate);
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
	$sql = sprintf("update table_other_return set d2=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"2"},$myDate);
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
	$sql = sprintf("update table_other_return set d3=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"3"},$myDate);
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
	$sql = sprintf("update table_other_return set d4=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"4"},$myDate);
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
	$sql = sprintf("update table_other_return set d5=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"5"},$myDate);
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
	$sql = sprintf("update table_other_return set d6=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"6"},$myDate);
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
	$sql = sprintf("update table_other_return set d7=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"7"},$myDate);
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
	$sql = sprintf("update table_other_return set d14=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"14"},$myDate);
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
	$sql = sprintf("update table_other_return set d30=%d where date=\'%s\' and cp=\'sl\'",$ReturnCountByDayJS{"30"},$myDate);
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
	
	
}
