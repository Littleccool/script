#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>rmb user pay stat</title>
<meta http-equiv=Content-Type content="text/html; charset=utf8"> 
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
$i = 1;
for(;$i<=30;$i++)
{
	my $date = `date -d "$i days ago" +%Y%m%d`;
	$date =~ tr/\r\n//d;
	my $file = sprintf("%s/rmbuserpay_%s.log",$statdir,$date);
	if(open(READFILE, $file))
	{
		my $line=<READFILE>;
		$line =~ tr/\r\n//d;
		if($line)
		{
			my @line_list = split(/\|/,$line);
			my $line_list_num = @line_list;
			if($line_list_num == 6)
			{
				my @item_list = split(/\,/,$line_list[3]);
				my @count_list = split(/\,/,$line_list[4]);
				my @cost_list = split(/\,/,$line_list[5]);
				my $item_num = @item_list;
				for($j=0;$j<$item_num;$j++)
				{
					$all_stat{$date}{"count_stat"}{$item_list[$j]} = $count_list[$j];
					$all_stat{$date}{"cost_stat"}{$item_list[$j]} = $cost_list[$j];
					$all_item_cost{$item_list[$j]} += $cost_list[$j];
				}
				$all_stat{$date}{"totaluser"} = $line_list[1];
				$all_stat{$date}{"totalcost"} = $line_list[2];
				$all_cost += $line_list[2];
				$all_user += $line_list[1];
			}
		}
		close(READFILE);
	}
}

@items = ();
foreach $key (keys(%all_stat))
{
	my $temp_stat = $all_stat{$key}{"cost_stat"};
	foreach $key2 (keys(%$temp_stat))
	{
		$add = 1;
		foreach $e (@items)
		{
			if($e eq $key2)
			{
				$add = 0;
				last;
			}
		}
		if($add)
		{
			push(@items,$key2);
		}
	}
}

@items = sort { $all_item_cost{$b} <=> $all_item_cost{$a} }@items;

print "<tr><td>date</td><td>fee user</td><td>money</td>";
foreach $e (@items)
{
	print "<td>",$e,"</td>";
}
print "</tr>\r\n";
$s=0;
foreach $key (sort { $b <=> $a}keys(%all_stat))
{
        if($s==0)
        {
           $ed=$key;
        }
        $s++;
          $sd=$key;
	print "<tr><td id='d$key' style='display:block'>",$key,"</td><td id='dd$key' style='display:none'><font color='red'>",$key,"</font></td><td>",$all_stat{$key}{"totaluser"},"</td><td>",$all_stat{$key}{"totalcost"},"</td>";
	foreach $e (@items)
	{
		print "<td>",$all_stat{$key}{"cost_stat"}{$e},"</td>";
	}
	print "</tr>\r\n";
}
print "<tr><td>total</td><td>",$all_user,"</td><td>",$all_cost,"</td>";
foreach $e (@items)
{
	my $rate = sprintf("(%.2f%%)",100*$all_item_cost{$e}/$all_cost);
	print "<td>",$all_item_cost{$e},$rate,"</td>";
}
print "</tr>\r\n";
print "</table>";
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf("<script>
 gtips141($sd,$ed);
</script>");
printf('<p>format:pay count,pay money.<br></p>');

$myFile = sprintf("/usr/local/script/sanguo_s14/cgi-bin/tool_list.txt");
unless(open(MYFILE, $myFile))
{
	#print 'can not open file ' . $myFile . "!\n";
	#exit -1;
}
while ($line=<MYFILE>) 
{
	$line =~ tr/\r\n//d;
	@list = split(/\t/,$line);
	printf("<p>%s:%s</p>\n",$list[0],$list[1]);
}
close(MYFILE);
print "</body></html>";
