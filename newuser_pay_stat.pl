#!/usr/bin/perl
use Time::Local;
#use CGI;
use DBI;
use Switch;
use Data::Dumper;
require "/usr/local/script/sub.pl";

if(@ARGV ne 2){
	print "usage: newuser_pay_stat.pl appId date";
	exit;
}

my $appId = defined $ARGV[0] ? $ARGV[0] : 0;

my $date = defined $ARGV[1] ? $ARGV[1] : `date -d "1 days ago" +"%Y%m%d"`;
   $date =~ tr/\n//d;
die "date error" unless (length($date) == 8);

my $lines_len_pay = 0;
my $lines_len_charge = 0;
my $statType_pay = "first";
my $statType_charge = "first";
my $pre_day = `date -d"$date 1 days ago" +%Y%m%d`;
$pre_day =~ tr/\n//d;
my $pre_file_pay = "/usr/local/script/data/npop/newuser_pay_$appId_$pre_day";
my $pre_file_charge = "/usr/local/script/data/npop/newuser_charge_$appId_$pre_day";
if(-f $pre_file_pay) {
	open(FD, $pre_file_pay) || die("Can not open $pre_file_pay!\n");
	@lines_pay = <FD>;
	close(FD);
	$statType_pay = "daily";
	$lines_len_pay = @lines_pay;
}
if(-f $pre_file_charge) {
	open(FD, $pre_file_charge) || die("Can not open $pre_file_charge!\n");
	@lines_charge = <FD>;
	close(FD);
	$statType_charge = "daily";
	$lines_len_charge = @lines_charge;
}

my $file_pay = "/usr/local/script/data/npop/newuser_pay_$appId_$date";
my $file_charge = "/usr/local/script/data/npop/newuser_charge_$appId_$date";
open(HD_PAY, ">$file_pay");
open(HD_CHARGE, ">$file_charge");
my $handle_pay = \*HD_PAY;
my $handle_charge = \*HD_CHARGE;
if(($statType_pay eq "daily") && ($statType_charge eq "daily")) {
	&statDaily($handle_pay);
	&statDaily($handle_charge);
} else {
	&statFirst($handle_pay, $handle_charge);
}
close(HD_PAY);
close(HD_CHARGE);


sub statDaily
{
	my $fileHandle = $_[0];
	my @lines;
	my $lines_len = 0;
	if ($fileHandle == \*HD_PAY) {
		@lines = @lines_pay;
		$lines_len = $lines_len_pay;
	} else {
		@lines = @lines_charge;
		$lines_len = $lines_len_charge;
	}

	my $theDate = $date;
	my $sec = `date -d "$theDate" +%s`;
	$sec =~ tr/\n//d;
	for(my $i = 0; $i < $lines_len + 1; ++$i) {
		if($i > 0) {
			@arr = split(/,/, $lines[$i-1]);
			$theDate = $arr[0];
		}
		my $year = substr($theDate, 0, 4) + 0;
		my $month = substr($theDate, 4, 2) + 0;
		my $day = substr($theDate, 6, 2) + 0;
		my $dayBegTime = timelocal(0, 0, 0, $day, $month - 1, $year - 1900);
		my $dayEndTime = timelocal(59, 59, 23, $day, $month - 1, $year - 1900);
        my $sql = "select sum(A.rmb),count(distinct B.uid) from stat.game_user as B, pay_history as A where A.appId = $appId and A.appId = B.appId and A.uid=B.uid and  B.regTs > $dayBegTime  and B.regTs <= $dayEndTime and (A.chargeTs > $sec and A.chargeTs < $sec + 86400)";
		if($appId eq 10000){
			$sql = "select sum(A.rmb),count(distinct B.uid) from stat.game_user as B, pay_history as A where A.appId=B.appId and A.uid=B.uid and  B.regTs > $dayBegTime  and B.regTs <= $dayEndTime and (A.chargeTs > $sec and A.chargeTs < $sec + 86400)";
		}
		
		#print $sql . "\n\n";
        my $sth = getStatDb()->prepare($sql);
        $sth->execute();
        my @row = $sth->fetchrow_array;
		my $money = $row[0] ? $row[0] : 0;
        my $chargedUids = $row[1] ? $row[1] : 0;

	if($theDate eq 20170911){
		#print $sql . "\n";
		#print $sec . " " . $money . "\n";
	}
		my $data = "";
		if($i == 0) {
			my $sql="SELECT count(distinct uid) FROM stat.game_user A WHERE appId = $appId and A.regTs>=$dayBegTime and A.regTs<=$dayEndTime";
			if($appId eq 10000){
				$sql="SELECT count(distinct uid) FROM stat.game_user A WHERE  A.regTs>=$dayBegTime and A.regTs<=$dayEndTime";
			}
			
			#print $sql . "\n";

			my $sth = getStatDb()->prepare($sql);
			$sth->execute();
			my @row = $sth->fetchrow_array;
			# 注册人数为 0 时，不予显示 ,若要显示, 可注释掉该判断
			if($row[0] <= 0) {
				next;
			}
			if ($fileHandle == \*HD_PAY) {
				$data .= $theDate. ",". $row[0]. ",". $money;
			} else {
				$data .= $theDate. ",". $row[0]. ",". $chargedUids. "|". $money;
			}
		
		} else {
			$lines[$i-1] =~ tr/\n//d;
			@arr = split(/,/, $lines[$i-1]);
			if(@arr < 102) {
				if ($fileHandle == \*HD_PAY) {
					$money += $arr[$#arr];
					$data .= $lines[$i-1]. ",". $money;
				} else {
					$data .= $lines[$i-1]. ",". $chargedUids. "|". $money;
				}
			} else {
				for(my $i = 0; $i < $#arr; ++$i) {
					$data .= $arr[$i]. ",";
				}
				if ($fileHandle == \*HD_PAY) {
					$arr[$#arr] += $money;
					$data .= $arr[$#arr];
				} else {
					my @arr = split "|",$arr[$#arr];
					$data .= ($arr[0] + $chargedUids). "|". ($arr[1] + $money);
				}
			}
		}
		print $fileHandle $data."\n";
	}
}


sub statFirst
{
my $handle_pay = $_[0];
my $handle_charge = $_[1];
my $sql = "select min(regTs) from stat.game_user";
my $sth = getStatDb()->prepare($sql);
$sth->execute();
my @row = $sth->fetchrow_array;
my $minTime = $row[0];
if($minTime == Null) {
	exit(1);
}
my $minDate = dateTimeToString2($minTime);
print $minDate . "\n";
my @day = (1..100);
for(my $i = 1; $i < 10000; ++$i) {
        my $data_pay = ""; 
        my $d = `date -d "$i days ago" +%Y%m%d`;
        $d =~ tr/\n//d;
        if($d < $minDate){
                last;
        }

	my $year = substr($d, 0, 4) + 0;
	my $month = substr($d, 4, 2) + 0;
	my $day = substr($d, 6, 2) + 0;
	my $dayBegTime = timelocal(0, 0, 0, $day, $month - 1, $year - 1900);
	my $dayEndTime = timelocal(59, 59, 23, $day, $month - 1, $year - 1900);
	my $sql = "select count(distinct A.uid) from stat.game_user A where regTs<=$dayEndTime and regTs>=$dayBegTime";
	if($appId eq 10000){
		$sql="SELECT count(distinct uid) FROM stat.game_user A WHERE  A.regTs>=$dayBegTime and A.regTs<=$dayEndTime";
	}else{
		$sql="SELECT count(distinct uid) FROM stat.game_user A WHERE appId = $appId and A.regTs>=$dayBegTime and A.regTs<=$dayEndTime";
	}
	
			#print $sql . "\n";

        my $sth = getStatDb()->prepare($sql);
        $sth->execute();
        my @row = $sth->fetchrow_array;
        if($row[0] <= 0) {
                next;
        }
        $data_pay .= $d.",".$row[0];

        my @arr;
        my @chargedUids;
        my $j = $i;
        my $counter = 0;
        while(1) {
                my $tempDate = `date -d "$j days ago" +%Y%m%d`;
                $tempDate =~ tr/\n//d;
                if($tempDate > $date) {
                        last;
                }

                if($row[0]) {
                        my $sec = `date -d "$tempDate" +%s`;
                        $sec =~ tr/\n//d;
						
						my $sql="select sum(A.rmb),count(distinct B.uid) from stat.game_user as B, pay_history as A where A.appId = B.appId and A.uid=B.uid and B.regTs >= $dayBegTime and B.regTs <= $dayEndTime and (A.chargeTs > $sec and A.chargeTs < $sec + 86400)";
						if($appId ne 10000){
							$sql = "select sum(A.rmb),count(distinct B.uid) from stat.game_user as B, pay_history as A where A.appId = $appId and A.appId = B.appId and A.uid=B.uid and B.regTs >= $dayBegTime and B.regTs <= $dayEndTime and (A.chargeTs > $sec and A.chargeTs < $sec + 86400)";
						}
						
						#print $sql . "\n";

                        my $sth = getStatDb()->prepare($sql);
                        $sth->execute();
                        my @row = $sth->fetchrow_array;
                        $arr[$counter] = $row[0] ? $row[0] : 0;
                        $chargedUids[$counter] = $row[1] ? $row[1] : 0;
                }
                --$j;
                ++$counter;
        }

	my $data_charge = $data_pay;
    my $total_pay = 0;
    my $total_charge = 0;
    for(my $j = 0; $j < @day; ++$j) {
       if($counter < $day[$j]) {
           last;
       }
		for(my $k = $j ? $day[$j - 1] : 0; $k < $counter; ++$k) {
			if($j < @day - 1 &&  $k + 1 > $day[$j]) {
				last;
			}
			$total_pay += $arr[$k];
		}

		$total_charge = $arr[$j];
		if($j == @day - 1) {
			for(my $k = $j + 1; $k < $counter; ++$k) {
				$total_charge += $arr[$k];
			}
			
		}
			$data_pay .= ",". $total_pay;
			$data_charge .= ",". $chargedUids[$j]. "|". $total_charge;
        }

	print $handle_pay $data_pay. "\n";
	print $handle_charge $data_charge. "\n";
}
}
 printInfo($0,2);

