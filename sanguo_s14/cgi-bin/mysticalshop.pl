#!/usr/bin/perl

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>rmb user pay stat</title>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8"> 
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

printf("<h1 align=center>黑市统计</h1>");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
print "<tr><td rowspan='2'>date</td><td rowspan='2'>收入</td>";

for (my $i=1;$i<=12;$i++)

{
	my $string = "item".$i;
        print "<td colspan='2'>$string</td>";
}

print "</tr>\r\n";
for ($i=1; $i<=12;$i++)
{
      print "<td>uid</td><td>cost</td>";
}
print "</tr>\r\n";

$statdir = "/usr/local/monitor_sanguo_s14/data/rmbuserpay";
for($i=0;$i<31;$i++)
{
        my $date = `date -d "$i days ago" +%Y%m%d`;
        $date =~ tr/\r\n//d;
        my $file = sprintf("%s/mysticalshop_%s.log",$statdir,$date);
	if(-e $file)
	{
        	if(open(READFILE, $file))
        	{
			my @list = ();
			my @cost = ();
			my $tatol = 0;

                	
			while($line=<READFILE>)
     			{
	           		$line =~ tr/\r\n//d;
                        	my @arr = split(" ",$line);
				push @list,$arr[0];
				push @cost,$arr[1];
				$tatol += $arr[1];
                	}
			print "<tr><td>$date</td><td>$tatol</td>";

			for($j=0;$j<12;$j++)
			{
				if($list[$j])
				{
				   print "<td>$list[$j]</td><td>$cost[$j]</td>";	
				}
				else
				{
				   print "<td>-</td><td>-</td>";
				}
			}
			print "</tr>\r\n";
               		close(READFILE);
       		 }
	}
}

print "</table>";

print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf( "<script>
 gtips81($sd,$ed);
</script>");
print "</body></html>";
