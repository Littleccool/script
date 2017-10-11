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

$sql = sprintf("select level,uid from user where  unix_timestamp($Date)-register_time<=86400");
$dbh = $dbh_sg;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
@level=(0,0,0,0,0,0);
$num=0;
if($DBI::errstr){print $sql . "\n";}
while(@row = $sth->fetchrow_array)
{
        $uid=$row[1];
        $IsUser{$uid}=1;
        if($row[0]<=2)
        {
           $level[0]++;$num++;next;
        }
        if($row[0]==3||$row[0]==4)
        {
           $level[1]++;$num++;next;
        }
        if($row[0]==5||$row[0]==6)
        {
           $level[2]++;$num++;next;
        }
        if($row[0]==7||$row[0]==8)
        {
           $level[3]++;$num++;next;
        }
         if($row[0]==9||$row[0]==10)
        {
           $level[4]++;$num++;next;
        }
       else 
        {
           $level[5]++;$num++;next;
        }
 
}
$sth->finish();
#$s=0;
#for($i=0;$i<6;$i++)
#{
#   $s+=$level[$i];
#   print "$level[$i]\n";
#}
#print "$s=============$num\n";
#foreach $kk(keys(%IsUser))
#{
##  print "$kk\n";
#}
#exit;
$sqls = sprintf("select level,uid from user where unix_timestamp($Date)-register_time>86400 and unix_timestamp($Date)-register_time<=172800");
$dbh = $dbh_sg;
$sth = $dbh->prepare($sqls);
if($DBI::errstr){print $sqls . "\n";}
$sth->execute();
@levels=(0,0,0,0,0,0);
if($DBI::errstr){print $sqls . "\n";}
  while(@row = $sth->fetchrow_array)
  {
        if($row[0]<=2)
        {
           $levels[0]++;
        }
        if($row[0]==3||$row[0]==4)
        {
           $levels[1]++;
        }
        if($row[0]==5||$row[0]==6)
        {
           $levels[2]++;
        }
        if($row[0]==7||$row[0]==8)
        {
           $levels[3]++;
        }
         if($row[0]==9||$row[0]==10)
        {
           $levels[4]++;
        }
         if($row[0]>10)
        {
           $levels[5]++;
        }

        $uids=$row[1];
     $nums++;
       $IsKeyUid{$uids}=1;
  }
$sth->finish();
#print "\n$nums====$levels[0]==$levels[1]===\n";

@b_count1=();
@b_count2=(0,0,0,0,0);
@b_count3=(0,0,0,0,0);
@b_count4=(0,0,0,0,0);
@b_count5=(0,0,0,0,0);
@b_count6=(0,0,0,0,0);
@b_count7=(0,0,0,0,0);
@b_count8=(0,0,0,0,0);
@b_count9=(0,0,0,0,0);
@b_count10=(0,0,0,0,0);
@b_count11=(0,0,0,0,0);
@b_count12=(0,0,0,0,0);
@b_count13=(0,0,0,0,0);
@b_count14=(0,0,0,0,0);

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
        if($b_level <= 1)
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
        if($b_level == 2)
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
        if($b_level == 3) 
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
        if($b_level == 4)
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
        if($b_level == 5)
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
      if($b_level>5 && $b_level<=15)
      {
         for($i=6;$i<=15;$i++)
         {
           if($b_level == $i)
           {
             if($b_type == 1){$b_count1[$i-1]++;}
           }
         }
      } 
      if($b_level > 15)
      {
         if($b_type == 1){$b_count1[15]++;next; }
      } 
   }
 $sth->finish();
}
#$total=0;
#print "\n";
#for($i=0;$i<@b_count1;$i++)
#{
# $total+=$b_count1[$i];
# print "$b_count1[$i],";
#}
#print "\ntotal=$total\n";
#exit;

@b_count11=();
@b_count22=(0,0,0,0,0);
@b_count33=(0,0,0,0,0);
@b_count44=(0,0,0,0,0);
@b_count55=(0,0,0,0,0);
@b_count66=(0,0,0,0,0);
@b_count77=(0,0,0,0,0);
@b_count88=(0,0,0,0,0);
@b_count99=(0,0,0,0,0);
@b_count100=(0,0,0,0,0);
@b_count111=(0,0,0,0,0);
@b_count122=(0,0,0,0,0);
@b_count133=(0,0,0,0,0);
@b_count144=(0,0,0,0,0);
foreach $b_key(keys(%IsKeyUid))
{
 $sql22 = sprintf("select data from building where uid='$b_key' ");
 #print $sql2 . "\n";
 $sth = $dbh->prepare($sql22);
 if($DBI::errstr){print $sql22 . "\n";}
 $sth->execute();
 if($DBI::errstr){print $sql22 . "\n";}
   while (@row = $sth->fetchrow_array)
   {
        $data = $row[0];
        my $obj = decode_json($data);
        $b_type2 = $obj->{t};
        $b_level2 = $obj->{l};
        if($b_level2 <= 1)
        {
           if($b_type2 == 1){$b_count11[0]++;next; }
           if($b_type2 == 21){$b_count22[0]++;next;}
           if($b_type2 == 3){$b_count33[0]++;next;}
           if($b_type2 == 22){$b_count44[0]++;next;}
           if($b_type2 == 7){$b_count55[0]++;next;}
           if($b_type2 == 8){$b_count66[0]++;next;}
           if($b_type2 == 9){$b_count77[0]++;next;}
           if($b_type2 == 6){$b_count88[0]++;next;}
           if($b_type2 == 17){$b_count99[0]++;next;}
           if($b_type2 == 11){$b_count100[0]++;next;}
           if($b_type2 == 2){$b_count111[0]++;next;}
           if($b_type2 == 37){$b_count122[0]++;next;}
           if($b_type2 == 39){$b_count133[0]++;next;}
           if($b_type2 == 38){$b_count144[0]++;next;}
        }
        if($b_level2 == 2)
        {
           if($b_type2 == 1){$b_count11[1]++;next; }
           if($b_type2 == 21){$b_count22[1]++;next;}
           if($b_type2 == 3){$b_count33[1]++;next;}
           if($b_type2 == 22){$b_count44[1]++;next;}
           if($b_type2 == 7){$b_count55[1]++;next;}
           if($b_type2 == 8){$b_count66[1]++;next;}
           if($b_type2 == 9){$b_count77[1]++;next;}
           if($b_type2 == 6){$b_count88[1]++;next;}
           if($b_type2 == 17){$b_count99[1]++;next;}
           if($b_type2 == 11){$b_count100[1]++;next;}
           if($b_type2 == 2){$b_count111[1]++;next;}
           if($b_type2 == 37){$b_count122[1]++;next;}
           if($b_type2 == 39){$b_count133[1]++;next;}
           if($b_type2 == 38){$b_count144[1]++;next;}
        }
        if($b_level2 == 3)
        {
           if($b_type2 == 1){$b_count11[2]++;next; }
           if($b_type2 == 21){$b_count22[2]++;next;}
           if($b_type2 == 3){$b_count33[2]++;next;}
           if($b_type2 == 22){$b_count44[2]++;next;}
           if($b_type2 == 7){$b_count55[2]++;next;}
           if($b_type2 == 8){$b_count66[2]++;next;}
           if($b_type2 == 9){$b_count77[2]++;next;}
           if($b_type2 == 6){$b_count88[2]++;next;}
           if($b_type2 == 17){$b_count99[2]++;next;}
           if($b_type2 == 11){$b_count100[2]++;next;}
           if($b_type2 == 2){$b_count111[2]++;next;}
           if($b_type2 == 37){$b_count122[2]++;next;}
           if($b_type2 == 39){$b_count133[2]++;next;}
           if($b_type2 == 38){$b_count144[2]++;next;}
        }
        if($b_level2 == 4)
        {
           if($b_type2 == 1){$b_count11[3]++;next; }
           if($b_type2 == 21){$b_count22[3]++;next;}
           if($b_type2 == 3){$b_count33[3]++;next;}
           if($b_type2 == 22){$b_count44[3]++;next;}
           if($b_type2 == 7){$b_count55[3]++;next;}
           if($b_type2 == 8){$b_count66[3]++;next;}
           if($b_type2 == 9){$b_count77[3]++;next;}
           if($b_type2 == 6){$b_count88[3]++;next;}
           if($b_type2 == 17){$b_count99[3]++;next;}
           if($b_type2 == 11){$b_count100[3]++;next;}
           if($b_type2 == 2){$b_count111[3]++;next;}
           if($b_type2 == 37){$b_count122[3]++;next;}
           if($b_type2 == 39){$b_count133[3]++;next;}
           if($b_type2 == 38){$b_count144[3]++;next;}
        }
        if($b_level2 == 5)
        {
           if($b_type2 == 1){$b_count11[4]++;next; }
           if($b_type2 == 21){$b_count22[4]++;next;}
           if($b_type2 == 3){$b_count33[4]++;next;}
           if($b_type2 == 22){$b_count44[4]++;next;}
           if($b_type2 == 7){$b_count55[4]++;next;}
           if($b_type2 == 8){$b_count66[4]++;next;}
           if($b_type2 == 9){$b_count77[4]++;next;}
           if($b_type2 == 6){$b_count88[4]++;next;}
           if($b_type2 == 17){$b_count99[4]++;next;}
           if($b_type2 == 11){$b_count100[4]++;next;}
           if($b_type2 == 2){$b_count111[4]++;next;}
           if($b_type2 == 37){$b_count122[4]++;next;}
           if($b_type2 == 39){$b_count133[4]++;next;}
           if($b_type2 == 38){$b_count144[4]++;next;}
        }
      if($b_level2>5 && $b_level2<=15)
      {
         for($i=6;$i<=15;$i++)
         {
           if($b_level2 == $i)
           {
             if($b_type2 == 1){$b_count11[$i-1]++;}
           }
         }
      }
      if($b_level2 > 15)
      {
         if($b_type2 == 1){$b_count11[15]++;next; }
      } 

   }
 $sth->finish();
}

#$total=0;
#print "\n";
#for($i=0;$i<@b_count11;$i++)
#{
# $total+=$b_count11[$i];
# print "$b_count11[$i],";
#}
#print "\ntotal=$total\n";
#exit;

$gate_count=0;
@gate=(0,0,0,0,0,0,0,0,0,0,0,0,0);
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
          if(($gate_id<=3)&&($gate_id>1)){$gate[0]++;next;}
          if($gate_id==4){$gate[1]++;next;}
          if($gate_id<=6&&$gate_id>4){$gate[2]++;next;}
          if($gate_id==7){$gate[3]++;next;}
          if($gate_id==8){$gate[4]++;next;}
          if($gate_id<=11&&$gate_id>8){$gate[5]++;next;}
          if($gate_id<=16&&$gate_id>11){$gate[6]++;next;}
          if($gate_id<=21&&$gate_id>16){$gate[7]++;next;}
          if($gate_id<=26&&$gate_id>21){$gate[8]++;next;}
          if($gate_id<=31&&$gate_id>26){$gate[9]++;next;}
          if($gate_id<=36&&$gate_id>31){$gate[10]++;next;}
          if($gate_id<=41&&$gate_id>36){$gate[11]++;next;}
          if($gate_id>41){$gate[12]++;next;}
        }
 }
 $sth->finish();
}
for($i=0;$i<13;$i++)
{
  $gate_count += $gate[$i];
  #print "gate[$i] = $gate[$i]\n";
}
#print "gate_count = $gate_count\n";
#exit;
$gate_count2=0;
@gate2=(0,0,0,0,0,0,0,0,0,0,0,0,0);
foreach $gate_key( keys(%IsKeyUid))
{
 $sql2 = sprintf("select data from gate where uid='$gate_key'");
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
          if(($gate_id<=3)&&($gate_id>1)){$gate2[0]++;next;}
          if($gate_id==4){$gate2[1]++;next;}
          if($gate_id<=6&&$gate_id>4){$gate2[2]++;next;}
          if($gate_id==7){$gate2[3]++;next;}
          if($gate_id==8){$gate2[4]++;next;}
          if($gate_id<=11&&$gate_id>8){$gate2[5]++;next;}
          if($gate_id<=16&&$gate_id>11){$gate2[6]++;next;}
          if($gate_id<=21&&$gate_id>16){$gate2[7]++;next;}
          if($gate_id<=26&&$gate_id>21){$gate2[8]++;next;}
          if($gate_id<=31&&$gate_id>26){$gate2[9]++;next;}
          if($gate_id<=36&&$gate_id>31){$gate2[10]++;next;}
          if($gate_id<=41&&$gate_id>36){$gate2[11]++;next;}
          if($gate_id>41){$gate2[12]++;next;}
        }
 }
 $sth->finish();
}

for($i=0;$i<13;$i++)
{
  $gate_count2 += $gate2[$i];
  #print "gate2[$i] = $gate2[$i]\n";
}
#print "gate_count2 = $gate_count2\n";
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

@quest_num2=();
$quest_count2=0;
for($i=0;$i<36;$i++)
{
  $quest_num2[$i]=0;
}
foreach $quest_key(keys(%IsKeyUid))
{
 $sql3 = sprintf("select data from quest where uid='$quest_key'");
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
         if($quest_id=='1060'){$quest_num2[0]++;next;}
         if($quest_id=='2053'){$quest_num2[1]++;next;}
         if($quest_id=='50004'){$quest_num2[2]++;next;}
         if($quest_id=='2054'){$quest_num2[3]++;next;}
         if($quest_id=='30003'){$quest_num2[4]++;next;}
         if($quest_id=='51003'){$quest_num2[5]++;next;}
         if($quest_id=='515'){$quest_num2[6]++;next;}
         if($quest_id=='50005'){$quest_num2[7]++;next;}
         if($quest_id=='1069'){$quest_num2[8]++;next;}
         if($quest_id=='2001'){$quest_num2[9]++;next;}
         if($quest_id=='1080'){$quest_num2[10]++;next;}
         if($quest_id=='2055'){$quest_num2[11]++;next;}
         if($quest_id=='30004'){$quest_num2[12]++;next;}
         if($quest_id=='51004'){$quest_num2[13]++;next;}
         if($quest_id=='1015'){$quest_num2[14]++;next;}
         if($quest_id=='1025'){$quest_num2[15]++;next;}
         if($quest_id=='41001'){$quest_num2[16]++;next;}
         if($quest_id=='42001'){$quest_num2[17]++;next;}
         if($quest_id=='2056'){$quest_num2[18]++;next;}
         if($quest_id=='30005'){$quest_num2[19]++;next;}
         if($quest_id=='51005'){$quest_num2[20]++;next;}
         if($quest_id=='520'){$quest_num2[21]++;next;}
         if($quest_id=='50006'){$quest_num2[22]++;next;}
         if($quest_id=='2057'){$quest_num2[23]++;next;}
         if($quest_id=='1070'){$quest_num2[24]++;next;}
         if($quest_id=='1125'){$quest_num2[25]++;next;}
         if($quest_id=='2058'){$quest_num2[26]++;next;}
         if($quest_id=='1155'){$quest_num2[27]++;next;}
         if($quest_id=='1215'){$quest_num2[28]++;next;}
         if($quest_id=='2002'){$quest_num2[29]++;next;}
         if($quest_id=='50007'){$quest_num2[30]++;next;}
         if($quest_id=='80001'){$quest_num2[31]++;next;}
         if($quest_id=='2059'){$quest_num2[32]++;next;}
         if($quest_id=='42002'){$quest_num2[33]++;next;}
         if($quest_id=='1195'){$quest_num2[34]++;next;}
         if($quest_id=='2060'){$quest_num2[35]++;next;}
        }
   }
 $sth->finish();
}

for($ii=0;$ii<31;$ii++)
{
  $quest_count2 += $quest_num2[$ii];
#  print "$quest_num2[$ii]\n";
}

#$quest2=@quest_num2;
#print "quest_count2 ===$quest_count2\n";
#exit;

#print "$Date\n";
$myFile = sprintf(">%s/data/rmbuserpay/RookieCompare_%s.log",$monitor_path,$Date);
if(open(ROOKIE,$myFile))
{
  print ROOKIE $num."\|";
  for($i=0;$i<6;$i++)
  {
     if($i<5)
     { 
       print ROOKIE $level[$i]."\,"; 
     }
     else
     {
       print ROOKIE $level[$i];
     }
  }

  print ROOKIE "\|";

  for($i=0;$i<16;$i++)
  {
       print ROOKIE $b_count1[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count2[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count3[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count4[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count5[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count6[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count7[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count8[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count9[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count10[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count11[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count12[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count13[$i]."\,";
        
  }
  for($i=0;$i<5;$i++)
  {
       if($i<4)
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
  for($i=0;$i<13;$i++)
  {
     if($i<12)
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

#print "$Date\n";
$myFile2 = sprintf(">%s/data/rmbuserpay/RookieCompare2_%s.log",$monitor_path,$Date);
if(open(ROOKIE,$myFile2))
{
  print ROOKIE $nums."\|";
  for($i=0;$i<6;$i++)
  {
     if($i<5)
     {
       print ROOKIE $levels[$i]."\,";
     }
     else
     {
       print ROOKIE $levels[$i];
     }
  }

  print ROOKIE "\|";

  for($i=0;$i<16;$i++)
  {
       print ROOKIE $b_count11[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count22[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count33[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count44[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count55[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count66[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count77[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count88[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count99[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count100[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count111[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count122[$i]."\,";
  }
  for($i=0;$i<5;$i++)
  {
       print ROOKIE $b_count133[$i]."\,";

  }
  for($i=0;$i<5;$i++)
  {
       if($i<4)
       {
          print ROOKIE $b_count144[$i]."\,";
       }
       else
       {
          print ROOKIE $b_count144[$i];
       }
  }
  print ROOKIE "\|";
  print ROOKIE $gate_count2."\|";
  for($i=0;$i<13;$i++)
  {
     if($i<12)
     {
       print ROOKIE $gate2[$i]."\,";
     }
     else
     {
       print ROOKIE $gate2[$i];
     }
  }
  print ROOKIE "\|";
  print ROOKIE "$quest_count2";
  print ROOKIE "\|";
  for($i=0;$i<36;$i++)
  {
     if($i<35)
     {
       print ROOKIE $quest_num2[$i]."\,";
     }
     else
     {
       print ROOKIE $quest_num2[$i];
     }
  }

}
close(ROOKIE);


$test=0;
$myFile3=sprintf(">%s/data/rmbuserpay/RookieCompare_%s.log",$monitor_path,$Date0);
if(open(ROOKIE,$myFile3))
{
  print ROOKIE $test."\|";
  for($i=0;$i<6;$i++)
  {
     if($i<5)
     {
       print ROOKIE $test[$i]."\,";
     }
     else
     {
       print ROOKIE $test[$i];
     }
  }
  print ROOKIE "\|";

  for($i=0;$i<82;$i++)
  {
     if($i<81)
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


$myFile4=sprintf(">%s/data/rmbuserpay/RookieCompare2_%s.log",$monitor_path,$Date0);
if(open(ROOKIE,$myFile4))
{
  print ROOKIE $test."\|";
  for($i=0;$i<6;$i++)
  {
     if($i<5)
     {
       print ROOKIE $test."\,";
     }
     else
     {
       print ROOKIE $test[$i];
     }
  }
  print ROOKIE "\|";

  for($i=0;$i<82;$i++)
  {
     if($i<81)
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
