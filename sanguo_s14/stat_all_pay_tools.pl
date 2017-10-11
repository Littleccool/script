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
                $type = $Value{"type"};
                if($type eq 0){
                   $price1 = $Value{"price"};
                   $amount1 = $Value{"amount"};
		   $total1 =  (0-$price1)*$amount1;
                }
                if($type eq 1){
                   $price2 = $Value{"price"};
                   $amount2 = $Value{"amount"};
                   $total2 = (0-$price2)*$amount2;
                }
                if(($total1<0)||($total2<0))
                {
                     next;
                }
		if(not $IsPayToolsUserMarked{$uId})
		{
			$IsPayToolsUserMarked{$uId} = 1;
			$RMBUserAllPayUserCount++;
		}
		
                        $RMBUserTotalAmount{$code} +=$amount;
			$RMBUserTotalAmount1{$code} += $amount1;
                        $RMBUserTotalAmount2{$code} += $amount2;
			$RMBUserTotalMoney1{$code}  += $total1;
                        $RMBUserTotalMoney2{$code}  += $total2;
			$RMBUserall_pay1 += $total1;
                        $RMBUserall_pay2 += $total2;
			if ($code eq "SHOP")
			{
                                $RMBShopItemTAmount{$codeStr} += $amount;
				$RMBShopItemTAmount1{$codeStr} += $amount1;
                                $RMBShopItemTAmount2{$codeStr} += $amount2;
				$RMBShopItemTMoney1{$codeStr} += $total1;
                                $RMBShopItemTMoney2{$codeStr} += $total2;
				$RMBShopItemAllPay1 += $total1;
                                $RMBShopItemAllPay2 += $total2;

				if (not $RMBShopItemAllMap{$uId})
				{
					$RMBShopItemAllMap{$uId} = 1;
					$RMBShopItemAllCount++;
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
		$rmbuser_count_datas14 = $RMBUserTotalAmount1{$key};
                $rmbuser_count_datas14 = $RMBUserTotalAmount2{$key};
		$rmbuser_money_datas14 = $RMBUserTotalMoney1{$key};
                $rmbuser_money_datas14 = $RMBUserTotalMoney2{$key};
	}
	else
	{
		$rmbuser_tool_datas .= ',' . $key;
		$rmbuser_count_datas .= ',' . $RMBUserTotalAmount1{$key} . ':'.$RMBUserTotalAmount2{$key} ;
		$rmbuser_money_datas .= ',' . $RMBUserTotalMoney1{$key}. ':'.$RMBUserTotalMoney2{$key};
	}
	$i++;
}
$myDAUFile = sprintf(">%s/data/rmbuserpay/rmbuserpay2_%s.log",$monitor_path,$Date);
if(open(RMBUSERPAY, $myDAUFile))
{
	print RMBUSERPAY $Date."|".$RMBUserAllPayUserCount."|".$RMBUserall_pay1.",".$RMBUserall_pay2."|";
	print RMBUSERPAY $rmbuser_tool_datas."|";
	print RMBUSERPAY $rmbuser_money_datas."\n";
	close(RMBUSERPAY);
}

$i=0;
foreach $key (keys(%RMBShopItemTAmount))
{
	if($i==0)
	{
		$rmbshopitem_tool_datas = $key;
		$rmbshopitem_count_datas14 = $RMBShopItemTAmount1{$key};
                $rmbshopitem_count_datas14 = $RMBShopItemTAmount2{$key};
                $rmbshopitem_money_datas14 = $RMBShopItemTMoney1{$key};
		$rmbshopitem_money_datas14 = $RMBShopItemTMoney2{$key};
	}
	else
	{
		$rmbshopitem_tool_datas .= ',' . $key;
		$rmbshopitem_count_datas .= ',' . $RMBShopItemTAmount1{$key}.':'.$RMBShopItemTAmount2{$key};
		$rmbshopitem_money_datas .= ',' . $RMBShopItemTMoney1{$key}.':'.$RMBShopItemTMoney2{$key};
	}
	$i++;
}
$myShopFile = sprintf(">%s/data/rmbuserpay/rmbshopitem2_%s.log",$monitor_path,$Date);
if(open(RMSHOPITEM, $myShopFile))
{
	print RMSHOPITEM $Date."|".$RMBShopItemAllCount."|".$RMBShopItemAllPay1.",".$RMBShopItemAllPay2."|";
	print RMSHOPITEM $rmbshopitem_tool_datas."|";
	print RMSHOPITEM $rmbshopitem_money_datas."\n";
	close(RMSHOPITEM);
}
