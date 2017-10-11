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
$log_path="/data/release/sgonline/datalog";
$monitor_path="/usr/local/monitor_sanguo";

$cmd = $script_path . "/get_web.pl $Date";
$TimeDateEnd = `date -d "$Date" "+%Y-%m-%d 23:59:59"`;
$TimeDateEnd =~ s/\r//;
$TimeDateEnd =~ s/\n//;

$myTodayData=sprintf("%s/data_%s.log",$log_path,$Date);
unless(open(TODAYDATA, $myTodayData))
{
	print 'can not open file ' . $myTodayData;
	exit -1;
}

$myOutFile=sprintf(">%s/data/login/monitor_%s.txt",$monitor_path,$Date);
unless(open(OUTFILE, $myOutFile))
{
	print 'can not open ' . $myOutFile;
	exit -1;
}

while ($line=<TODAYDATA>) 
{
	#print $line;
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
	if($list[1] ne "login" || $list[3] ne "send"){next;}
	$Count{$TimeStat} += 1;

}
close(TODAYDATA);

foreach $keyStat (sort keys(%Count))
{
	$strOut = sprintf("%s\t%s\n",$keyStat,$Count{$keyStat});
	print OUTFILE $strOut;	
}
system($cmd);		
close(OUTFILE);


