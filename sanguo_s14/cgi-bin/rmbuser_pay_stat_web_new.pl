#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>rmb user pay stat</title>
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

printf("<h1 align=center>rmb user pay stat</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
$statdir = "/usr/local/monitor_sanguo_s14/data/rmbuserpay";
for($i=0;$i<31;$i++)
{
	my $date = `date -d "$i days ago" +%Y%m%d`;
	$date =~ tr/\r\n//d;
        #print "date====$date\n";
	my $file = sprintf("%s/rmbuserpay_new_%s.log",$statdir,$date);
	if(open(READFILE, $file))
	{
		my $line=<READFILE>;
		$line =~ tr/\r\n//d;
                #print "$line\n";
		if($line)
		{
			my @line_list = split(/\|/,$line);
			my $line_list_num = @line_list;
			if($line_list_num == 5)
			{
				my @item_list = split(/\,/,$line_list[3]);
				my @cost_list = split(/\,/,$line_list[4]);
                                my @cost_list1=();
                                my @cost_list2=();
                                for($k=0;$k<@cost_list;$k++)
                                {
                                  my @temp_list=();
                                  @temp_list = split(/\:/,$cost_list[$k]);
                                  $cost_list1[$k] = $temp_list[0];
                                  $cost_list2[$k] = $temp_list[1];
                                  #print "\n$cost_list1[$k]=====$cost_list2[$k]\n";
                                }
				my $item_num = @item_list;
				for($j=0;$j<$item_num;$j++)
				{
				        #print "$item_list[$j]\t";
                                        #$IsItem{$item_list[$j]}=1;
                                	$all_stat{$date}{"cost_stat1"}{$item_list[$j]} += $cost_list1[$j];
                                        $all_stat{$date}{"cost_stat2"}{$item_list[$j]} += $cost_list2[$j];
                                        $all_item_cost{"cost1"}{$item_list[$j]} += $cost_list1[$j];
                                        $all_item_cost{"cost2"}{$item_list[$j]} += $cost_list2[$j];
				}
                                $all_stat{$date}{"totaluser"} += $line_list[1];
				my @all_cost_list = split(/\,/,$line_list[2]);
                                $all_stat{$date}{"daycash"} = $all_cost_list[0];
                                $all_stat{$date}{"daycoins"} = $all_cost_list[1];
			        $all_cost1 += $all_cost_list[0];
                                $all_cost2 += $all_cost_list[1];
				$all_user += $line_list[1];
			}
		}
		close(READFILE);
	}
}

@items = ();
foreach $key (keys(%all_stat))
{
	my $temp_stat = $all_stat{$key}{"cost_stat2"};
	foreach $key2 (keys(%$temp_stat))
	{
           $add = 1;
           foreach $e (@items)
           { 
                if($e eq $key2){
                  $add=0;
                  last;}
           }
           if($add == 1)
           { 
             push(@items,$key2);
           }
        }
}
#foreach $key(keys (%IsItem)){
#   print "$key\t";
#   push(@items,$key);
#}

@items = sort @items;

#for($i=0;$i<@items;$i++){
#  print "$items[$i]\t";
#}

#exit;

print "<tr><td rowspan='2'>date</td><td rowspan='2'>fee user</td><td colspan='2'>money</td>";
foreach $e (@items)
{
      print "<td colspan='2'>",$e,"</td>";
}
print "</tr>\r\n";
print "<tr><td>cash</td><td>coins</td>";
foreach $e (@items)
{
      print "<td>cash</td><td>coins</td>";
}
print "</tr>\r\n";
$s=0;
foreach $key (sort { $b <=> $a}keys(%all_stat))
{
        if($s==0){
          $ed = $key;
        }
        $s++;
        $sd=$key;
	print "<tr><td id='d$key' style='display:block'>",$key,"</td><td id='dd$key' style='display:none'><font color='red'>",$key,"</font></td><td>",$all_stat{$key}{"totaluser"},"</td><td>",$all_stat{$key}{"daycash"},"</td><td>",$all_stat{$key}{"daycoins"},"</td>";
	foreach $e (@items)
	{
		print "<td>",$all_stat{$key}{"cost_stat1"}{$e},"</td>";
                print "<td>",$all_stat{$key}{"cost_stat2"}{$e},"</td>";
	}
	print "</tr>\r\n";
}
print "<tr><td>total</td><td>",$all_user,"</td><td>",$all_cost1,"</td><td>",$all_cost2,"</td>";
foreach $e (@items)
{
        if($all_cost1==0)
        { 
        my $rate = 0;
        }
        else
        {
	$rate = sprintf("(%.2f%%)",100*$all_item_cost{"cost1"}{$e}/$all_cost1);
        }
        if($all_cost2==0)
        {
        my $rate2 = 0;
        }
        else
        {
        $rate2 = sprintf("(%.2f%%)",100*$all_item_cost{"cost2"}{$e}/$all_cost2);
        }
	print "<td>",$all_item_cost{"cost1"}{$e},$rate,"</td>";
        print "<td>",$all_item_cost{"cost2"}{$e},$rate2,"</td>";
}
print "</tr>\r\n";
print "</table>";
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf( "<script>
 gtips141($sd,$ed);
</script>");
#printf('<p>format:pay count,pay money.<br></p>');
#$myFile = sprintf("/usr/local/script/sanguo_s14/cgi-bin/shop_item.txt");
#unless(open(MYFILE, $myFile))
#{
#	#print 'can not open file ' . $myFile . "!\n";
#	#exit -1;
#}
#while ($line=<MYFILE>) 
#{
#	$line =~ tr/\r\n//d;
#	@list = split(/\t/,$line);
#	printf("<p>%s:%s</p>\n",$list[0],$list[1]);
#}
#close(MYFILE);
print "</body></html>";
