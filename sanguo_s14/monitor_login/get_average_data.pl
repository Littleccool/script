#!/usr/bin/perl

$numbers=@ARGV;

$script_path="/usr/local/script/login_monitor";
$log_path="/usr/local/server/login";
$monitor_path="/usr/local/monitor_sanguo_s4";
if($numbers == 2)
{
	$DateBegin = $ARGV[0];
	$DateEnd = $ARGV[1];
}
else
{
	$DateBegin = "20120213";
	$DateEnd = `date -d "1 days ago" +%Y%m%d`;
	$DateEnd =~ tr/\r\n//d;
}

$Date = $DateBegin;
#printf("date:%s,end:%s\n",$Date,$DateEnd);
$i=1;
while($Date le $DateEnd)
{
	#print $Date . "\n";
	$FileName=$monitor_path."/data/login/monitor_" . $Date . ".txt";
	$WeekOfDay=`date -d "$Date" +%w`;
	$WeekOfDay  =~ tr/\r\n//d;
	unless(open(MYFILE, $FileName)) 
	{
		#print "can not open file" . $FileName . "!\n";
		#exit -1;
		$Date=`date -d "$i days $DateBegin" +%Y%m%d`;
		$Date =~ tr/\r\n//d;
		$i++;
		next;
	}
	while ($line=<MYFILE>) 
	{
		$line =~ tr/\r\n//d;
		@list=split(/\t/,$line);
		@TimeList=split(/ /,$list[0]);
		$TimeStat = $TimeList[1];
		if($TimeStat lt "06:0")
		{
			#next;
		}
		$CountNum{$TimeStat} += $list[1];
		$StatNum{$TimeStat}++;
		$WeekCountNum{$WeekOfDay . "|" . $TimeStat} += $list[1];
		$WeekStatNum{$WeekOfDay . "|" . $TimeStat}++;
	}
	
	$Date=`date -d "$i days $DateBegin" +%Y%m%d`;
	$Date =~ tr/\r\n//d;
	$i++;
	close(MYFILE);
}


#foreach $TimeStat (reverse(sort keys(%StatNum)))
foreach $TimeStat (sort keys(%StatNum))
{
	printf("%s\t%d\n",$TimeStat,$CountNum{$TimeStat}/$StatNum{$TimeStat});
}
foreach $TimeStat (sort keys(%WeekStatNum))
{
	printf("%s\t%d\n",$TimeStat,$WeekCountNum{$TimeStat}/$WeekStatNum{$TimeStat});
}

