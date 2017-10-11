#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>争霸统计</title>
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
</head> 
	<body>';
	

printf("<h1 align=center>争霸统计</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr align='center'><td rowspan='2'>date</td>");
printf("<td colspan='3'>占领郡县</td>");
printf("<td colspan='3'>占领城市</td>");
printf("<td colspan='3'>占领皇城</td>");
printf("<td colspan='2'>驻将</td>");
printf("<td colspan='2'>占领郡县最长</td>");
printf("<td colspan='2'>占领城市最长</td>");
printf("<td colspan='2'>占领皇城最长</td>");
print '</tr>';
for($k=0;$k<=2;$k++)
{
 print '<td>成功次数</td>';
 print '<td>人数</td>';
 print '<td>成功次数比例</td>';
}
print '<td>人数</td>';
print '<td>比例</td>';
for($k=0;$k<=2;$k++){
 print '<td>Uid</td>';
 print '<td>Time</td>';
}
print '</tr>';
$i = 0;
for(;$i<=30;$i++)
{
        my $date = `date -d "$i days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        my $file = sprintf("/data/release/sgonline/s14/log/business/worldattack_%s.log",$date);
        my $s14_count=0; 
        my $s14_count=0;
        my $s14_count=0;
        $u1=0;$u2=0;$u3=0; 
        $p1_count=0;$p2_count=0;$p3_count=0;
        $count1=0;$count2=0;$count3=0;
        @time1=();@time2=();@time3=();
        @uid1=();@uid2=();@uid3=();
        $max1=0;$max2=0;$max3=0;
        if(open(READFILE, $file))
        {
                my @line=<READFILE>;
                $len=@line;
                for($j=0;$j<@line;$j++)
                {
                     $time1[$j]=0;$time2[$j]=0;$time3[$j]=0;
                     my @list = split(/\|/,$line[$j]);
                     if($list[1] eq "occupycity")
                     {
                         if($list[5] == 11)
                         { 
                            $s14_count++;
                            $uid1[$j] = $list[3];
                            $time1[$j] = $list[6];  
                         }
                         if($list[5] == 12)
                         {
                            $s14_count++;
                            $uid2[$j] = $list[3];
                            $time2[$j] = $list[6]; 
                         }
                         if($list[5] == 13)
                         {
                            $s14_count++;
                            $uid3[$j] = $list[3];
                            $time3[$j] = $list[6]; 
                         }
                     }
                     if($list[1] eq "attack")
                     {
                         if($list[5] == 11)
                         {
                            $count1++;
                         } 
                         if($list[5] == 12)
                         {
                            $count2++;
                         } 
                         if($list[5] == 13)
                         {
                            $count3++;
                         } 
                     }          
                }

               my %saw1;
               @saw1{ @uid1 } = ( );
               my @uniq_array1 = sort keys %saw1;
               $p1_count=@uniq_array1;

               my %saw2;
               @saw2{ @uid2 } = ( );
               my @uniq_array2 = sort keys %saw2;
               $p2_count=@uniq_array2;

               my %saw3;
               @saw3{ @uid3 } = ( );
               my @uniq_array3 = sort keys %saw3;
               $p3_count=@uniq_array3;               

                for($t=0;$t<$len-1;$t++)
                {
                   if($time1[$t]>$time1[$t+1])
                   {
                      $max1 = $time1[$t];
                      $u1 = $uid1[$t];
                   }
                   if($time2[$t]>$time2[$t+1])
                   {
                      $max2 = $time2[$t];
                      $u2 = $uid2[$t];
                   }
                   if($time3[$t]>$time3[$t+1])
                   {
                      $max3 = $time3[$t];
                      $u3 = $uid3[$t];
                   }
                }
        }
        if($count1 == 0){
           $p1=0;
        }
        else{
          $p1=$s14_count*100/$count1;
        }
        if($count2 == 0){
           $p2=0;
        }
        else{
          $p2=$s14_count*100/$count2;
        }
        if($count3 == 0){
           $p3=0;
        }
        else{
          $p3=$s14_count*100/$count3;
        }
         
	printf("<tr><td>$date</td>");
        printf("<td>%d</td><td>%d</td><td>%.2f%</td>",$s14_count,$p1_count,$p1);
        printf("<td>%d</td><td>%d</td><td>%.2f%</td>",$s14_count,$p2_count,$p2); 
        printf("<td>%d</td><td>%d</td><td>%.2f%</td>",$s14_count,$p3_count,$p3);
        printf("<td>0</td><td>0</td>");
        printf("<td>$u1</td><td>%.2f h</td><td>$u2</td><td>%.2f h</td><td>$u3</td><td>%.2f h</td>",$max1/3600,$max2/3600,$max3/3600);
        print '</tr>';
        close(READFILE);
}


print '</table>';

print '</body></html>';
