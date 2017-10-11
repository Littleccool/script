#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>return rate</title>
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
</style>
<script type="text/javascript" src="http://stat.dawx.com/js/jquery-1.7.2.min.js" charset="UTF-8"></script>
</head> 
	<body>';
	
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";

$dbh = &setDBStat();
printf("<h1 align=center>return rate</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr><td>date</td><td>new user</td><td>d1</td><td>week</td><td>d2</td><td>d3</td><td>d4</td><td>d5</td><td>d6</td><td>d7</td><td>d8</td><td>d9</td><td>d10</td><td>d11</td><td>d12</td><td>d13</td><td>d14</td></tr>");

$sql = sprintf("select date,all_rookie_count,d1,week_return_rate,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14 from table_returning_stat order by date desc");
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
        if($i == 0){
          $ed = $row[0];
        }
        $i++;
        $sd = $row[0];
 	printf("<tr><td id='d$row[0]' style='display:block'>%s</td><td id='dd$row[0]' style='display:none'><font color='red'>%s</font></td><td>%d</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td><td>%.2f%%</td></tr>"
		,$row[0],$row[0],$row[1],100*$row[2],100*$row[3],100*$row[4],100*$row[5],100*$row[6],100*$row[7],100*$row[8],100*$row[9],100*$row[10],100*$row[11],100*$row[12],100*$row[13],100*$row[14],100*$row[15],100*$row[16]);
}

print '</table>';
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf( "<script>
 gtips141($sd,$ed);
</script>");
print '</body></html>';
$dbh->disconnect();

