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
$script_path="/usr/local/script/sanguo/login_monitor";
$log_path="/usr/local/monitor_sanguo";
$monitor_path="/usr/local/monitor_sanguo";

$TimeStatNow = `date -d "10 minutes ago" "+%H:%M"`;
$TimeStatNow =~ tr/\r\n//d;
$ChineseToday=`date -d "$Date" +%b%d`;
$ChineseYesterday=`date -d "1 days ago $Date" +%b%d`;
$ChineseBYesterday=`date -d "2 days ago $Date" +%b%d`;
$WeekOfDay=`date -d "$Date" +%w`;
$WeekOfDay =~ tr/\r\n//d;
$Yesterday=`date -d "1 days ago $Date" +%Y%m%d`;
$Yesterday =~ tr/\r\n//d;
$BYesterday=`date -d "2 days ago $Date" +%Y%m%d`;
$BYesterday =~ tr/\r\n//d;
$LastweekDay = `date -d "7 days ago $Date" +%Y%m%d`;
$LastweekDay =~ tr/\r\n//d;
$Chinese{"0"}="Sunday";
$Chinese{"1"}="Monday";
$Chinese{"2"}="Tuesday";
$Chinese{"3"}="Wednesday";
$Chinese{"4"}="Thursday";
$Chinese{"5"}="Friday";
$Chinese{"6"}="Saturday";

$myTodayData=sprintf("%s/data/login/monitor_%s.txt",$log_path,$Date);
$myYestodayData=sprintf("%s/data/login/monitor_%s.txt",$log_path,$Yesterday);
$myBYestodayData=sprintf("%s/data/login/monitor_%s.txt",$log_path,$BYesterday);
$myLastweekdayData=sprintf("%s/data/login/monitor_%s.txt",$log_path,$LastweekDay);
$AverageData = sprintf("%s/data/login/average.txt",$log_path);
unless(open(TODAYDATA, $myTodayData))
{
	print 'can not open file ' . $myTodayData;
	exit -1;
}

while ($line=<TODAYDATA>) 
{
	$line =~ tr/\r\n//d;
	@list=split(/\t/,$line);
	@TimeList=split(/ /,$list[0]);
	$TimeStat = $TimeList[1];
	$TodayCount{$TimeStat} = $list[1];
}
close(TODAYDATA);

unless(open(LASTWEEKDAYDATA, $myLastweekdayData))
{
	print 'can not open file ' . $myLastweekdayData;
	exit -1;
}

while ($line=<LASTWEEKDAYDATA>) 
{
	$line =~ s/\r//;
	$line =~ s/\n//;
	@list=split(/\t/,$line);
	@TimeList=split(/ /,$list[0]);
	$TimeStat = $TimeList[1];
	$LastWeekDayCount{$TimeStat} = $list[1];
}
close(LASTWEEKDAYDATA);


unless(open(YESTERDAYDATA, $myYestodayData))
{
	print 'can not open file ' . $myYestodayData;
	exit -1;
}

while ($line=<YESTERDAYDATA>) 
{
	$line =~ s/\r//;
	$line =~ s/\n//;
	@list=split(/\t/,$line);
	@TimeList=split(/ /,$list[0]);
	$TimeStat = $TimeList[1];
	$YesterdayCount{$TimeStat} = $list[1];
}
close(YESTERDAYDATA);


unless(open(BYESTERDAYDATA, $myBYestodayData))
{
	print 'can not open file ' . $myBYestodayData;
	exit -1;
}

while ($line=<BYESTERDAYDATA>) 
{
	$line =~ s/\r//;
	$line =~ s/\n//;
	@list=split(/\t/,$line);
	@TimeList=split(/ /,$list[0]);
	$TimeStat = $TimeList[1];
	$BYesterdayCount{$TimeStat} = $list[1];
}
close(BYESTERDAYDATA);


unless(open(AVERAGEDATA, $AverageData))
{
	print 'can not open file ' . $AverageData;
	exit -1;
}

while ($line=<AVERAGEDATA>) 
{
	$line =~ s/\r//;
	$line =~ s/\n//;
	@list=split(/\t/,$line);
	if(index($list[0],"|") < 0)
	{
		$AverageCount{$list[0]} = $list[1];
	}
	if(index($list[0],$WeekOfDay . "|") >= 0)
	{
		#print $line . "\n";
		@TimeList=split(/\|/,$list[0]);
		$TimeStat = $TimeList[1];
		$WeekAverageCount{$TimeStat} = $list[1];
	}
}
close(AVERAGEDATA);

open(OUTFILE, ">/usr/local/monitor_sanguo/web/login/login_" . $Date . ".htm");
print OUTFILE '<html><head><title>Sanguo user login monitor</title>
<meta http-equiv=Content-Type content="text/html; charset=gb2312"> 
<meta http-equiv="refresh" content="300"> 
<style>BODY {
	MARGIN-TOP: 0px; FONT-SIZE: 9pt; SCROLLBAR-HIGHLIGHT-COLOR: buttonface; SCROLLBAR-SHADOW-COLOR: buttonface; COLOR: #3f3849; SCROLLBAR-3DLIGHT-COLOR: buttonhighlight; SCROLLBAR-TRACK-COLOR: #eeeeee; SCROLLBAR-DARKSHADOW-COLOR: buttonshadow
}
TD {
	FONT-SIZE: 9pt; COLOR: #333333
}
TABLE {
	BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 2px
}
TD {
	COLOR: #000000
}
</style></head> 
	<body>';
$sTemp = sprintf("<h1 align=center>%s Sanguo user login monitor</h1>",$ChineseToday);
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
$sTemp = sprintf("<tr><td>time</td><td>%s(Today)</td><td>%s(WeekAgo)</td><td>%s(Yesterday)</td><td>%s</td><td>Day AVG</td><td>%sAVG</td></tr>\n",$ChineseToday,$LastweekDay,$ChineseYesterday,$ChineseBYesterday,$Chinese{$WeekOfDay});
print OUTFILE $sTemp;


foreach $TimeStat (sort keys(%AverageCount)) 
{
	if($TodayCount{$TimeStat}>($AverageCount{$TimeStat}*1.2) && $TodayCount{$TimeStat}>($WeekAverageCount{$TimeStat}*1.2))
	{
		$Show = sprintf('<font color=green><b>%d</b></font>',$TodayCount{$TimeStat});
	}
	elsif($TodayCount{$TimeStat}<($AverageCount{$TimeStat}*0.8) && $TodayCount{$TimeStat}<($WeekAverageCount{$TimeStat}*0.8))
	{
		$Show = sprintf('<font color=red><b>%d</b></font>',$TodayCount{$TimeStat});
	}
	else
	{
		$Show = $TodayCount{$TimeStat};
	}
	$all_today_count += $TodayCount{$TimeStat};
	$all_last_week_day_count += $LastWeekDayCount{$TimeStat};
	$all_yesterday_count += $YesterdayCount{$TimeStat};
	$all_byesterday_count += $BYesterdayCount{$TimeStat};
	$all_average_count += $AverageCount{$TimeStat};
	$all_week_average_count  += $WeekAverageCount{$TimeStat};

	if(!$TodayCount{$TimeStat} && $TimeStat gt $TimeStatNow){$Show='';}
	if($Show eq '' && !$IsSumed)
	{
		$sTemp = sprintf("<tr><td><b>total</b></td><td><b>%d</b></td><td><b>%d</b></td><td><b>%d</b></td><td><b>%d</b></td><td><b>%d</b></td><td><b>%d</b></td></tr>\n",
			$all_today_count,$all_last_week_day_count,$all_yesterday_count,$all_byesterday_count,$all_average_count,$all_week_average_count);
		print OUTFILE $sTemp;
		$IsSumed = 1;
		
	}
	$sTemp = sprintf("<tr><td>%s</td><td>%s</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>\n",
	$TimeStat,$Show,$LastWeekDayCount{$TimeStat},$YesterdayCount{$TimeStat},$BYesterdayCount{$TimeStat},$AverageCount{$TimeStat},$WeekAverageCount{$TimeStat});
	print OUTFILE $sTemp;
}

print OUTFILE	'</table></body></html>';
close(OUTFILE);

#$cmd = sprintf('rsync /usr/local/monitor/web/login/login_%s.htm root@192.168.100.124::monitor/web/login/',$Date);
#system($cmd);
