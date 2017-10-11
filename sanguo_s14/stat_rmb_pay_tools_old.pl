#!/usr/bin/perl

$numbers=@ARGV;

$script_path="/usr/local/script/sanguo_s14";
$log_path="/data/release/sgonline/s14/log/business";
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
$dbh_sg = &setDBSanguo();

$sql = sprintf("select distinct uid from pay_history where status=1 and time<=%s",$DateEnd);
$dbh = $dbh_sg;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
	$IsRMBUser{$row[0]} = 1;
}
$sth->finish();

$FileName = sprintf("%s/orders_%s.log",$log_path,$Date);
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
	if($Value{"uid"} !~ /^\d+$/)
	{
		next;
	}
	if($Value{"uid"} && $Value{"code"})
	{
		$uId = $Value{"uid"};
		$codeStr = $Value{"code"};
		@codes = split(/_/, $codeStr);
		$code = $codes[0];
		$amount = $Value{"amount"};
		$price = $Value{"price"};
		$total = (0 - $price) * $amount;
		if($total <= 0)
		{
			next;
		}
		if(not $IsPayToolsUserMarked{$uId})
		{
			$IsPayToolsUserMarked{$uId} = 1;
			if($IsRMBUser{$uId})
			{
				$RMBUserAllPayUserCount++;
			}
		}
		
		if($IsRMBUser{$uId})
		{
			$RMBUserTotalAmount{$code} += $amount;
			$RMBUserTotalMoney{$code}  += $total;
			$RMBUserall_pay += $total;
			if ($code eq "SHOP")
			{
				$RMBShopItemTAmount{$codeStr} += $amount;
				$RMBShopItemTMoney{$codeStr} += $total;
				$RMBShopItemAllPay += $total;
				if (not $RMBShopItemAllMap{$uId})
				{
					$RMBShopItemAllMap{$uId} = 1;
					$RMBShopItemAllCount++;
				}
			}
		}
	}
}
close(MYFILE);

$i=0;
foreach $key (keys(%RMBUserTotalAmount))
{
	if($i==0)
	{
		$rmbuser_tool_datas = $key;
		$rmbuser_count_datas = $RMBUserTotalAmount{$key};
		$rmbuser_money_datas = $RMBUserTotalMoney{$key};
	}
	else
	{
		$rmbuser_tool_datas .= ',' . $key;
		$rmbuser_count_datas .= ',' . $RMBUserTotalAmount{$key};
		$rmbuser_money_datas .= ',' . $RMBUserTotalMoney{$key};
	}
	$i++;
}
$myDAUFile = sprintf(">%s/data/rmbuserpay/rmbuserpay_%s.log",$monitor_path,$Date);
if(open(RMBUSERPAY, $myDAUFile))
{
	print RMBUSERPAY $Date."|".$RMBUserAllPayUserCount."|".$RMBUserall_pay."|";
	print RMBUSERPAY $rmbuser_tool_datas."|";
	print RMBUSERPAY $rmbuser_count_datas."|";
	print RMBUSERPAY $rmbuser_money_datas."\n";
	close(RMBUSERPAY);
}

$i=0;
foreach $key (keys(%RMBShopItemTAmount))
{
	if($i==0)
	{
		$rmbshopitem_tool_datas = $key;
		$rmbshopitem_count_datas = $RMBShopItemTAmount{$key};
		$rmbshopitem_money_datas = $RMBShopItemTMoney{$key};
	}
	else
	{
		$rmbshopitem_tool_datas .= ',' . $key;
		$rmbshopitem_count_datas .= ',' . $RMBShopItemTAmount{$key};
		$rmbshopitem_money_datas .= ',' . $RMBShopItemTMoney{$key};
	}
	$i++;
}
$myShopFile = sprintf(">%s/data/rmbuserpay/rmbshopitem_%s.log",$monitor_path,$Date);
if(open(RMSHOPITEM, $myShopFile))
{
	print RMSHOPITEM $Date."|".$RMBShopItemAllCount."|".$RMBShopItemAllPay."|";
	print RMSHOPITEM $rmbshopitem_tool_datas."|";
	print RMSHOPITEM $rmbshopitem_count_datas."|";
	print RMSHOPITEM $rmbshopitem_money_datas."\n";
	close(RMSHOPITEM);
}
