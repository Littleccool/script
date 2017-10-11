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
$Date0 = `date -d "0 days ago" +%Y%m%d`;
$Date0 =~ tr/\r\n//d;
use DBI;
require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sg = &setDBSanguo();

$sql = sprintf("select level,uid from user where unix_timestamp($Date)-register_time>86400 and unix_timestamp($Date)-register_time<=172800");
$dbh = $dbh_sg;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
@level=(0,0,0,0,0,0,0);
$num=0;
if($DBI::errstr){print $sql . "\n";}
while(@row = $sth->fetchrow_array)
{
        $uid=$row[1];
        $IsUser{$uid}=1;
        if($row[0]<=5)
        {
           $level[0]++;$num++;next;
        }
        if($row[0]>5&&$row[0]<=10)
        {
           $level[1]++;$num++;next;
        }
        if($row[0]>10&&$row[0]<=15)
        {
           $level[2]++;$num++;next;
        }
        if($row[0]>15&&$row[0]<=20)
        {
           $level[3]++;$num++;next;
        }
        if($row[0]>20&&$row[0]<=25)
        {
           $level[4]++;$num++;next;
        }
        if($row[0]>25&&$row[0]<=30)
        {
           $level[5]++;$num++;next;
        }
       else 
        {
           $level[6]++;$num++;next;
        }
 
}
$sth->finish();
#$s=0;
#for($i=0;$i<7;$i++)
#{
#   $s+=$level[$i];
#   print "$level[$i]\n";
#}
#print "$s=============$num\n";
#foreach $kk(keys(%IsUser))
#{
#  print "$kk\n";
#}
#exit;

@b_count1=(0,0,0,0,0,0,0);@b_count2=(0,0,0,0,0,0,0);@b_count3=(0,0,0,0,0,0,0);@b_count4=(0,0,0,0,0,0,0);
@b_count5=(0,0,0,0,0,0,0);@b_count6=(0,0,0,0,0,0,0);@b_count7=(0,0,0,0,0,0,0);@b_count8=(0,0,0,0,0,0,0);
@b_count9=(0,0,0,0,0,0,0);@b_count10=(0,0,0,0,0,0,0);@b_count11=(0,0,0,0,0,0,0);@b_count12=(0,0,0,0,0,0,0);
@b_count13=(0,0,0,0,0,0,0);@b_count14=(0,0,0,0,0,0,0);

foreach $bkey(keys(%IsUser))
{
 $sql2 = sprintf("select data from building where uid='$bkey' ");
 #print $sql2 . "\n";
 # print "\n===$bkey===\n";
 $sth = $dbh->prepare($sql2);
 if($DBI::errstr){print $sql2 . "\n";}
 $sth->execute();
 if($DBI::errstr){print $sql2 . "\n";}
   while (@row = $sth->fetchrow_array)
   {
        $data = $row[0];
        my $obj = decode_json($data);
        $b_type = $obj->{t};
        $b_level = $obj->{l};
        if($b_level <= 5)
        {
           if($b_type == 1){$b_count1[0]++;next;}
           if($b_type == 21){$b_count2[0]++;next;}
           if($b_type == 3){$b_count3[0]++;next;}
           if($b_type == 22){$b_count4[0]++;next;}
           if($b_type == 7){$b_count5[0]++;next;}
           if($b_type == 8){$b_count6[0]++;next;}
           if($b_type == 9){$b_count7[0]++;next;}
           if($b_type == 6){$b_count8[0]++;next;}
           if($b_type == 17){$b_count9[0]++;next;}
           if($b_type == 11){$b_count10[0]++;next;}
           if($b_type == 2){$b_count11[0]++;next;}
           if($b_type == 37){$b_count12[0]++;next;}
           if($b_type == 39){$b_count13[0]++;next;}
           if($b_type == 38){$b_count14[0]++;next;}
        }
        if($b_level<=10&&$b_level>5)
        {
           if($b_type == 1){$b_count1[1]++;next;}
           if($b_type == 21){$b_count2[1]++;next;}
           if($b_type == 3){$b_count3[1]++;next;}
           if($b_type == 22){$b_count4[1]++;next;}
           if($b_type == 7){$b_count5[1]++;next;}
           if($b_type == 8){$b_count6[1]++;next;}
           if($b_type == 9){$b_count7[1]++;next;}
           if($b_type == 6){$b_count8[1]++;next;}
           if($b_type == 17){$b_count9[1]++;next;}
           if($b_type == 11){$b_count10[1]++;next;}
           if($b_type == 2){$b_count11[1]++;next;}
           if($b_type == 37){$b_count12[1]++;next;}
           if($b_type == 39){$b_count13[1]++;next;}
           if($b_type == 38){$b_count14[1]++;next;}
        }
        if($b_level<=15&&$b_level>10) 
        {
           if($b_type == 1){$b_count1[2]++;next;}
           if($b_type == 21){$b_count2[2]++;next;}
           if($b_type == 3){$b_count3[2]++;next;}
           if($b_type == 22){$b_count4[2]++;next;}
           if($b_type == 7){$b_count5[2]++;next;}
           if($b_type == 8){$b_count6[2]++;next;}
           if($b_type == 9){$b_count7[2]++;next;}
           if($b_type == 6){$b_count8[2]++;next;}
           if($b_type == 17){$b_count9[2]++;next;}
           if($b_type == 11){$b_count10[2]++;next;}
           if($b_type == 2){$b_count11[2]++;next;}
           if($b_type == 37){$b_count12[2]++;next;}
           if($b_type == 39){$b_count13[2]++;next;}
           if($b_type == 38){$b_count14[2]++;next;}
        }
        if($b_level<=20&&$b_level>15)
        {
           if($b_type == 1){$b_count1[3]++;next;}
           if($b_type == 21){$b_count2[3]++;next;}
           if($b_type == 3){$b_count3[3]++;next;}
           if($b_type == 22){$b_count4[3]++;next;}
           if($b_type == 7){$b_count5[3]++;next;}
           if($b_type == 8){$b_count6[3]++;next;}
           if($b_type == 9){$b_count7[3]++;next;}
           if($b_type == 6){$b_count8[3]++;next;}
           if($b_type == 17){$b_count9[3]++;next;}
           if($b_type == 11){$b_count10[3]++;next;}
           if($b_type == 2){$b_count11[3]++;next;}
           if($b_type == 37){$b_count12[3]++;next;}
           if($b_type == 39){$b_count13[3]++;next;}
           if($b_type == 38){$b_count14[3]++;next;}
        }
        if($b_level<=25&&$b_level>20)
        {
           if($b_type == 1){$b_count1[4]++;next;}
           if($b_type == 21){$b_count2[4]++;next;}
           if($b_type == 3){$b_count3[4]++;next;}
           if($b_type == 22){$b_count4[4]++;next;}
           if($b_type == 7){$b_count5[4]++;next;}
           if($b_type == 8){$b_count6[4]++;next;}
           if($b_type == 9){$b_count7[4]++;next;}
           if($b_type == 6){$b_count8[4]++;next;}
           if($b_type == 17){$b_count9[4]++;next;}
           if($b_type == 11){$b_count10[4]++;next;}
           if($b_type == 2){$b_count11[4]++;next;}
           if($b_type == 37){$b_count12[4]++;next;}
           if($b_type == 39){$b_count13[4]++;next;}
           if($b_type == 38){$b_count14[4]++;next;}
        }
        if($b_level<=30&&$b_level>25)
        {
           if($b_type == 1){$b_count1[5]++;next;}
           if($b_type == 21){$b_count2[5]++;next;}
           if($b_type == 3){$b_count3[5]++;next;}
           if($b_type == 22){$b_count4[5]++;next;}
           if($b_type == 7){$b_count5[5]++;next;}
           if($b_type == 8){$b_count6[5]++;next;}
           if($b_type == 9){$b_count7[5]++;next;}
           if($b_type == 6){$b_count8[5]++;next;}
           if($b_type == 17){$b_count9[5]++;next;}
           if($b_type == 11){$b_count10[5]++;next;}
           if($b_type == 2){$b_count11[5]++;next;}
           if($b_type == 37){$b_count12[5]++;next;}
           if($b_type == 39){$b_count13[5]++;next;}
           if($b_type == 38){$b_count14[5]++;next;} 
      } 
      if($b_level>30)
        {
           if($b_type == 1){$b_count1[6]++;next;}
           if($b_type == 21){$b_count2[6]++;next;}
           if($b_type == 3){$b_count3[6]++;next;}
           if($b_type == 22){$b_count4[6]++;next;}
           if($b_type == 7){$b_count5[6]++;next;}
           if($b_type == 8){$b_count6[6]++;next;}
           if($b_type == 9){$b_count7[6]++;next;}
           if($b_type == 6){$b_count8[6]++;next;}
           if($b_type == 17){$b_count9[6]++;next;}
           if($b_type == 11){$b_count10[6]++;next;}
           if($b_type == 2){$b_count11[6]++;next;}
           if($b_type == 37){$b_count12[6]++;next;}
           if($b_type == 39){$b_count13[6]++;next;}
           if($b_type == 38){$b_count14[6]++;next;} 
      } 
   }
 $sth->finish();
}

$gate_count=0;
@gate=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
foreach $key2( keys(%IsUser))
{
 $sql2 = sprintf("select data from gate where uid='$key2'");
 #print $sql2 . "\n";
 $sth = $dbh->prepare($sql2);
 if($DBI::errstr){print $sql2 . "\n";}
 $sth->execute();
 if($DBI::errstr){print $sql2 . "\n";}
 while (@row = $sth->fetchrow_array)
 {
        $data = $row[0];
        my $obj = decode_json($data);
        $gate_id = $obj->{id};
        $win = $obj->{w};
        if($win==0)
        {
          if($gate_id<=5){$gate[0]++;next;}
          if($gate_id<=10&&$gate_id>5){$gate[1]++;next;}
          if($gate_id<=15&&$gate_id>10){$gate[2]++;next;}
          if($gate_id<=20&&$gate_id>15){$gate[3]++;next;}
          if($gate_id<=25&&$gate_id>20){$gate[4]++;next;}
          if($gate_id<=30&&$gate_id>25){$gate[5]++;next;}
          if($gate_id<=35&&$gate_id>30){$gate[6]++;next;}
          if($gate_id<=40&&$gate_id>35){$gate[7]++;next;}
          if($gate_id<=45&&$gate_id>40){$gate[8]++;next;}
          if($gate_id<=50&&$gate_id>45){$gate[9]++;next;}
          if($gate_id<=55&&$gate_id>50){$gate[10]++;next;}
          if($gate_id<=60&&$gate_id>55){$gate[11]++;next;}
          if($gate_id<=65&&$gate_id>60){$gate[12]++;next;}
          if($gate_id<=70&&$gate_id>65){$gate[13]++;next;}
          if($gate_id<=75&&$gate_id>70){$gate[14]++;next;}
          if($gate_id<=80&&$gate_id>75){$gate[15]++;next;}
          if($gate_id>80){$gate[16]++;next;}
        }
 }
 $sth->finish();
}
for($i=0;$i<17;$i++)
{
  $gate_count += $gate[$i];
  #print "gate[$i] = $gate[$i]\n";
}
#print "gate_count = $gate_count\n";
#exit;

@quest_num=();
$quest_count=0;
for($i=0;$i<36;$i++)
{
  $quest_num[$i]=0;
}
foreach $key3( keys(%IsUser))
{
 $sql3 = sprintf("select data from quest where uid='$key3'");
 #print $sql2 . "\n";
 $sth = $dbh->prepare($sql3);
 if($DBI::errstr){print $sql3 . "\n";}
 $sth->execute();
 if($DBI::errstr){print $sql3 . "\n";}
   while (@row = $sth->fetchrow_array)
   {
        $data = $row[0];
        my $obj = decode_json($data);
        $quest_id = $obj->{id};
        $c_type = $obj->{c};
        if($c_type>0)
        {
         if($quest_id=='1060'){$quest_num[0]++;next;}
         if($quest_id=='2053'){$quest_num[1]++;next;}
         if($quest_id=='50004'){$quest_num[2]++;next;}
         if($quest_id=='2054'){$quest_num[3]++;next;}
         if($quest_id=='30003'){$quest_num[4]++;next;}
         if($quest_id=='51003'){$quest_num[5]++;next;}
         if($quest_id=='515'){$quest_num[6]++;next;}
         if($quest_id=='50005'){$quest_num[7]++;next;}
         if($quest_id=='1069'){$quest_num[8]++;next;}
         if($quest_id=='2001'){$quest_num[9]++;next;}
         if($quest_id=='1080'){$quest_num[10]++;next;}
         if($quest_id=='2055'){$quest_num[11]++;next;}
         if($quest_id=='30004'){$quest_num[12]++;next;}
         if($quest_id=='51004'){$quest_num[13]++;next;}
         if($quest_id=='1015'){$quest_num[14]++;next;}
         if($quest_id=='1025'){$quest_num[15]++;next;}
         if($quest_id=='41001'){$quest_num[16]++;next;}
         if($quest_id=='42001'){$quest_num[17]++;next;}
         if($quest_id=='2056'){$quest_num[18]++;next;}
         if($quest_id=='30005'){$quest_num[19]++;next;}
         if($quest_id=='51005'){$quest_num[20]++;next;}
         if($quest_id=='520'){$quest_num[21]++;next;}
         if($quest_id=='50006'){$quest_num[22]++;next;}
         if($quest_id=='2057'){$quest_num[23]++;next;}
         if($quest_id=='1070'){$quest_num[24]++;next;}
         if($quest_id=='1125'){$quest_num[25]++;next;}
         if($quest_id=='2058'){$quest_num[26]++;next;}
         if($quest_id=='1155'){$quest_num[27]++;next;}
         if($quest_id=='1215'){$quest_num[28]++;next;}
         if($quest_id=='2002'){$quest_num[29]++;next;}
         if($quest_id=='50007'){$quest_num[30]++;next;}
         if($quest_id=='80001'){$quest_num[31]++;next;}
         if($quest_id=='2059'){$quest_num[32]++;next;}
         if($quest_id=='42002'){$quest_num[33]++;next;}
         if($quest_id=='1195'){$quest_num[34]++;next;}
         if($quest_id=='2060'){$quest_num[35]++;next;}
        }
   }
 $sth->finish();
}

for($ii=0;$ii<31;$ii++)
{
  $quest_count += $quest_num[$ii];
  #print "$quest_num[$ii]\n";
}
#$quest=@quest_num;
#print "quest_count ===$quest_count\n";
#exit;

#print "$Date\n";
$myFile = sprintf(">%s/data/rmbuserpay/Compare2_%s.log",$monitor_path,$Date);
if(open(ROOKIE,$myFile))
{
  print ROOKIE $num."\|";
  for($i=0;$i<7;$i++)
  {
     if($i<6)
     { 
       print ROOKIE $level[$i]."\,"; 
     }
     else
     {
       print ROOKIE $level[$i];
     }
  }

  print ROOKIE "\|";

  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count1[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count2[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count3[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count4[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count5[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count6[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count7[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count8[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count9[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count10[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count11[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count12[$i]."\,";
  }
  for($i=0;$i<7;$i++)
  {
       print ROOKIE $b_count13[$i]."\,";
        
  }
  for($i=0;$i<7;$i++)
  {
       if($i<6)
       {
          print ROOKIE $b_count14[$i]."\,";
       } 
       else
       {
          print ROOKIE $b_count14[$i];
       }
  } 
  print ROOKIE "\|";
  print ROOKIE $gate_count."\|";
  for($i=0;$i<17;$i++)
  {
     if($i<16)
     {
       print ROOKIE $gate[$i]."\,";
     }
     else
     {
       print ROOKIE $gate[$i];
     }
  }
  print ROOKIE "\|";
  print ROOKIE "$quest_count";
  print ROOKIE "\|";
  for($i=0;$i<36;$i++)
  {
     if($i<35)
     {
       print ROOKIE $quest_num[$i]."\,";
     }
     else
     {
       print ROOKIE $quest_num[$i];
     }
  }
   
}
close(ROOKIE);

$test=0;
$myFile3=sprintf(">%s/data/rmbuserpay/Compare2_%s.log",$monitor_path,$Date0);
if(open(ROOKIE,$myFile3))
{
  print ROOKIE $test."\|";
  for($i=0;$i<7;$i++)
  {
     if($i<6)
     {
       print ROOKIE $test[$i]."\,";
     }
     else
     {
       print ROOKIE $test[$i];
     }
  }
  print ROOKIE "\|";

  for($i=0;$i<98;$i++)
  {
     if($i<97)
     {
       print ROOKIE $test."\,";
     }
     else
     {
       print ROOKIE $test;
     }
  }
  print ROOKIE "\|";
  print ROOKIE $test."\|";
  for($i=0;$i<36;$i++)
  {
     if($i<35)
     {
       print ROOKIE $test."\,";
     }
     else
     {
       print ROOKIE $test;
     }
  }
}

close(ROOKIE);
