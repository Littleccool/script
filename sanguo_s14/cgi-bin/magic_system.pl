#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>神兵系统</title>
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
	

printf("<h1 align=center>神兵系统统计</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("<tr align='center'><td>date</td>");
print '<td>激活器灵人数</td>';
for($k=1;$k<=10;$k++)
{
 printf("<td>神兵%d</td>",$k); 
}
print '</tr>';
for($i=1;$i<=30;$i++)
{
        @a=(0,0,0,0,0,0,0,0,0,0);
        @b=(0,0,0,0,0,0,0,0,0,0);
        my $date = `date -d "$i days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        my $date2 = `date -d "1 days ago $date" +%Y%m%d `;
        $date2 =~ tr/\r\n//d; 
        printf("<tr align='center'><td>$date</td>");

        my $file = sprintf("/data/release/sgonline/s14/log/business/godE%s.log",$date);
        my $file2 = sprintf("/data/release/sgonline/s14/log/business/godE%s.log",$date2);
        if(open(READFILE, $file2))
        {
                my @line=<READFILE>;
                $len=@line;
                for($j=0;$j<@line;$j++)
                {
                     
                     my @list = split(/\|/,$line[$j]);
                     $uid = $list[0];
             
                     for($k=1;$k<7;$k++){
                        if($list[$k]<=$list[$k+1]){
                           $IsOk{$uid} = $list[$k]+1;
                        }
                        else{
                           $IsOk{$uid} = $list[$k+1]+1;
                        }
                     }
                     for($k=0;$k<10;$k++){
                        if($IsOk{$uid}==$k+1){$a[$k]++;}
                     } 
                }

        }
        close(READFILE); 
        if(open(READFILE2, $file))
        {
                my @line2=<READFILE2>;
                $len=@line2;
                for($j=0;$j<@line2;$j++)
                {

                     my @list2 = split(/\|/,$line2[$j]);
                     $uid = $list2[0];
                     for($k=1;$k<7;$k++){
                        if($list2[$k]<=$list2[$k+1]){
                           $IsOok{$uid} = $list2[$k]+1;
                        }
                        else{
                           $IsOok{$uid} = $list2[$k+1]+1;
                        }
                     }
                     for($k=0;$k<10;$k++){
                        if($IsOok{$uid}==$k+1){$b[$k]++;}
                     } 
                }

        }
        $act = 0;
 
        for($k=0;$k<10;$k++){
           $active=$b[$k]-$a[$k];
           if($active != 0){
             $act = $active; 
           }
        }
        printf("<td>%d</td>",$act);
        for($k=0;$k<10;$k++){
           printf("<td>%d</td>",$b[$k]);
        } 
        print '</tr>';
        close(READFILE2);
}


print '</table>';

print '</body></html>';
