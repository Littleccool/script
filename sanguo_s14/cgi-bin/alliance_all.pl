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

$DateBegin = `date -d "$Date" +%s`;
$DateBegin =~ tr/\r\n//d;
$DateNow = `date -d "$Date 23:59:59" +%s`;
$DateNow =~ tr/\r\n//d;

use JSON;
use Data::Dumper;
my $json = new JSON;
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";
my $dbh = &setDBSanguo();

$sql = sprintf("select uid,alliance_id from alliance_member");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$alliance_id = $row[1];
	$AllianceId{$uId} = $alliance_id;
}
$sth->finish();

$sql = sprintf("select uid,sum(credit) from pay_history where status=1 group by uid");
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
	$alliance_id = $AllianceId{$uId};
	if($alliance_id)
	{
		$SumPay{$alliance_id} += $credit;
		$PayCount{$alliance_id} ++;
		#printf("%s=%.2f\n",$alliance_id,$SumPay{$alliance_id});
	}
}
$sth->finish();

$sql = sprintf("select alliance_id,name,leader_uid,from_unixtime(create_time),level,point,member_count from alliance where status=0 order by point desc limit 50");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$alliance_id = $row[0];
	$name = $row[1];
	$leader_uid = $row[2];
	$create_time = $row[3];
	$level = $row[4];
	$point = $row[5];
	$member_count = $row[6];
	$alliance_qq = $row[7];
	
	$Name{$alliance_id} = $name;
	$LeaderId{$alliance_id} = $leader_uid;
	$CreateTime{$alliance_id} = $create_time;
	$Level{$alliance_id} = $level;
	$Point{$alliance_id} = $point;
	$MemberCount{$alliance_id} = $member_count;
	$AllianceQQ{$alliance_id} = $alliance_qq;
	if($i==0)
	{
		$id_list = $leader_uid;
	}
	else
	{
		$id_list .= "," . $leader_uid;
	}
	$i++;
}
$sth->finish();

$sql = sprintf("select uid,last_login_time,alliance_id from user where alliance_id>0");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$last_login_time = $row[1];
	$alliance_id = $row[2];
	
	$LastLoginTime{$uId} = $last_login_time;
	if($last_login_time > $DateBegin)
	{
		$ActiveCount{$alliance_id}++;
	}
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
	
	$LeaderName{$uId} = $name;
	$Province{$uId} = $province;
	$City{$uId} = $city;
}
$sth->finish();

print "Content-type:text/html\n";   
print "\n";
print '<html><head><title>all alliance stat</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8"> 
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
printf("<h1 align=center>all alliance stat</h1>\n");
print '<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
printf("\n");
printf("<tr><td></td><td>name</td><td colspan=2>leader&status</td><td>pay</td><td>level</td><td>piont</td><td>reg time</td><td>member count</td><td colspan=2>pay count</td><td colspan=2>active count</td><td>qq</td></tr>\n");
$i=0;
foreach $alliance_id (sort {$Point{$b} <=> $Point{$a} }keys(%Point)) 
{
	$i++;
	$last_login_time = $LastLoginTime{$LeaderId{$alliance_id}};
	$days = ($DateNow - $last_login_time)/(24*60*60);
	if($days <= 1)
	{
		$status = "active";
	}
	else
	{
		$status = sprintf("%.1fdays",$days);
	}
		
	printf("<tr><td>%d</td><td><a href=http://s14.app100688853.qqopenapp.com/cgi-bin/alliance_info.pl?id=%s&name=%s target=_blank>%s</td><td>%s</td><td>%s</td><td>%.2f</td><td>%d</td><td>%d</td><td>%s</td><td>%d</td><td>%d</td><td>%.2f%%</td><td>%d</td><td>%.2f%%</td><td>%s</td></tr>\n",
	$i,$alliance_id,$Name{$alliance_id},$Name{$alliance_id},$LeaderName{$LeaderId{$alliance_id}},$status,$SumPay{$alliance_id},$Level{$alliance_id},$Point{$alliance_id},$CreateTime{$alliance_id},$MemberCount{$alliance_id},$PayCount{$alliance_id},$PayCount{$alliance_id}/$MemberCount{$alliance_id}*100,$ActiveCount{$alliance_id},$ActiveCount{$alliance_id}/$MemberCount{$alliance_id}*100,$AllianceQQ{$alliance_id});
}
print '</table>';
print '</body></html>';
