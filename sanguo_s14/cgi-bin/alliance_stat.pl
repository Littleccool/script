#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>alliance stat</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8"> 
<meta http-equiv="refresh" content="300"> 
<style>BODY {
        MARGIN-TOP: 0px; FONT-SIZE: 9pt; SCROLLBAR-HIGHLIGHT-COLOR: buttonface; SCROLLBAR-SHADOW-COLOR: buttonface; COLOR: #3f3849; SCROLLBAR-3DLIGHT-COLOR: buttonhighlight; SCROLLBAR-TRACK-COLOR: #eeeeee; SCROLLBAR-DARKSHADOW-COLOR: buttonshadow
}
TD {
        FONT-SIZE: 9pt; COLOR: #333333; text-align: center;
}
TABLE {
        BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 2px
}
TD {
        COLOR: #000000
}
</style>
<script type="text/javascript" src="http://stat.dawx.com/js/jquery-1.7.2.min.js" charset="utf-8"></script>
</head> 
        <body>';

printf("<h1 align=center>Alliance Stat</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
$statdir = "/usr/local/monitor_sanguo_s14/data/alliance";
for($j=0;$j<=30;$j++)
{
        my $date = `date -d "$j days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        my $file = sprintf("%s/stat_alliance_%s.txt",$statdir,$date);
        if(open(READFILE, $file))
        {
                my $line=<READFILE>;
                $line =~ tr/\r\n//d;
                if($line)
                {
                        my @list = split(/\|/,$line);
                        $count = $list[1];
                        $new_count = $list[2];
                        my @l_count = split(/\,/,$list[3]);
                        $IsDate{$date}=1; 
                        $user = $list[4];
                        $payUser=$list[5];
                        my @user_count = split(/\,/,$list[6]);
                        my @l_point = split(/,/,$list[7]); 
                        my @resource = split(/,/,$list[8]);
                
                        $IsCount{$date}=$count;

                        $IsNewCount{$date}=$new_count;

                        $IsUser{$date}=$user;

                        $IsPayUser{$date}=$payUser;
                        
                        for($i=0;$i<@l_count;$i++){
                          $IsLevelCount{$date}{$i}=$l_count[$i]; 
                        }
                        for($i=0;$i<@user_count;$i++){
                          $IsAllianCount{$date}{$i}=$user_count[$i];
                        }
                        for($i=0;$i<@l_point;$i++){
                          $IsPointLevel{$date}{$i}=$l_point[$i];
                        }
                        for($i=0;$i<@resource;$i++){
                          $IsResource{$date}{$i}=$resource[$i];
                        }
                }
                close(READFILE);
        }
}
print "<tr align='center'><td rowspan='3'>Date</td><td colspan='2'>总览</td>";
print "<td colspan='6'>等级分布</td>";
print "<td colspan='4'>加盟比例</td><td ";
print "<td colspan='10'>前五名人数与上线</td>";
print "<td colspan='10'>前五名等级与战功</td>";
print "<td colspan='25'>前五名资源捐献</td></tr>";
print "<td rowspan='2'>总联盟数</td><td rowspan='2'>新增联盟</td>";
print "<td rowspan='2'>LEVEL 1</td><td rowspan='2'>LEVEL 2</td><td rowspan='2'>LEVEL 3</td><td rowspan='2'>LEVEL 4</td><td rowspan='2'>LEVEL 5</td><td rowspan='2'>>LEVEL 5</td>";

print "<td rowspan='2'>普通用户</td><td rowspan='2'>百分比</td><td rowspan='2'>付费用户</td><td rowspan='2'>百分比</td>";
print "<td colspan='2'>第一名</td><td colspan='2'>第二名</td><td colspan='2'>第三名</td><td colspan='2'>第四名</td><td colspan='2'>第五名</td>";
print "<td colspan='2'>第一名</td><td colspan='2'>第二名</td><td colspan='2'>第三名</td><td colspan='2'>第四名</td><td colspan='2'>第五名</td>";
print "<td colspan='5'>第一名</td><td colspan='5'>第二名</td><td colspan='5'>第三名</td><td colspan='5'>第四名</td><td colspan='5'>第五名</td>";
print "</tr>";
for($i=0;$i<5;$i++){
  print "<td>成员数</td><td>上线数</td>";
}
for($i=0;$i<5;$i++){
  print "<td>等级</td><td>战功</td>";
}


for($i=0;$i<4;$i++){
  print "<td>r1</td><td>r2</td><td>r3</td><td>r4</td><td>r5</td>";
}
print "<td>r1</td><td>r2</td><td>r3</td><td>r4</td><td>r5</td></tr>";

$s=0;
foreach $key (sort { $b <=> $a}keys(%IsDate))
{
   if($s==0){
      $ed = $key;
   }
   $s++;
   $sd=$key;
   print "<tr align='center'><td id='d$key' style='display:block'>",$key,"</td><td id='dd$key' style='display:none'><font color='red'>",$key,"</font></td><td>",$IsCount{$key},"</td><td>",$IsNewCount{$key},"</td>";
   for($i=0;$i<6;$i++){
     print "<td>$IsLevelCount{$key}{$i}</td>";
   }
   #print "\n$IsUser{$key}\n";
   #print "\n$IsPayUser{$key}\n";
   #$percent1 = $IsUser{$key}/($IsUser{$key}+$IsPayUser{$key});
   #print "\n $percent1 \n";
   #print "<td>$IsUser{$key}</td>";
   $sTemp = printf("<td>%d</td><td>%.2f%</td><td>%d</td><td>%.2f%</td>",$IsUser{$key},$IsUser{$key}*100/($IsUser{$key}+$IsPayUser{$key}),$IsPayUser{$key},$IsPayUser{$key}*100/($IsUser{$key}+$IsPayUser{$key})); 

   for($i=0;$i<10;$i++){
     print "<td>$IsAllianCount{$key}{$i}</td>";    
   }
   for($i=0;$i<10;$i++){
     print "<td>$IsPointLevel{$key}{$i}</td>";
   }
   for($i=0;$i<25;$i++){
     print "<td>$IsResource{$key}{$i}</td>";
   } 
   print "</tr>";
}

print "</table>";
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf( "<script>
 gtips141($sd,$ed);
</script>");
close(MYFILE);
print "</body></html>";
