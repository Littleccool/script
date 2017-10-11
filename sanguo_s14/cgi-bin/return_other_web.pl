#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>return other stat</title>
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
	
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";

$dbh = &setDBStat();

printf("<h1 align=center>return rate</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr><td>date</td><td>new user</td><td>d1</td><td>d2</td><td>d3</td><td>d4</td><td>d5</td><td>d6</td><td>d7</td><td>d14</td><td>d30</td></tr>");

$sql = sprintf("select date,all_rookie_count,d1,d2,d3,d4,d5,d6,d7,d14,d30 from table_other_return where cp=\'sz\'order by date desc limit 30");
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	printf("<tr><td>%s</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>"
		,$row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[6],$row[7],$row[8],$row[9],$row[10]);
}

print '</table>';
print '</body></html>';
$dbh->disconnect();

