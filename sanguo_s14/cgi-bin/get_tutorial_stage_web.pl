#!/usr/bin/perl

$numbers=@ARGV;
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ s/\r//;
	$Date =~ s/\n//;
}

use JSON;
use Data::Dumper;
my $json = new JSON;
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";
my $dbh = &setDBStat();

$sql = sprintf("select date,rookie_count,Datas from table_tutorial_stage order by date desc limit 30");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$myDate = $row[0];
	$rookie_count = $row[1];
	$Datas = $row[2];
	
	$obj = NULL;
	if($Datas)
	{
		$obj = decode_json($Datas);
	}
	foreach $key (keys(%$obj))
	{
		$AllCount{$key} += $obj->{$key};
	}
	#@list = split(/\,/,$Datas);
	#for($j=0;$j<=$max_stage;$j++)
	#{
	#	$AllCount[$j] += $list[$j];
	#}
	$i++;
}
$sth->finish();

$sql = sprintf("select date,rookie_count,Datas from table_tutorial_stage order by date desc limit 30");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
$s=0;
while (@row = $sth->fetchrow_array)
{
	$myDate = $row[0];
        if($s==0){
         $ed=$row[0];
        }
        $s++;
        $sd=$row[0];
	$rookie_count = $row[1];
	$Datas = $row[2];
	$obj = NULL;
	if($Datas)
	{
		$obj = decode_json($Datas);
	}
	$sTemp = sprintf("<tr><td id='d$myDate' style='display:block'>%s</td><td id='dd$myDate' style='display:none'><font color='red'>%s</font></td><td>%d</td>",$myDate,$myDate,$rookie_count);
	$all_data .= $sTemp;

	foreach $key (sort {$a <=> $b} keys(%AllCount))
	{
		if($obj->{$key} * 200 > $rookie_count)
		{
			my $percent = ($obj->{$key})? $obj->{$key}*100/$rookie_count:0;
			$sTemp = sprintf("<td>%d,%.2f%%</td>",$obj->{$key},$percent);
		}
		else
		{
			$sTemp = sprintf("<td>%d</td>",$obj->{$key});
		}
		$all_data .= $sTemp;
	}
	if($rookie_count==0){$rookie_count=1;}
	$sTemp = sprintf("<td>%.2f%%</td>",$obj->{10000}*100/$rookie_count);
	$all_data .= $sTemp;
	$all_data .= "</tr>\n";
	$i++;
}
$sth->finish();

$FileName = sprintf(">/usr/local/stat_s14/web/user_action/tutorial_stage_%s.htm",$Date);
unless(open(OUTFILE, $FileName))
{
	print 'can not open file ' . $FileName;
	exit -1;
}
print OUTFILE '<html><head><title>sanguo tutorial stage stat</title>
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
</style>
<script type="text/javascript" src="http://stat.dawx.com/js/jquery-1.7.2.min.js" charset="UTF-8"></script>
</head> 
	<body>';
$sTemp = sprintf("<h1 align=center>sanguo tutorial stage stat</h1>",$ChineseToday);
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
	print OUTFILE "<tr>\n";
	$sTemp = sprintf("<td>date</td><td>new count</td>");
	print OUTFILE $sTemp;
	foreach $key (sort {$a <=> $b} keys(%AllCount))
	{
		$sTemp = sprintf("<td>%d</td>",$key);
		print OUTFILE $sTemp;
	}
	$sTemp = sprintf("<td>finish percent</td>");
	print OUTFILE $sTemp;
	print OUTFILE "</tr>\n";
	print OUTFILE $all_data;


print OUTFILE	'</table>';
print OUTFILE  '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
$sTemp=sprintf( "<script>
 gtips141($sd,$ed);
</script>");
print OUTFILE $sTemp;
$myFile = sprintf("/usr/local/script/sanguo_s14/cgi-bin/stage.txt");
unless(open(MYFILE, $myFile))
{
	print 'can not open file ' . $myFile . "!\n";
	exit -1;
}
while ($line=<MYFILE>) 
{
	$line =~ tr/\r\n//d;
	if($line =~ /\"tut_(\d+)\"><\!\[CDATA\[(.*)\]\]/)
	{
		$Desc{$1}=$2;
	}
}
close(MYFILE);
print OUTFILE	'<p><br><br><br></p><table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
foreach $key (sort {$a cmp  $b }keys(%Desc)) {
	$sTemp = sprintf("<tr><td>%s</td><td>%s</td></tr>\n",$key,$Desc{$key});
	print OUTFILE $sTemp;	
}
print OUTFILE	'</table>';

$myFile = sprintf("/usr/local/script/sanguo_s14/cgi-bin/zh_cn.xml");
unless(open(MYFILE, $myFile))
{
	print 'can not open file ' . $myFile . "!\n";
	exit -1;
}
while ($line=<MYFILE>) 
{
	if($line =~ /<text id = \"tutor_desc_(.*)\"><\!\[CDATA\[(.*)\]\]><\/text>/i)
	{
		$Desc{$1}=$2;
	}
}
close(MYFILE);

print OUTFILE	'<p><br><br><br></p><table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
foreach $key (sort {$a <=> $b }keys(%Desc)) {
	$sTemp = sprintf("<tr><td>%s</td><td>%s</td></tr>\n",$key,$Desc{$key});
	print OUTFILE $sTemp;	
}
print OUTFILE	'</table>';

print OUTFILE	'</body></html>';
close(OUTFILE);

