#!/usr/bin/perl

$numbers=@ARGV;
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date +%Y%m%d`;
	$Date =~ s/\r//;
	$Date =~ s/\n//;
}

require "/usr/local/script/sanguo/monitor_login/realtime_log_stat.pl";
&ReadNewFiles($Date);

$script_path="/usr/local/script/sanguo/monitor_login";
$log_path="/data/release/sgonline/datalog";
$monitor_path="/usr/local/monitor_sanguo";
$cmd = $script_path . "/get_web.pl $Date";
$TimeDateEnd = `date -d "$Date" "+%Y%m%d 23:59:59"`;
$TimeDateEnd =~ s/\r//;
$TimeDateEnd =~ s/\n//;
use DBI;


require "/usr/local/script/sanguo/set_db.pl";
$dbh_sanguo = &setDBSanguo();
$dbh=$dbh_sanguo;

$myAverageData=sprintf("%s/data/login/average.txt",$monitor_path);
unless(open(AVERAGE_DATA, $myAverageData))
{
	print "can not open file $myAverageData";
	exit -1;
}

while ($line=<AVERAGE_DATA>) 
{
	$line =~ s/\r//;
	$line =~ s/\n//;
	@list=split(/\t/,$line);
	if(index($list[0],"|") < 0)
	{
		$Average{$list[0]} = $list[1];
		$Count{$list[0]} = 0;
		$Warning{$list[0]} = "none";
	}
	if(index($list[0],$WeekOfDay . "|") >= 0)
	{
		#print $line . "\n";
		@TimeList=split(/\|/,$list[0]);
		$TimeStat = $TimeList[1];
		$WeekAverage{$TimeStat} = $list[1];
	}
}
close(AVERAGE_DATA);

$myTodayData=sprintf("%s/data_%s.log",$log_path,$Date);
$myOutfile=sprintf(">%s/data/login/monitor_%s.txt",$monitor_path,$Date);
$myWarninglog=sprintf(">%s/data/login/warning_%s.txt",$monitor_path,$Date);
unless(open(TODAYDATA,$myTodayData))
{
	print "can not open file $myTodayData";
	exit -1;
}
unless(open(OUTFILE, $myOutfile))
{
	print "can not open file $myOutfile";
	exit -1;
}
unless(open(WARNINGLOG, $myWarninglog))
{
	print "can not open file $myWarninglog";
	exit -1;
}

$TimeNow = `date "+%Y%m%d %H:%M" -d "1 minutes ago"`;
$TimeNow =~ tr/\r\n//d;

$IsNextDay = "no";
while (1) 
{
	$line=<TODAYDATA>; 
	if( !$line)
	{
		if($IsNextDay eq "yes")	{ last; }
		else
		{
			foreach $keyStat (sort keys(%IsWrite))
			{
				if($keyStat ne $TimeStat && $IsWrite{$keyStat} eq "no")
				{
					#InsertRealtimeData($keyStat,$Count{$keyStat},$Money{$keyStat});
					$strOut = sprintf("%s\t%s\n",$keyStat,$Count{$keyStat});
					print OUTFILE $strOut;
					$IsWrite{$keyStat} = "yes";	
					system($cmd);			
				}
			}
			DoWarningSearch();		
			sleep(60);
			#printf("sleeping: line=null\n");
			system($cmd);
			WriteRealtimeResult($Date);
			$TimeNow = `date "+%Y%m%d %H:%M" -d "1 minutes ago"`;
			$TimeNow =~ tr/\r\n//d;
			$TimeStat = substr($TimeNow,0,15);
			#printf("%s\n",$TimeStat);
			if($TimeNow ge $TimeDateEnd)
			{	
				printf("note:%s > %s,next day come\n",$TimeNow,$TimeDateEnd);
				$IsNextDay = "yes";
			}
		}
	}

	#print $line;
	
	#$line =~ s/\r//;
	#$line =~ s/\n//;
	$line =~ tr/\r\n//d;
	@list=split(/\|/,$line);
	
	$numbers=@list;
	if($numbers != 5)
	{
		#printf("skipping..number:%d:%s\n",$numbers,$line);
		next;
	}
	if($list[0] =~ /^(20\d\d\d\d\d\d) (\d\d):(\d)(\d):(\d\d)/)
	{
		if($4>=5){$min_last=5;}else{$min_last=0;}
		$TimeStat=sprintf("%s %s:%01d%01d",$1,$2,$3,$min_last);
		$LogTime= sprintf("%s %02d:%01d%01d",$1,$2,$3,$4);
	}
	else
	{
		next;
	}
	RealtimeLogStat($line); #for stat real.
	if($list[1] eq "updatesave" && $list[3] eq "send")
	{
		if($list[4] =~ /uid\=([0-9]+)\&userid\=/)
		{
			$uId = $1;
			$LastOnlineTime{$uId} = $TimeStat;
		}
		else
		{
			next;
		}
	}
	elsif($list[1] ne "login" || $list[3] ne "send")
	{
		next;
	}
	#$TimeStat=substr($list[0],0,16);
	#printf("%s\n",$TimeStat);
	$Count{$TimeStat} += 1;
	#printf("%s,%s:count+1\n",$TimeStat,$list[7]);
	if($Count{$TimeStat} == 1)	{$IsWrite{$TimeStat} = "no";}

	if($LogTime ge $TimeNow)
	{
		foreach $keyStat (sort keys(%IsWrite))
		{
			if($keyStat ne $TimeStat && $IsWrite{$keyStat} eq "no")
			{
				#printf("writing:%s>=%s\n",$keyStat,$TimeStat);
				
				$strOut = sprintf("%s\t%s\n",$keyStat,$Count{$keyStat});
				DoWarning($keyStat,$Count{$keyStat});
				#InsertRealtimeData($keyStat,$Count{$keyStat},$Money{$keyStat});
				print OUTFILE $strOut;
				$IsWrite{$keyStat} = "yes";	
				system($cmd);			
			}
		}	
		sleep(60);
		WriteRealtimeResult($Date);
		printf("sleeping:%s>=%s\n",$LogTime,$TimeNow);
		$TimeNow = `date "+%Y%m%d %H:%M" -d "1 minutes ago"`;
		$TimeNow =~ tr/\r\n//d;
		if($TimeNow ge $TimeDateEnd)
		{
			printf("Note:%s > %s,next day come\n",$TimeNow,$TimeDateEnd);
			$IsNextDay = "yes";
		}
	}
	
}
close(TODAYDATA);
$dbh->disconnect();

foreach $keyStat (sort keys(%IsWrite))
{
	if($IsWrite{$keyStat} eq "no")
	{
		$strOut = sprintf("%s\t%s\n",$keyStat,$Count{$keyStat});
		#InsertRealtimeData($keyStat,$Count{$keyStat},$Money{$keyStat});
		print OUTFILE $strOut;
		$IsWrite{$keyStat} = "yes";	
		system($cmd);			
	}
}
close(OUTFILE);
close(WARNINGLOG);

sub DoWarning()
{
	($kStat,$kCount) = @_;
	
	$kStat=substr($kStat,11,4);
	if($kCount< ($Average{$kStat}*0.35) && $kCount< ($WeekAverage{$kStat}*0.35) && $Average{$kStat}>1200)
	{
		$Last10Min = `date "+%Y-%m-%d %H:%M" -d "10 minutes ago"`;
		$Last10Min =~ s/\r//;
		$Last10Min =~ s/\n//;
		$Last10Min = substr($Last10Min,11,4);
		print WARNINGLOG "Last10Mini=" . $Last10Min . "kStat=" . $kStat . ",kCount=" . $kCount . ",average=" . $Average{$kStat} . ",WeekAverage=" . $WeekAverage{$kStat} . "\n";
		if($kStat eq $Last10Min && $Warning{$kStat} eq "none")
		{
			$Warning{$kStat} = "warning";
			$WarningCmd = sprintf('/usr/bin/wget "http://tm.log.pala5.cn:84/cgi-bin/alarm.pl?type=login&title=loginwarning&content=LoginCountIs%s" -O /tmp/alarm_login.htm',$kCount);
			#system($WarningCmd);
			print WARNINGLOG $WarningCmd . "\n";
			$WarningCmd = "";
		}
	}
	else
	{
		$Warning{$kStat} = "nowarning";
	}
}

sub DoWarningSearch()
{
	$Last10Min = `date "+%Y-%m-%d %H:%M" -d "10 minutes ago"`;
	$Last10Min =~ s/\r//;
	$Last10Min =~ s/\n//;
	$Last10Min = substr($Last10Min,11,4);
	if($Last10Min ne "23:5")
	{
		if($Warning{$Last10Min} eq "none" && $Count{$Last10Min}< ($Average{$Last10Min}*0.35) && $Count{$Last10Min}< ($WeekAverage{$Last10Min}*0.35))
		{
			$Warning{$Last10Min} = "warning";
			$WarningCmd = sprintf('/usr/bin/wget "http://tm.log.pala5.cn:84/cgi-bin/alarm.pl?type=login&title=loginwarning&content=LoginCountIs%s" -O /tmp/alarm_login.htm',$Count{$Last10Min});
			#system($WarningCmd);
			print WARNINGLOG $WarningCmd . "\n";
			$WarningCmd = "";
		}
	}
}

sub InsertRealtimeData
{
	my($TimeStat,$Count) = @_;
	
	my @list = split(/\ /,$TimeStat);
	$TimeStat = $list[1];
	$TimeStat .= "0";
	$sql = sprintf("select Date from table_login_stat where Date=\'%s\' and time=\'%s\'",$Date,$TimeStat);
	#print $sql . "\n";
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	if (@row = $sth->fetchrow_array)
	{
		$sql = sprintf("update table_login_stat set count=%d where Date=\'%s\' and time=\'%s\'",$Count,$Date,$TimeStat);
	}
	else
	{
		$sql =  sprintf("insert into table_login_stat (date,time,count) values (\'%s\',\'%s\',%d)",	$Date,$TimeStat,$Count);
	}
	$sth->finish();
	#print $sql . "\n";
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();	
		
}


