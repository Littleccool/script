#!/usr/bin/perl

$numbers=@ARGV;
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ s/\r//;
	$Date =~ s/\n//;
}
$DateBegin = `date -d "$Date" +%s`;
$DateBegin =~ tr/\r\n//d;
$DateEnd = `date -d "$Date 23:59:59" +%s`;
$DateEnd =~ tr/\r\n//d;

use JSON;
use Data::Dumper;
my $json = new JSON;
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";
my $dbh = &setDBSanguo();

$sql = sprintf("select uid,from_unixtime(register_time),from_unixtime(last_login_time),login_days,invite_count,level,invite_uid,alliance_id from user");
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

$sql = sprintf("select uid,name,province,city from user_basic");
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

$sql = sprintf("select alliance_id,alliance_name from alliance_mapping");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$alliance_id = $row[0];
	$alliance_name = $row[1];
	
	$AllianceName{$alliance_id} = $alliance_name;
}
$sth->finish();

$FileName = sprintf("/data/release/sgonline/s14/log/business/orders_%s.log",$Date);
unless(open(MYFILE, $FileName)) 
{
	print "can not open file" . $FileName . "!\n";
	exit -1;
}
while ($line=<MYFILE>) 
{
	foreach $key ( keys(%Value))
	{
		delete ($Value{$key});
	}
	$line =~ tr/\r\n//d;
	@list=split(/\|/,$line);
	$number = @list;
	if($number!=2)
	{
		next;
	}
	#print $line . "\n";
	@list2 = split(/\&/,$list[1]);
	for($i=0;$i<@list2;$i++)
	{
		@pair = split(/\=/,$list2[$i]);
		$Value{$pair[0]} = $pair[1];
	}
	if($Value{"uId"} !~ /^\d{8}$/)
	{
		$Value{"uId"} = $Value{"uid"};
		if($Value{"uId"} !~ /^\d{8}$/)
		{
			next;
		}
	}
 	 $uId = $Value{"uId"};
	 $price = $Value{"price"};
	 $amount = $Value{"amount"};
	if($price < 0)
	{
		$Consume{$uId} -= $price * $amount;
	}
}

close(MYFILE);

$FileName = sprintf(">/usr/local/stat_s14/web/user_action/top_op_%s.htm",$Date);
unless(open(OUTFILE, $FileName))
{
	print 'can not open file ' . $FileName;
	exit -1;
}
print OUTFILE '<html><head><title>top op stat</title>
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
$sTemp = sprintf("<h1 align=center>top op stat</h1>");
print OUTFILE $sTemp;


$sTemp = sprintf("<h1>top 50 fee user</h1>");
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
	print OUTFILE "<tr>\n";
	$sTemp = sprintf("<td>uid</td><td>money</td><td>name</td><td>area</td><td>alliance</td><td>last_login</td><td>reg time</td><td>login days</td><td>invite count</td><td>invite uid</td><td>level</td><td>Gate</td><td>Gold</td>");
	print OUTFILE $sTemp;
        $sTemp = sprintf("<td>TotalGemCount</td><td>Gem1</td><td>Gem2</td><td>Gem3</td><td>Gem4</td><td>Gem5</td><td>Gem6</td><td>Gem7</td><td>Gem8</td><td>Gem9</td><td>Gem10</td>");
        print OUTFILE $sTemp;
	print OUTFILE "</tr>\n";
	
$sql = sprintf("select uid,sum(credit) as c from pay_history group by uid order by c desc limit 50");
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
#@gem1 = (4201,4301,4311,4321,4331,4341,4351,4401,4411,4421,4431,4441,4451,4461,4471);
@gem1 = (4401,4411,4421,4431,4441,4451,4461,4471,4481);
@gem2 = ();@gem3 = ();@gem4 = ();@gem5 = ();@gem6= ();@gem7 = ();@gem8 = ();@gem9 = ();@gem10 = ();
for($i=0;$i<@gem1;$i++)
{
       $gem2[$i]=$gem1[$i]+1;
       $gem3[$i]=$gem1[$i]+2;
       $gem4[$i]=$gem1[$i]+3;
       $gem5[$i]=$gem1[$i]+4;
       $gem6[$i]=$gem1[$i]+5;
       $gem7[$i]=$gem1[$i]+6;
       $gem8[$i]=$gem1[$i]+7;
       $gem9[$i]=$gem1[$i]+8;
       $gem10[$i]=$gem1[$i]+9;
}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$money = $row[1];
	$total=0;
        $sql2 = sprintf("select data from equipment where uid = $uId ");
        $sth2 = $dbh->prepare($sql2);
        if($DBI::errstr){print $sql2 . "\n";}
        $sth2->execute();
        if($DBI::errstr){print $sql2 . "\n";}
        $count1=0;$count2=0;$count3=0;$count4=0;$count5=0;$count6=0;$count7=0;$count8=0;$count9=0;$count10=0; 
        while(@row2 = $sth2->fetchrow_array)
        {
            $data = $row2[0];
            my $obj = decode_json($data);
            $gem_id = $obj->{id};
            for($i=0;$i<@gem1;$i++){
              if($gem_id == $gem1[$i])
              {
                 $count1++;
                 $total++;
                 next;
              }
              if($gem_id == $gem2[$i])
              {
                 $count2++;    
                 $total++;  
                 next;
              }
              if($gem_id == $gem3[$i])
              {
                 $count3++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem4[$i])
              {
                 $count4++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem5[$i])
              {
                 $count5++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem6[$i])
              {
                 $count6++;      
                 $total++;
                 next;
              }
              if($gem_id == $gem7[$i])
              {
                 $count7++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem8[$i])
              {
                 $count8++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem9[$i])
              {
                 $count9++;
                 $total++;      
                 next;
              }
              if($gem_id == $gem10[$i])
              {
                 $count10++;
                 $total++;      
                 next;
              } 
               
            }
        }
        $sth2->finish();

        $sql3=sprintf("select id from gate where data like \"%:0}\" and uid= $uId");
        $sth3 = $dbh->prepare($sql3);
        if($DBI::errstr){print $sql3 . "\n";}
        $sth3->execute();
        $gate=0;
        if($DBI::errstr){print $sql3 . "\n";}
        while(@row3 = $sth3->fetchrow_array)
        {
            $mygate = $row3[0]-1;
        }
        $sth3->finish();

        my $file = sprintf("/usr/local/monitor_sanguo_s14/data/rmbuserpay/daygetCoins_%s.log",$Date);
        if(open(READFILE, $file))
        {
                my @myline=<READFILE>;
                for($ii=0;$ii<@myline;$ii++){
                  @li=split(/\s+/,$myline[$ii]);
                  if($uId == $li[0]){
                    $myuid{$li[0]}=$li[1];
                  }
                }
        }
        close READFILE;
	$sTemp = sprintf("<tr><td>%d</td><td>%.2fRMB</td><td>%s</td><td>%s%s</td><td><a href=http://s14.app100688853.qqopenapp.com/cgi-bin/alliance_info.pl?id=%s&name=%s target=_blank>%s</a></td><td>%s</td><td>%s</td><td>%d</td><td>%d</td><td>%s</td><td>%d</td><td>%d</td><td>%d</td>",
	$uId,$money/100,$Name{$uId},$Province{$uId},$City{$uId},$AllianceId{$uId},$AllianceName{$AllianceId{$uId}},$AllianceName{$AllianceId{$uId}},$LastLoginTime{$uId},$RegTime{$uId},$LoginDays{$uId},$InviteCount{$uId},$InviteUid{$uId},$Level{$uId},$mygate,$myuid{$uId});
	print OUTFILE $sTemp;
        $sTemp = sprintf("<td>$total</td><td>$count1</td><td>$count2</td><td>$count3</td><td>$count4</td><td>$count5</td><td>$count6</td><td>$count7</td><td>$count8</td><td>$count9</td><td>$count10</td></tr>");
        print OUTFILE $sTemp;
}
$sth->finish();

print OUTFILE	'</table>';


$sTemp = sprintf("<h1>top 20 fee user for %s</h1>",$Date);
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
	print OUTFILE "<tr>\n";
	$sTemp = sprintf("<td>uid</td><td>money</td><td>name</td><td>area</td><td>alliance</td><td>last_login</td><td>reg time</td><td>login days</td><td>invite count</td><td>invite uid</td><td>level</td>");
	print OUTFILE $sTemp;
	print OUTFILE "</tr>\n";
	
$sql = sprintf("select uid,sum(credit) as c from pay_history where time>%d and time<%d group by uid order by c desc limit 20",$DateBegin,$DateEnd);
#print $sql . "\n";
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$i=0;
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$money = $row[1];
	
	$sTemp = sprintf("<tr><td>%d</td><td>%.2fRMB</td><td>%s</td><td>%s%s</td><td>%s</td><td>%s</td><td>%s</td><td>%d</td><td>%d</td><td>%s</td><td>%d</td></tr>",
	$uId,$money/100,$Name{$uId},$Province{$uId},$City{$uId},$AllianceName{$AllianceId{$uId}},$LastLoginTime{$uId},$RegTime{$uId},$LoginDays{$uId},$InviteCount{$uId},$InviteUid{$uId},$Level{$uId});
	print OUTFILE $sTemp;
}
$sth->finish();

print OUTFILE	'</table>';


$sTemp = sprintf("<h1>top 20 consume user for %s</h1>",$Date);
print OUTFILE $sTemp;
print OUTFILE	'<table width=100% border=1 bordercolor="#999999" style="border-collapse: collapse" cellpadding="5">';
	print OUTFILE "<tr>\n";
	$sTemp = sprintf("<td>uid</td><td>gold</td><td>name</td><td>area</td><td>alliance</td><td>last_login</td><td>reg time</td><td>login days</td><td>invite count</td><td>invite uid</td><td>level</td>");
	print OUTFILE $sTemp;
	print OUTFILE "</tr>\n";
$i = 0;
foreach $uId (sort {$Consume{$b} <=> $Consume{$a} }keys(%Consume)) 
{
        if($uId != '11000093'){
	$sTemp = sprintf("<tr><td>%d</td><td>%d G</td><td>%s</td><td>%s%s</td><td>%s</td><td>%s</td><td>%s</td><td>%d</td><td>%d</td><td>%s</td><td>%d</td></tr>",
	$uId,$Consume{$uId},$Name{$uId},$Province{$uId},$City{$uId},$AllianceName{$AllianceId{$uId}},$LastLoginTime{$uId},$RegTime{$uId},$LoginDays{$uId},$InviteCount{$uId},$InviteUid{$uId},$Level{$uId});
	print OUTFILE $sTemp;
	$i++;
        }
	if($i>20)
	{
		last;
	}
}

print OUTFILE	'</table>';

print OUTFILE	'</body></html>';
close(OUTFILE);
