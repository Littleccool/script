#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>attack stat</title>
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
	

printf("<h1 align=center>DVC stat</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr><td rowspan='2'>date</td><td colspan='2'>Total</td><td align='center' colspan='40'>DVC&DVC/人数</td></tr>");
print '<td>DVC_daily fight count</td><td>People_Count</td>';
for($j=1;$j<=96;$j=$j+5){
  printf("<td colspan='2'>%d-%d级</td>",$j,$j+4);
}
print '</tr>';
$i = 0;
for(;$i<=30;$i++)
{
        my $date = `date -d "$i days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        my $file = sprintf("/data/release/sgonline/s14/log/business/attack_%s.log",$date);
        $countDVC = 0;
        $count_p = 0;
        @count = ();
        @p_count=();
        if(open(READFILE, $file))
        {
                my @line=<READFILE>;
                for($j=0;$j<@line;$j++)
                {
                     my @list = split(/\|/,$line[$j]);
                     if(($list[2] != "")&&($list[2] != null))
                     { 
                         $IsUid{$list[2]}{$date} = 1;
                         $Isp{$list[2]}{$date} = $list[3];
                         $IsAttackUid{$list[1]}{$date}=$list[2];
                     }
                               
                }
                #for($kk=5;$kk<=100;$kk=$kk+5){
                #       $count[$kk]=0;
                #       $p_count[$kk]=0;
                #}
                foreach $key(sort{$a<=>$b} keys(%IsAttackUid)){
                    $uid = $IsAttackUid{$key}{$date};
                    #print "$key\t";
                    
                    for($kk=5;$kk<=100;$kk=$kk+5){
                       if(($Isp{$uid}{$date}<=$kk)&&($Isp{$uid}{$date}>=$kk-4)){
                              $count[$kk]++;
                              last; 
                       }
                       else
                       {
                              next;
                       }
                     }
                     
                }
                 
                foreach $key(sort{$b<=>$a} keys(%IsUid)){
                    #print "$key\t";
                    for($kk=5;$kk<=100;$kk=$kk+5){
                       if(($Isp{$key}{$date}<=$kk)&&($Isp{$key}{$date}>=$kk-4)){
                              $p_count[$kk]++;
                              last;          
                       }
                       else
                       {
                              next;
                       }
                     }
                     
                }
               
                for($kk=5;$kk<=100;$kk=$kk+5){
                       $countDVC+=$count[$kk];
                       $count_p+=$p_count[$kk];
                }
                
        }
        close(READFILE);
	printf("<tr><td id='d$date' style='display:block'>$date</td><td id='dd$date' style='display:none'><font color='red'>$date</font></td><td>$countDVC</td><td>$count_p</td>");
        for($j=5;$j<=100;$j=$j+5){
         if(($p_count[$j]!=0)&&($p_count[$j] != null)&&($p_count[$j] != "")){
            printf("<td>%d</td><td>%.2f</td>",$count[$j],$count[$j]/$p_count[$j]);
         }
         if(($p_count[$j] == null)||($p_count[$j] == "")||($p_count[$j] == 0)){
           print '<td> - </td><td> - </td>';
         } 
        }
        print '</tr>';
}


print '</table>';
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';

printf( "<script>
 gtips141($sd,$ed);
</script>");

print '</body></html>';
$dbh->disconnect();
