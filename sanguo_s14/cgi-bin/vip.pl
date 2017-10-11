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

my $log_path = "/usr/local/monitor_sanguo_s14/data/rmbuserpay";
printf("<h1 align=center>VIP data stat</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr align='center'><td rowspan='2'>Date</td><td colspan='10'>VIP等级人数</td></tr>");

for($i=1;$i<10;$i++){
   print "<td align='center'>VIP$i</td>";
}
print "<td align='center'>VIP10</td></tr>";

$s=0;
for($j=1;$j<=30;$j++)
{
        
        my $date = `date -d "$j days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        if($s==0)
        {
          $ed=$date;
        }
        $s++;
        $sd=$date;        

        my $file = sprintf("%s/vip_%s.log",$log_path,$date);
        #print "$file";
        if(open(READFILE, $file))
        {
                my @list=<READFILE>;
                $list_num=@list;
                for($i=0;$i<$list_num;$i++){
                    my @data = split(/\s+/,$list[$i]);
                    $IsVip{$date}{$data[0]}=$data[1];
                }
                close(READFILE);
        }
        printf("<tr align='center'><td id='d$date' style='display:block'>$date</td><td id='dd$date' style='display:none'><font color='red'>$date</font></td>");
        for($k=1;$k<=10;$k++){
            if($IsVip{$date}{$k}){
             print "<td>$IsVip{$date}{$k}</td>";
            }
            else{
             print "<td>0</td>";
            }
        }
        print "</tr>"; 

}

print '</table>';
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';

printf( "<script>
 gtips141($sd,$ed);
</script>");

print '</body></html>';
