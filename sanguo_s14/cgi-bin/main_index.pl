#!/usr/bin/perl


print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>key data stat</title>
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

use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";

$dbh = &setDBStat();
$statdir = "/usr/local/monitor_sanguo_s14/data/rmbuserpay";
printf("<h1 align=center>key data stat</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr><td>date</td><td>all reg count</td><td>DAU</td><td>DWAU</td><td>MAU</td><td>DAU/MAU</td><td>DNU</td><td>DOU</td><td>DIU</td><td>DIUed,DIUed/DNU</td><td>DVC,DVC/DOU</td>");
printf("<td>Darpu</td>");
printf("<td>总付费率</td><td>Arpu</td><td>老用户</td><td>Arpu</td><td>新用户</td><td>Arpu</td></tr>\n");

$sql = sprintf("select date,AllUserCount,DAU,DWAU,MAU,DNU,DOU,DBU,DLU,DSU,DHU,DMU,DTU,DVU,DVC,DWU,DWC,DWUed,DWCed,DIU,DIUed from table_user_day_data_stat order by date desc");
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$s=0;
while (@row = $sth->fetchrow_array)
{
        if($s==0)
        {
          $ed=$row[0];
        }
        $s++;
        $sd=$row[0];
        $AllUserCount = $row[1];
        $DAU = $row[2];
        $MAU = $row[4];
        $DNU = $row[5];
        $DOU = $row[6];
        $DVU = $row[13];
        $DVC = $row[14];
        $DWU = $row[15];
        $DWC = $row[16];
        $DWUed = $row[17];
        $DWCed = $row[18];
        $DIU = $row[19];
        $DIUed = $row[20];
        if($AllUserCount == 0) {$AllUserCount = 1;}
        if($MAU == 0) {$MAU = 1;}
        if($DAU == 0) {$DAU = 1;}
        if($DNU == 0) {$DNU = 1;}
        if($DVU == 0) {$DVU = 1;}
        if($DWU == 0) {$DWU = 1;}
        if($DWUed == 0) {$DWUed = 1;}
        if($DIU == 0) {$DIU = 1;}
        if($DOU == 0) {$DOU = 1;}

        $dbh_sanguo = &setDBSanguo();

        $sql2 = sprintf("select credit from pay_history where status=1 and time>= unix_timestamp($row[0]) and time < unix_timestamp($row[0])+24*3600 order by time");
        $dbh2 = $dbh_sanguo;
        $sth2 = $dbh2->prepare($sql2);
        if($DBI::errstr){print $sql2 . "\n";}

        $sth2->execute();

        if($DBI::errstr){print $sql2 . "\n";}
        my $tcredit = 0;
        while (@row2 = $sth2->fetchrow_array)
        {
          $tcredit += $row2[0];
        }
        $sth2->finish();
        $tcredit = $tcredit/100;

        $sql3 = sprintf("select count(distinct(uid)) from pay_history where status=1 and time>= unix_timestamp($row[0]) and time < unix_timestamp($row[0])+24*3600");
        $sth3 = $dbh2->prepare($sql3);
        if($DBI::errstr){print $sql3 . "\n";}

        $sth3->execute();

        if($DBI::errstr){print $sql3 . "\n";}
        my $feecount = 0;
        while (@row3 = $sth3->fetchrow_array)
        {
          $feecount = $row3[0];
        }
        $sth3->finish();
        
        my $file = sprintf("%s/paybyday_%s.log",$statdir,$row[0]);
        if(open(READFILE, $file))
        {
                my $line=<READFILE>;
                $line =~ tr/\r\n//d;
                if($line)
                {
                        my @line_list = split(/\|/,$line);
                        my @paybyday = split(/\,/,$line_list[1]);
                        foreach my $item (@paybyday){
                                my @itemList = split(/_/, $item);
                                if($itemList[0] == $row[0])
                                {
                                  $IsNewFeeCount{$row[0]} = $itemList[1];
                                  $IsNewCredit{$row[0]} = $itemList[2]/100;
                                  last;
                                }
                        }
                }
                close(READFILE);
        }
         
        #print "$IsNewFeeCount{$row[0]},$IsNewCredit{$row[0]}\n";exit;        

        if($IsNewFeeCount{$row[0]} == 0){
          $new = 0;
        }
        else{
          $new = $IsNewCredit{$row[0]}/$IsNewFeeCount{$row[0]};
        }
        if(($feecount-$IsNewFeeCount{$row[0]}) == 0){
          $old = 0;         
        }
        else{
          $old = ($tcredit-$IsNewCredit{$row[0]})/($feecount-$IsNewFeeCount{$row[0]});
        }
        printf("<tr><td id='d$row[0]' style='display:block'>%s</td><td id='dd$row[0]' style='display:none'><font color='red'>%s</font></td><td>%s</td><td>%s,%.2f%%</td><td>%s</td><td>%s</td><td>%.2f%%</td><td>%s,%.2f%%</td><td>%s</td><td>%d</td><td>%d,%.2f%%</td><td>%d,%.4f</td><td>%.2f</td><td>%.2f%</td><td>%.2f</td><td>%.2f%</td><td>%.2f</td><td>%.2f%</td><td>%.2f</td></tr>"
        ,$row[0],$row[0],$AllUserCount,$DAU,100*$DAU/$AllUserCount,$row[3],$row[4],100*$DAU/$MAU,$DNU,100*$DNU/$DAU,$row[6],$DIU,$DIUed,100*$DIUed/$DNU,$DVC,$DVC/$DOU,$tcredit/$DAU,($feecount/$DAU)*100,$tcredit/$feecount,(($feecount-$IsNewFeeCount{$row[0]})/$DOU)*100,$old,($IsNewFeeCount{$row[0]}/$DNU)*100,$new);

}

print '</table>';
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';

printf("<script>
 gtips141($sd,$ed);
</script>");

print '<p>
        AllUserCount-All User<br>
        DWAU-Monthly Active User<br>
        DAU-Daily Active User<br>
        MAU-Monthly Active User<br>
        DNU-Daily New User<br>
        DOU-Daily Old User<br>
        DBU-Daily Building User<br>
        DLU-Daily Layout User<br>
        DSU-Daily Speed up User<br>
        DHU-Daily Harvest User<br>
        DIU-Daily Invite User<br>
        DIUed-Daily Invited User<br>
        DVC-Daily fight Count<br>
        </p>
        ';
print '</body></html>';

$dbh->disconnect();
