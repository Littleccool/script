#!/usr/bin/perl

$numbers=@ARGV;



$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/datalog";
$monitor_path="/usr/local/monitor_sanguo_s14";
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ tr/\r\n//d;
}
$DateYesterday = `date -d "1 days ago $Date" +%Y%m%d`;
$DateYesterday =~ tr/\r\n//d;
$DateBegin = `date -d "$Date" +%s`;
$DateBegin =~ tr/\r\n//d;
$DateEnd = `date -d "$Date 23:59:59" +%s`;
$DateEnd =~ tr/\r\n//d;

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sgonline_s14 = &setDBSanguo();
$dbh_stat = &setDBStat();

$sql = sprintf("select uid,sum(credit) from pay_history where status=1 group by uid ");
#print $sql . "\n";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$PayByUid{$uId} = $row[1];
}
$sth->finish();

$sql = sprintf("select uid,cash from pay");
#print $sql . "\n";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$Cash{$uId} = $row[1];
}
$sth->finish();

$sql = sprintf("select uid,max(id),data from gate group by uid");
#print $sql . "\n";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$Gate{$uId} = $row[1];
	$Content = $row[2];
	
	if($Content =~ /\"w\"\:1/)
	{
		$GatePass{$uId} = 1;
	}
}
$sth->finish();

$begin_second=`date -d $Date +%s`;
$end_second=`date -d "$Date 23:59:59" +%s`;
$begin_second =~ tr/\r\n//d;
$end_second =~ tr/\r\n//d;
$sql = sprintf("select uid,substring(from_unixtime(register_time),1,10),(unix_timestamp(now())-last_login_time)/86400 as unlogin_days,level,(last_login_time-register_time)/84000 from user");
#print $sql . "\n";
$dbh = $dbh_sgonline_s14;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$reg_date = $row[1];
	$unlogin_days = $row[2];
	$LevelByUid{$uId} = $row[3];
	$LiveDaysByUid{$uId} = $row[4];
        	
	$RegCount{$reg_date}++;
	if($PayByUid{$uId})
	{
		$AllPayedCount{$reg_date}++;
	}
	if($unlogin_days <7)
	{
		next;
	}
	
	$gate_key = $reg_date . "|" . $Gate{$uId};
	$LoseUserGate{$gate_key}++;
	
	$LoseDaysByUid{$uId} = $unlogin_days;
	$LoseCount{$reg_date}++;
	if($PayByUid{$uId})
	{
		$LosePayedCount{$reg_date}++;
		if($LoseAccounts{$reg_date})
		{
			$LoseAccounts{$reg_date} .= "|" . $uId;
		}
		else
		{
			$LoseAccounts{$reg_date} .= $uId;
		}
	}
	
}
$sth->finish();
$DNU=$all_rookie_count;
close(PAYNEWUSERFILE);
$dbh_sgonline_s14->disconnect();


$FileName = sprintf(">/usr/local/stat_s14/web/lose_stat/lose_stat_%s.htm",$Date);
unless(open(OUTFILE, $FileName))
{
	print 'can not open file ' . $FileName;
	exit -1;
}
print OUTFILE '<html><head><title>lose user stat</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8"> 
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
$sTemp = sprintf("<h1 align=center>lose user stat</h1>",$ChineseToday);
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
	print OUTFILE "<tr>\n";
	$sTemp = sprintf("<td>date</td><td>reg count</td><td>lose count,live rate</td><td>gate stay</td><td>payed count</td><td>lose pay,live rate</td><td>uid</td><td>pay sum</td><td>live days</td><td>level</td><td>cash</td><td>gate</td>");
	print OUTFILE $sTemp;
	print OUTFILE "</tr>\n";

foreach $key (reverse sort keys(%LoseCount))
{
	$sLine = "";
	
	foreach $tmpkey ( keys(%LoseGateByDay))
	{
		delete ($LoseGateByDay{$tmpkey});
	}
	for($i=1;$i<=360;$i++)
	{
		$gate_key = $key . "|" . $i;
		if(!$LoseUserGate{$gate_key})
		{
			next;
		}
		$LoseGateByDay{$i} = $LoseUserGate{$gate_key};
	}
	$i=0;
	foreach $gate_id (sort {$LoseGateByDay{$b} <=> $LoseGateByDay{$a} }keys(%LoseGateByDay)) {
		if($i==0)
		{
			$sGateString = sprintf("%d&nbsp;&nbsp;&nbsp;%d&nbsp;&nbsp;&nbsp;%.2f%%",$gate_id,$LoseGateByDay{$gate_id},100*$LoseGateByDay{$gate_id}/$LoseCount{$key});
		}
		else
		{
			#$sGateString .= ',';
			$sGateString .= sprintf("%d&nbsp;&nbsp;&nbsp;%d&nbsp;&nbsp;&nbsp;%.2f%%",$gate_id,$LoseGateByDay{$gate_id},100*$LoseGateByDay{$gate_id}/$LoseCount{$key});
		}
		$i++;
		if($i>10){last;}
		$sGateString .= '<br>';
	}
	
	$i=0;
	foreach $uId (sort {$PayTempByUid{$b} <=> $PayTempByUid{$a} }keys(%PayTempByUid)) {
		if($i>=10){last;}
		if($i>0)
		{
			$sLine .= "<tr>";
		}
		$sLine .= sprintf('<td>%d</td><td>%.2frmb</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td>',$uId,$PayTempByUid{$uId}/100,$LiveDaysByUid{$uId},$LevelByUid{$uId},$Cash{$uId},$Gate{$uId});
		$sLine .= "</tr>\n";
		$i++;
		
	}
	
	if($i>1)
	{
		$RowCount = " rowspan=$i ";
	}
	else
	{
			$sLine = "<td></td><td></td><td></td><td></td><td></td><td></td><tr>\n";
	}
	$sTemp = sprintf("<tr><td$RowCount>%s</td><td$RowCount>%d</td><td$RowCount>%d&nbsp;&nbsp;&nbsp;%.2f%%</td><td$RowCount>%s</td><td$RowCount>%d</td><td$RowCount>%d&nbsp;&nbsp;&nbsp;%.2f%%</td>",$key,$RegCount{$key},$LoseCount{$key},100*($RegCount{$key}-$LoseCount{$key})/$RegCount{$key},$sGateString,$AllPayedCount{$key},$LosePayedCount{$key},100*($AllPayedCount{$key}-$LosePayedCount{$key})/$AllPayedCount{$key});
        print OUTFILE $sTemp;
	
	foreach $tmpkey ( keys(%PayTempByUid))
	{
		delete ($PayTempByUid{$tmpkey});
	}
	my @list = split(/\|/,$LoseAccounts{$key});
	#printf("%s",$LoseAccounts{$key});
	for($i=0;$i<@list;$i++)
	{
		$PayTempByUid{$list[$i]} = $PayByUid{$list[$i]};
	}
	
	$sTemp = sprintf("%s",$sLine);
	print OUTFILE $sTemp;
	
	#print OUTFILE "</tr>\n";
}
print OUTFILE	'</table>';
print OUTFILE	'</body></html>';
close(OUTFILE);
exit;

