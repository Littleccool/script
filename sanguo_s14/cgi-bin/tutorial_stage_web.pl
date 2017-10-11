#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>Tutorial Stage Stat</title>
<meta http-equiv=Content-Type content="text/html; charset=gb2312"> 
<meta http-equiv="refresh" content="300"> 
<style>BODY {
	MARGIN-TOP: 0px; FONT-SIZE: 9pt; SCROLLBAR-HIGHLIGHT-COLOR: buttonface; SCROLLBAR-SHADOW-COLOR: buttonface; COLOR: #3f3849; SCROLLBAR-3DLIGHT-COLOR: buttonhighlight; SCROLLBAR-TRACK-COLOR: #eeeeee; SCROLLBAR-DARKSHADOW-COLOR: buttonshadow
}
TD {
	FONT-SIZE: 9pt; COLOR: #333333;text-align:center;
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

printf("<h1 align=center>新手数据统计</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr><td rowspan='3'>Date</td><td rowspan='3' >Compare Day </td><td colspan='15' rowspan='2'>新用户等级</td><td colspan='98'>建筑</td><td colspan='34' rowspan='2'>闯关</td><td colspan='72' rowspan='2'>任务</td></tr>");
print "<td colspan='7'>主城</td><td colspan='7'>兵营</td><td colspan='7'>募兵处</td><td colspan='7'>研究院</td><td colspan='7'>技能馆</td>";
print "<td colspan='7'>箭塔</td><td colspan='7'>弩炮</td><td colspan='7'>伏兵处</td><td colspan='7'>驿站</td><td colspan='7'>仓库</td>";
print "<td colspan='7'>农田</td><td colspan='7'>采石场</td><td colspan='7'>木材场</td><td colspan='7'>铁矿场</td></tr>";
printf("<td>总数</td><td colspan='2'>小于5级</td><td colspan='2'>6-10级</td><td colspan='2'>11-15级</td><td colspan='2'>16-20级</td><td colspan='2'>21-25级</td><td colspan='2'>26-30级</td><td colspan='2'>大于30级</td>");

for($i=0;$i<14;$i++)
{
 print "<td>小于5级</td><td>6-10级</td><td>11-15级</td><td>16-20级</td><td>21-25级</td><td>26-30级</td><td>大于30级</td>";
}
for($i=1;$i<=81;$i=$i+5)
{
 $a=$i+4;
 if($i<80){
   print "<td colspan='2'>$i-$a关</td>";	
 }
 else{
  print "<td colspan='2'>大于80关</td>";	
 }
}

print "<td colspan='2'>ID1060</td><td colspan='2'>ID2053</td><td colspan='2'>ID50004</td><td colspan='2'>ID2054</td><td colspan='2'>ID30003</td><td colspan='2'>ID51003</td><td colspan='2'>ID515</td><td colspan='2'>ID50005</td><td colspan='2'>ID1069</td><td colspan='2'>ID2001</td><td colspan='2'>ID1080</td>";
print "<td colspan='2'>ID2055</td><td colspan='2'>ID30004</td><td colspan='2'>ID51004</td><td colspan='2'>ID1015</td><td colspan='2'>ID1025</td><td colspan='2'>ID41001</td>";
print "<td colspan='2'>ID42001</td><td colspan='2'>ID2056</td><td colspan='2'>ID30005</td><td colspan='2'>ID51005</td><td colspan='2'>ID520</td><td colspan='2'>ID50006</td><td colspan='2'>ID2057</td><td colspan='2'>ID1070</td><td colspan='2'>ID1125</td><td colspan='2'>ID2058</td><td colspan='2'>ID1155</td><td colspan='2'>ID1215</td><td colspan='2'>ID2002</td><td colspan='2'>ID50007</td>";
print "<td colspan='2'>ID80001</td><td colspan='2'>ID2059</td><td colspan='2'>ID42002</td><td colspan='2'>ID1195</td><td colspan='2'>ID2060</td>";
print "</tr>";
$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/datalog";
$monitor_path="/usr/local/monitor_sanguo_s14";

my $DIR_PATH="/usr/local/monitor_sanguo_s14/data/rmbuserpay";
opendir(DIR, $DIR_PATH) or die "Can not open \"$DIR_PATH\"\n";
@filelist = grep(/Compare4_\d{8}/,readdir DIR) ;

$filelist_num = @filelist;
if($filelist_num>30){
 $filelist_num=31;
}
close(DIR);
#print "======$filelist_num\n";
#for($i=0;$i<$filelist_num;$i++)
#{
#  print "$filelist[$i]\n";
#}

@date=();
for($i=0;$i<=$filelist_num+1;$i++)
{
 $date[$i] = `date -d "$i days ago" +%Y%m%d`;
 $date[$i] =~ tr/\r\n//d;
# print "date[$i]===$date[$i]\n";
}
$date_num=@date;
$k=0;
#print "\n$date_num\n";
@d=();
for($i=1;$i<$date_num-2;$i++)
{
         if($s==0)
         {
           $ed=$date[$i];
         }
         $s++;
         $sd=$date[$i];
         $d[$i] = `date -d "2 days ago $date[$i]" +%Y%m%d`;
         print "<tr bgcolor=#cccccc><td rowspan='4' id='d$d[$i]' style='display:block'>$d[$i]</td><td rowspan='4' id='dd$d[$i]' style='display:none'><font color='red'>$d[$i]</font></td>";
         $FileName = sprintf("%s/data/rmbuserpay/Compare4_%s.log",$monitor_path,$date[$i-1]);
         unless(open(MYFILE, $FileName))
         {
              print "can not open file" . $FileName . "!\n";
              exit -1;
         }
       @percent=();
       @gate_percent=();
       @quest_percent=();
       @level=();
       @b_list=();
        while ($line=<MYFILE>)
        {
            foreach $key ( keys(%Value))
            {
                  delete ($Value{$key});
            }
            $line =~ tr/\r\n//d;
            @list0=split(/\|/,$line);
            $total_num = $list0[0];
            
            @list=split(/\,/,$list0[1]);
            $number = @list;
            @b_list=split(/\,/,$list0[2]);
            #$b_list_num=@b_list;
            #print "\n========$b_list_num==$b_list[0]=====\n";
            $gate_count=$list0[3];
            @gate_list=split(/\,/,$list0[4]);
            $quest_count=$list0[5];
            @quest_list=split(/\,/,$list0[6]);
            # print $line . "\n";
            for($m=0;$m<7;$m++)
            {
              $level[$m] = $list[$m];
              if($total_num==0)
              {
                 $percent[$m]=0;
              }
              else
              {
                $percent[$m] = $list[$m]/$total_num;
              }
              # print "=======$percent[$m]\n";
            }
            for($m=0;$m<17;$m++)
            {
               if($gate_count==0)
               {
                  $gate_percent[$m] = 0;
               }
               else
               {
                 $gate_percent[$m] = $gate_list[$m]/$gate_count;
               }
             #print "gate_percent====$gate_percent[$m]\n";
            }
            for($m=0;$m<36;$m++)
            {
               if($quest_count==0)
               {
                 $quest_percent[$m] = 0;
               }
               else
               {
                 $quest_percent[$m] = $quest_list[$m]/$quest_count; 
               }
            }
        }
       close(MYFILE);
       
       $FileName2 = sprintf("%s/data/rmbuserpay/Compare3_%s.log",$monitor_path,$date[$i]);
        unless(open(MYFILE, $FileName2))
        {
             print "can not open file" . $FileName2 . "!\n";
             exit -1;
        }
       @level2=();
       @percent2=();
       @gate_percent2=();
       @quest_percent2=();
       @b_list2=();
       while ($line=<MYFILE>)
       {
            foreach $key ( keys(%Value))
            {
                delete ($Value{$key});
            }
            $line =~ tr/\r\n//d;
            @list00=split(/\|/,$line);
            $total_num2 = $list00[0];
            @list2=split(/\,/,$list00[1]);
            $number2 = @list2;
            @b_list2 = split(/\,/,$list00[2]);
            $gate_count2 = $list00[3];
            @gate_list2 = split(/\,/,$list00[4]);
            $quest_count2 = $list00[5];
            @quest_list2 = split(/\,/,$list00[6]);
           for($k=0;$k<7;$k++)
           {
             $level2[$k]=$list2[$k];
             if($total_num2==0)
             {
               $percent2[$k]=0;
             }
             else
             {
             $percent2[$k] = $list2[$k]/$total_num2;
             }
             #  print "=======$percent2[$k]\n";
          }
          for($k=0;$k<17;$k++)
          {
               if($gate_count2==0)
               {
                  $gate_percent2[$k] = 0;
               }
               else
               {
                 $gate_percent2[$k] = $gate_list2[$k]/$gate_count2;
               }
             #print "gate_percent2====$gate_percent2[$k]\n";
          }
          for($k=0;$k<36;$k++)
          {
            if($quest_count2==0){$quest_percent2[$k] = 0;}
            else{$quest_percent2[$k] = $quest_list2[$k]/$quest_count2;}
          }
#print "\nquest_count2 = $quest_count2===\n";
#exit;
      }
     close(MYFILE);
     
     $FileName3 = sprintf("%s/data/rmbuserpay/Compare2_%s.log",$monitor_path,$date[$i+1]);
        unless(open(MYFILE, $FileName3))
        {
             print "can not open file" . $FileName3 . "!\n";
             exit -1;
        }
       @level3=();
       @percent3=();
       @gate_percent3=();
       @quest_percent3=();
       @b_list3=();
       while ($line=<MYFILE>)
       {
            foreach $key ( keys(%Value))
            {
                delete ($Value{$key});
            }
            $line =~ tr/\r\n//d;
            @list00=split(/\|/,$line);
            $total_num3 = $list00[0];
            @list2=split(/\,/,$list00[1]);
            $number2 = @list2;
            @b_list3 = split(/\,/,$list00[2]);
            $gate_count3 = $list00[3];
            @gate_list3 = split(/\,/,$list00[4]);
            $quest_count3 = $list00[5];
            @quest_list3 = split(/\,/,$list00[6]);
           for($k=0;$k<7;$k++)
           {
             $level3[$k]=$list2[$k];
             if($total_num3==0)
             {
               $percent3[$k]=0;
             }
             else
             {
             $percent3[$k] = $list2[$k]/$total_num3;
             }
             #print "=======$percent3[$k]\n";
          }
          for($k=0;$k<17;$k++)
          {
               if($gate_count3==0)
               {
                  $gate_percent3[$k] = 0;
               }
               else
               {
                 $gate_percent3[$k] = $gate_list3[$k]/$gate_count3;
               }
             #print "gate_percent3====$gate_percent3[$k]\n";
          }
          for($k=0;$k<36;$k++)
          {
            if($quest_count3==0){$quest_percent3[$k] = 0;}
            else{$quest_percent3[$k] = $quest_list3[$k]/$quest_count3;}
          }
#print "\nquest_count3 = $quest_count3===\n";
#exit;
      }
     close(MYFILE);
     
     $FileName4 = sprintf("%s/data/rmbuserpay/Compare1_%s.log",$monitor_path,$date[$i+2]);
        unless(open(MYFILE, $FileName4))
        {
             print "can not open file" . $FileName4 . "!\n";
             exit -1;
        }
       @level4=();
       @percent4=();
       @gate_percent4=();
       @quest_percent4=();
       @b_list4=();
       while ($line=<MYFILE>)
       {
            foreach $key ( keys(%Value))
            {
                delete ($Value{$key});
            }
            $line =~ tr/\r\n//d;
            @list00=split(/\|/,$line);
            $total_num4 = $list00[0];
            @list2=split(/\,/,$list00[1]);
            $number2 = @list2;
            @b_list4 = split(/\,/,$list00[2]);
            $gate_count4 = $list00[3];
            @gate_list4 = split(/\,/,$list00[4]);
            $quest_count4 = $list00[5];
            @quest_list4 = split(/\,/,$list00[6]);
           for($k=0;$k<7;$k++)
           {
             $level4[$k]=$list2[$k];
             if($total_num4==0)
             {
               $percent4[$k]=0;
             }
             else
             {
             $percent4[$k] = $list2[$k]/$total_num4;
             }
             #print "=======$percent4[$k]\n";
          }
          for($k=0;$k<17;$k++)
          {
               if($gate_count4==0)
               {
                  $gate_percent4[$k] = 0;
               }
               else
               {
                 $gate_percent4[$k] = $gate_list4[$k]/$gate_count4;
               }
             #print "gate_percent4====$gate_percent4[$k]\n";
          }
          for($k=0;$k<36;$k++)
          {
            if($quest_count4==0){$quest_percent4[$k] = 0;}
            else{$quest_percent4[$k] = $quest_list4[$k]/$quest_count4;}
          }
      }
     close(MYFILE);
     
     print '<td>Day 4</td>';
     printf("<td rowspan='4'>%d</td>",$total_num4);
     for($n=0;$n<7;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$level[$n],$percent[$n]*100);
     }
     for($n=0;$n<98;$n++)
     {
        printf("<td>%d</td>",$b_list[$n]);
     }
     for($n=0;$n<17;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$gate_list[$n],$gate_percent[$n]*100);
     }
     for($n=0;$n<36;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$quest_list[$n],$quest_percent[$n]*100);
     }
     print '</tr>';
     
     print '<td>Day 3</td>';
     for($n=0;$n<7;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$level2[$n],$percent2[$n]*100);
     }
     for($n=0;$n<98;$n++)
     {
        printf("<td>%d</td>",$b_list2[$n]);
     }
      for($n=0;$n<17;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$gate_list2[$n],$gate_percent2[$n]*100);
     }
     for($n=0;$n<36;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$quest_list2[$n],$quest_percent2[$n]*100);
     }
     print '</tr>';
     
     print '<td>Day 2</td>';
     for($n=0;$n<7;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$level3[$n],$percent3[$n]*100);
     }
     for($n=0;$n<98;$n++)
     {
        printf("<td>%d</td>",$b_list3[$n]);
     }
      for($n=0;$n<17;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$gate_list3[$n],$gate_percent3[$n]*100);
     }
     for($n=0;$n<36;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$quest_list3[$n],$quest_percent3[$n]*100);
     }
     print '</tr>';
     
     print '<td>Day 1</td>';
     for($n=0;$n<7;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$level4[$n],$percent4[$n]*100);
     }
     for($n=0;$n<98;$n++)
     {
        printf("<td>%d</td>",$b_list4[$n]);
     }
      for($n=0;$n<17;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$gate_list4[$n],$gate_percent4[$n]*100);
     }
     for($n=0;$n<36;$n++)
     {
        printf("<td>%d</td><td>%.2f\%</td>",$quest_list4[$n],$quest_percent4[$n]*100);
     }
     if($i<$date_num-1)
     {
       print '</tr><tr><td></td></tr>'; 
     }
     else
     {
       print '</tr>';
     }
}

print '</table>';
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';

printf( "<script>
 gtips141($sd,$ed);
</script>");
print '</body></html>';

