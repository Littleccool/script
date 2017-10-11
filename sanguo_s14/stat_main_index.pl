#!/usr/bin/perl

$numbers=@ARGV;

use JSON;
use Data::Dumper;
my $json = new JSON;

$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/datalog";
$monitor_path="/usr/local/monitor_sanguo_s14";
if($numbers == 1)
{
	$Date = $ARGV[0];
}
else
{
	$Date = `date -d "1 days ago" +%Y%m%d`;
	$Date =~ tr/\r\n//d;
}
$DateYesterday = `date -d "1 days ago $Date" +%Y%m%d`;
$DateYesterday =~ tr/\r\n//d;
$DateBegin = `date -d "$Date" +%s`;
$DateBegin =~ tr/\r\n//d;
$DateEnd = `date -d "$Date 23:59:59" +%s`;
$DateEnd =~ tr/\r\n//d;

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sanguo = &setDBSanguo();
$dbh_stat = &setDBStat();

$myAllUserFile = sprintf("%s/data/DAU/all.txt",$monitor_path);
unless(open(ALLUSERFILE, $myAllUserFile))
{
	print 'can not open file ' . $myAllUserFile . "!\n";
	exit -1;
}
while ($line=<ALLUSERFILE>) 
{
	$line =~ tr/\r\n//d;
	$IsAllUserMarked{$line} = 1;
	$AllUserCount++;
}
close(ALLUSERFILE);

$DataFile=sprintf(">%s/data/sanguo/user_data_%s.txt",$monitor_path,$Date);
unless(open(DATAFILE,$DataFile))
{
        print "can not open file $DataFile.\n";
        #exit -1;
}
#binmode(DATAFILE, ':encoding(utf8)');
$DataFile=sprintf(">%s/data/newuser/user_%s.txt",$monitor_path,$Date);
unless(open(NEWUSERFILE,$DataFile))
{
        print "can not open file $DataFile.\n";
        #exit -1;
}

$sql = sprintf("select uid,name,figure_url,platform from user_basic where is_register_platform=1");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$Name{$uId} = $row[1];
	$Figure{$uId} = $row[2];
	$platform{$uId} = $row[3];
}
$sth->finish();

$sql = sprintf("select uid from pay_history where status=1");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	$IsPayedUser{$uId} = 1;
}
$sth->finish();

$myAllUserFile = sprintf(">%s/data/newuser/pay_%s.txt",$monitor_path,$Date);
unless(open(PAYNEWUSERFILE, $myAllUserFile))
{
	print 'can not open file ' . $myAllUserFile . "!\n";
	exit -1;
}

$begin_second=`date -d $Date +%s`;
$end_second=`date -d "$Date 23:59:59" +%s`;
$begin_second =~ tr/\r\n//d;
$end_second =~ tr/\r\n//d;
$sql = sprintf("select uid,register_time,point,level,tutorial_stage,0,invite_uid from user");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}

while (@row = $sth->fetchrow_array)
{
	$uId = $row[0];
	
	$CreateTime{$uId} = $row[1];
	$Points{$uId} = $row[2]+$row[5];
	$Level{$uId} = $row[3];
	$Tutorialstage{$uId} = $row[4];
	$invite_uid = $row[6];
	$Openid{$uId} = '';
 	if($CreateTime{$uId}>=$DateBegin  && $CreateTime{$uId}<=$DateEnd ) #new user;
	{
		#$RookieTutorialstage{$obj->{tutorialstage}}++;
		print NEWUSERFILE $uId . "\n";
		if($IsPayedUser{$uId})
		{
			print PAYNEWUSERFILE $uId . "\n";
		}
		$all_rookie_count++;
		if($invite_uid > 0)
		{
			$DIUed++;
		}
		if(!$InviteUserMarked{$invite_uid})
		{
			$DIU++;
			$InviteUserMarked{$invite_uid} = 1;
		}
		($RookieTutorialstage->{$Tutorialstage{$uId}})++;
	}
}
$sth->finish();
$DNU=$all_rookie_count;


my $i=0;
print DATAFILE "{";
foreach $key (sort {$Points{$b} <=> $Points{$a} }keys(%Points)) {
	$i++;
	$sTemp = sprintf('"%d":{"id":%s,"openid":"%s","name":"%s","photo":"%s","level":%s,"point":"%dw","pt":"%d"}',
		$i,$key,$Openid{$key},$Name{$key},$Figure{$key},$Level{$key},$Points{$key}/10000,$platform{$key});
	print DATAFILE $sTemp;
	if($i>=10)
	{
		last;
	}
	else
	{
		print DATAFILE ",";
	}
}
print DATAFILE "}\n";

$stage_datas="";
if($RookieTutorialstage)
{
	$stage_datas = encode_json($RookieTutorialstage);
}
printf("stage datas:%s\n",$stage_datas);

$myDAUFile = sprintf(">%s/data/DAU/data_%s.log",$monitor_path,$Date);
unless(open(DAUFILE, $myDAUFile))
{
	print 'can not open file ' . $myDAUFile . "!\n";
	exit -1;
}
$myAllUserFile = sprintf(">>%s/data/DAU/all.txt",$monitor_path);
unless(open(ALLUSERFILE, $myAllUserFile))
{
	print 'can not open file ' . $myAllUserFile . "!\n";
	exit -1;
}
$myAllUserFile = sprintf(">%s/data/DAU/invited_%s.txt",$monitor_path,$Date);
unless(open(INVITEDUSERFILE, $myAllUserFile))
{
	print 'can not open file ' . $myAllUserFile . "!\n";
	exit -1;
}

$FileName = sprintf("%s/data_%s.log",$log_path,$Date);
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
	if($number!=5)
	{
		next;
	}
	#print $line . "\n";
	$op = $list[1];
	$direction = $list[3];	
	$Value{"err"} = "";
	@list2 = split(/\&/,$list[4]);
	for($i=0;$i<@list2;$i++)
	{
		@pair = split(/\=/,$list2[$i]);
		$Value{$pair[0]} = $pair[1];
	}
	if($Value{"data"} eq "sendfeed" && $Value{"feedid"}>0)
	{
		$FeedCount{$Value{"feedid"}} ++;
		$TitleOfFeed{$Value{"feedid"}} = $Value{"title"};
		next;
	}
	if($Value{"uId"} !~ /^\d+$/)
	{
		$Value{"uId"} = $Value{"uid"};
		if($Value{"uId"} !~ /^\d+$/)
		{
			next;
		}
	}
	if($Value{"err"}){next;}
	if($Value{"uId"} && $op eq "login")
	{
		$uId = $Value{"uId"};
		if(not $IsDAUByUidMarked{$uId})
		{
			print DAUFILE "$uId\n";
			$IsDAUByUidMarked{$uId} = 1;
			$DAUCount++;
			if($op eq "login")
			{
				$LoginScore{$uId} = 5;
			}
		}
		if(not $IsAllUserMarked{$uId})
		{
			print ALLUSERFILE "$uId\n";
			$IsAllUserMarked{$uId} = 1;
			$AllUserCount++;
		}
	}
	elsif($Value{"uId"} && $op eq "purchase")
	{
		$uId = $Value{"uId"};
		$item = $Value{"item"};
		$count = $Value{"count"};
		$cash = $Value{"cash"};
		if($cash >= 0)
		{
			next;
		}
		else
		{
			$cash = 0 - $cash;
		}
		if(not $IsPayToolsUserMarked{$uId})
		{
			$IsPayToolsUserMarked{$uId} = 1;
			$AllPayToolsUserCount++;
		}
		$TotalAmount{$item} ++;
		$TotalMoney{$item}  += $cash;
		$all_pay += $cash;
	}
}
close(MYFILE);
close(DAUFILE);
close(ALLUSERFILE);
close(INVITEDUSERFILE);
close(PAYNEWUSERFILE);

$i=0;
foreach $key (sort {$TotalAmount{$b} <=> $TotalAmount{$a} }keys(%TotalAmount)) {
	if($i==0)
	{
		$tool_datas = $key;
		$count_datas = $TotalAmount{$key};
		$money_datas = $TotalMoney{$key};
	}
	else
	{
		$tool_datas .= ',' . $key;
		$count_datas .= ',' . $TotalAmount{$key};
		$money_datas .= ',' . $TotalMoney{$key};
	}
	$i++;
}
$sql = sprintf("replace into table_pay_tools_stat(date,user_count,all_money,tool_datas,count_datas,money_datas) values(\'%s\',%d,%d,\'%s\',\'%s\',\'%s\')",
	$Date,$AllPayToolsUserCount,$all_pay,$tool_datas,$count_datas,$money_datas);
	print $sql . "\n";
$dbh = $dbh_stat;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}

$OldUserReturn=`sort /usr/local/monitor_sanguo_s14/data/DAU/data_$DateYesterday.log /usr/local/monitor_sanguo_s14/data/newuser/user_$DateYesterday.txt |uniq -u >  /usr/local/monitor_sanguo_s14/data/newuser/old_$DateYesterday.txt;sort  /usr/local/monitor_sanguo_s14/data/newuser/old_$DateYesterday.txt /usr/local/monitor_sanguo_s14/data/DAU/data_$Date.log |uniq -d|wc -l`;

$i=1;
$DateTemp = $Date;
while($i<=30)
{	
	#print $DateTemp . "\n";
	$FileName=$monitor_path."/data/DAU/data_" . $DateTemp . ".log";
	unless(open(MYFILE, $FileName)) 
	{
		$DateTemp=`date -d "1 days ago $DateTemp" +%Y%m%d`;
		$DateTemp =~ tr/\r\n//d;
		$i++;
		next;
	}
	while ($line=<MYFILE>) 
	{
		$line =~ tr/\r\n//d;
		$uId = $line;
		if(not $IsMAUByUidMarked{$uId})
		{
			$IsMAUByUidMarked{$uId} = 1;
			$MAUCount++;
		}
	}
	
	$DateTemp=`date -d "1 days ago $DateTemp" +%Y%m%d`;
	$DateTemp =~ tr/\r\n//d;
	$i++;
	close(MYFILE);
}

$i=1;
$DateTemp = $Date;
while($i<=14)
{	
	#print $DateTemp . "\n";
	$FileName=$monitor_path."/data/DAU/data_" . $DateTemp . ".log";
	unless(open(MYFILE, $FileName)) 
	{
		$DateTemp=`date -d "1 days ago $DateTemp" +%Y%m%d`;
		$DateTemp =~ tr/\r\n//d;
		$i++;
		next;
	}
	while ($line=<MYFILE>) 
	{
		$line =~ tr/\r\n//d;
		$uId = $line;
		if(not $IsDoubleWeekUserMarked{$uId})
		{
			$IsDoubleWeekUserMarked{$uId} = 1;
			$DoubleWeekCount++;
		}
		if($i>1 && $i<6)
		{
			$LoginScore{$uId}++;
		}
	}
	
	$DateTemp=`date -d "1 days ago $DateTemp" +%Y%m%d`;
	$DateTemp =~ tr/\r\n//d;
	$i++;
	close(MYFILE);
}

$sql = sprintf("replace into table_tutorial_stage(date,rookie_count,Datas) values(\'%s\',%d,\'%s\')", $Date,$all_rookie_count,$stage_datas);
print $sql . "\n";
$dbh = $dbh_stat;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$sth->finish();


printf("DAU:%d,MAU:%d,DNU:%d,OldUserReturn:%d\n",$DAUCount,$MAUCount,$DNU,$OldUserReturn);
printf("All:%d,DoubleWeekCount:%d,Inactive:%d\n",$AllUserCount,$DoubleWeekCount,$AllUserCount-$DoubleWeekCount);

$DOU=$DAUCount-$DNU;
$sql = sprintf("replace into table_user_day_data_stat(date,AllUserCount,DAU,DWAU,MAU,DNU,DOU,DBU,DLU,DSU,DHU,DMU,DTU,DVU,DVC,DWU,DWC,DWUed,DWCed,DIU,DIUed,old_user_return) values (\'%s\',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d)", 
		$Date,$AllUserCount,$DAUCount,$DoubleWeekCount,$MAUCount,$DNU,$DOU,$DCUCount,0,0,0,0,0,0,0,0,0,0,0,$DIU,$DIUed,$OldUserReturn);
print $sql . "\n";
$dbh = $dbh_stat;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
$sth->finish();

$myFile = sprintf(">%s/data/score/login_%s.txt",$monitor_path,$Date);
unless(open(OUTFILE, $myFile))
{
	print 'can not open file ' . $myFile. "!\n";
	exit -1;
}
foreach $key (sort {$LoginScore{$b} <=> $LoginScore{$a} }keys(%LoginScore)) {
	$sTemp = sprintf("%s\t%d\n",$key,$LoginScore{$key});
	print OUTFILE $sTemp;
}
close(OUTFILE);

foreach $key (keys(%FeedCount)) {
	$sql = sprintf("replace into table_feeds_stat(date,feedid,feed_count,title) values (\'%s\',%d,%d,\'%s\')", 
		$Date,$key,$FeedCount{$key},$TitleOfFeed{$key});
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
}

foreach $key (keys(%FeedCount)) {
	$sql = sprintf("replace into table_feeds_stat(date,feedid,feed_count,title) values (\'%s\',%d,%d,\'%s\')", 
		$Date,$key,$FeedCount{$key},$TitleOfFeed{$key});
	print $sql . "\n";
	$dbh = $dbh_stat;
	$sth = $dbh->prepare($sql);
	if($DBI::errstr){print $sql . "\n";}
	$sth->execute();
	if($DBI::errstr){print $sql . "\n";}
	$sth->finish();
}

$dbh_stat->disconnect();
$dbh_sanguo->disconnect();
exit;

