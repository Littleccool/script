#!/usr/bin/perl

require "/usr/local/script/sanguo_s14/cgi-bin/cgilib.pl";
%dataDict=();
&readData(*data);
&parseData(*data,dataDict);

if($dataDict{"date"})
{
	$Date = $dataDict{"date"};
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ tr/\r\n//d;
}

$alliance_id = $dataDict{"id"};
$alliance_name = $dataDict{"name"};
use JSON;
use Data::Dumper;
my $json = new JSON;
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";
my $dbh = &setDBSanguo();

$sql = sprintf("select uid,from_unixtime(join_time),point from alliance_member where alliance_id=%s",$alliance_id);
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$join_time = $row[1];
	$point = $row[2];
	
	$JoinTime{$uId} = $join_time;
	$Piont{$uId} = $point;
	if($i==0)
	{
		$id_list = $uId;
	}
	else
	{
		$id_list .= "," . $uId;
	}
	$i++;
}
$sth->finish();

$sql = sprintf("select uid,from_unixtime(register_time),from_unixtime(last_login_time),login_days,invite_count,level,invite_uid,alliance_id from user where uid in (%s)",$id_list);
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$reg_time = $row[1];
	$last_login_time = $row[2];
	$login_days = $row[3];
	$invite_count = $row[4];
	$level = $row[5];
	$invite_uid = $row[6];
	$alliance_id = $row[7];
	
	$RegTime{$uId} = $reg_time;
	$LastLoginTime{$uId} = $last_login_time;
	$LoginDays{$uId} = $login_days;
	$InviteCount{$uId} = $invite_count;
	$Level{$uId} = $level;
	$InviteUid{$uId} = $invite_uid;
	$AllianceId{$uId} = $alliance_id;
}
$sth->finish();

$sql = sprintf("select uid,name,province,city from user_basic where uid in (%s)",$id_list);
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$name = $row[1];
	$province = $row[2];
	$city = $row[3];
	
	$Name{$uId} = $name;
	$Province{$uId} = $province;
	$City{$uId} = $city;
}
$sth->finish();

$sql = sprintf("select uid,sum(credit) from pay_history where status=1 and uid in (%s) group by uid;",$id_list);
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$credit = $row[1]/100;
	
	$SumPay{$uId} = $credit;
}
$sth->finish();

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>alliance info</title>
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
</style></head> 
	<body>';
printf("\n");
printf("<h1 align=center>alliance id=%s,name=%s</h1>\n",$alliance_id,$alliance_name);
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("\n");
printf("<tr><td>id</td><td>name</td><td>area</td><td>pay</td><td>level</td><td>piont</td><td>last login</td><td>reg time</td><td>join time</td><td>login days</td><td>invite count</td><td>invited uid</td></tr>\n");
foreach $uId (sort {$SumPay{$b} <=> $SumPay{$a} }keys(%RegTime)) 
{
	printf("<tr><td>%d</td><td>%s</td><td>%s%s</td><td>%.2frmb</td><td>%d</td><td>%d</td><td>%s</td><td>%s</td><td>%s</td><td>%d</td><td>%d</td><td>%d</td></tr>\n",
	$uId,,$Name{$uId},$Province{$uId},$City{$uId},$SumPay{$uId},$Level{$uId},$Piont{$uId},$LastLoginTime{$uId},$RegTime{$uId},$JoinTime{$uId},$LoginDays{$uId},$InviteCount{$uId},$InviteUid{$uId});
}
print '</table>';
print '</body></html>';
