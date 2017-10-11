#!/usr/bin/perl

print "Content-type:text/html\r\n\r\n";
print '<html><head><title>pay by day</title>
<meta http-equiv=Content-Type content="text/html; charset=utf8"> 
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

printf("<h1 align=center>pay by day</h1>");

$statdir = "/usr/local/monitor_sanguo_s14/data/rmbuserpay";
$i = 1;
for(;$i<=100;$i++)
{
	my $date = `date -d "$i days ago" +%Y%m%d`;
	$date =~ tr/\r\n//d;
	my $datets = `date -d "$date" +%s`;
	my $file = sprintf("%s/paybyday_%s.log",$statdir,$date);
	if(open(READFILE, $file))
	{
		my $line=<READFILE>;
		$line =~ tr/\r\n//d;
		if($line)
		{
			$allStatMap{$date}{"index"} = $i;
			my @line_list = split(/\|/,$line);
			$allStatMap{$date}{"newUsers"} = $line_list[0];
			$allStatMap{$date}{"newvipamt"} = $line_list[2];
			$allNewUsers += $line_list[0];
			my @paybyday = split(/\,/,$line_list[1]);
			foreach my $item (@paybyday){
				my @itemList = split(/_/, $item);
				my $tmpts = `date -d "$itemList[0]" +%s`;
				my $day = ($datets - $tmpts)/86400 + 1;
				
				$allStatMap{$itemList[0]}{$day}{"users"} = $itemList[1];
				$allStatMap{$itemList[0]}{$day}{"credit"} = $itemList[2];
			}
		}
		close(READFILE);
	}
}
$si=0;
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
print "<tr><td>date</td><td colspan='3' align='center'>new users</td>";
for($i = 1; $i <= 100; $i++)
{
	print "<td colspan='2' align='center'>d$i</td>";
}
$userTotal = 0;
$creditTotal = 0;
print "<td colspan='2' align='center'>total</td><td>date</td></tr>\r\n";
foreach my $key (sort {$b<=>$a} keys(%allStatMap)){
	if (!$allStatMap{$key}{"index"}){
		next;
	}
	my $newUsers = $allStatMap{$key}{"newUsers"};
	my $newvipamt = $allStatMap{$key}{"newvipamt"};
	my $usersTmp = 0;
	my $creditTmp = 0;
        if($si == 0){
          $ed = $key;
        }
        $si++;
        $sd = $key;
        my $viprate = sprintf("%.2f%%",0*100);
        if($newUsers !=0){
	   $viprate = sprintf("%.2f%%",$newvipamt/$newUsers*100);
	}
        printf("<tr><td id='d$key' style='display:block'>%s</td><td id='dd$key' style='display:none'><font color='red'>%s</font></td><td>$newUsers</td><td>$newvipamt</td><td>$viprate</td>",$key,$key);
	my $index = $allStatMap{$key}{"index"};
	for (my $i = 1; $i <= 100; $i++){
		if ($i <= $index){
			if ($allStatMap{$key}{$i}){
				my $users = $allStatMap{$key}{$i}{"users"};
				my $credit = $allStatMap{$key}{$i}{"credit"}/100;
				$usersTmp += $users;
				$creditTmp += $credit;
				$allUsersByDay{$i} += $users;
				$allCreditByDay{$i} += $credit;
				print "<td>$users</td><td>$credit</td>";
			} else {
				print "<td>0</td><td>0</td>";
			}
		} else {
			print "<td>-</td><td>-</td>";
		}
	}
	$userTotal += $usersTmp;
	$creditTotal += $creditTmp;
	print "<td>$usersTmp</td><td>$creditTmp</td><td>$key</td></tr>\r\n";
}

print "<tr><td>total</td><td colspan='3' align='center'>$allNewUsers</td>";
for($i = 1; $i <= 100; $i++)
{
	if ($allUsersByDay{$i}){
		print "<td>$allUsersByDay{$i}</td><td>$allCreditByDay{$i}</td>";
	}else{
		print "<td>0</td><td>0</td>";
	}
}
print "<td>$userTotal</td><td>$creditTotal</td><td></td></tr>\r\n";

print "</table>\r\n";
print '<script type="text/javascript" src="http://stat.dawx.com/js/tips.js">
</script>';
printf( "<script>
 gtips141($sd,$ed);
</script>");
print "</body></html>";
