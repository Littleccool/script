#!/usr/bin/perl

$numbers=@ARGV;

use JSON;
use Data::Dumper;
my $json = new JSON;

$script_path="/usr/local/script/sanguo_s14";
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

use DBI;

require "/usr/local/script/sanguo_s14/set_db.pl";
$dbh_sanguo = &setDBSanguo();

$sql = sprintf("select count(*) from alliance");
#print $sql . "\n";
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $count = $row[0];
}
$sth->finish();

$sql = sprintf("select count(*) from alliance where create_time>(unix_timestamp(date(now()))-24*3600) and create_time<unix_timestamp(date(now()))");
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $newCount = $row[0];
}
$sth->finish();

@level=(0,0,0,0,0,0);
$sql = sprintf("select level from alliance");
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $le = $row[0];
        if($le == 1){$level[0]++;next;}
        if($le == 2){$level[1]++;next;}
        if($le == 3){$level[2]++;next;}
        if($le == 4){$level[3]++;next;}
        if($le == 5){$level[4]++;next;}
        if($le > 5){$level[5]++;next;}
}
$sth->finish();
#for($i=0;$i<@level;$i++)
#{
#    print $level[$i];
#    print "\n";
#}

$sql = sprintf("select count(*) from user where alliance_id>0 and accCharge>0");
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $fee = $row[0];
}
$sth->finish();

$sql = sprintf("select count(*) from user where alliance_id>0 and accCharge=0");
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $join = $row[0];
}
$sth->finish();

$sql = sprintf("select alliance_id,rank,member_count,level,point,extra_data from alliance where rank <= 5 and status=0 order by rank");
$dbh = $dbh_sanguo;
$sth = $dbh->prepare($sql);
if($DBI::errstr){print $sql . "\n";}
$sth->execute();
if($DBI::errstr){print $sql . "\n";}
while (@row = $sth->fetchrow_array)
{
        $alliance_id  = $row[0];
        $rank = $row[1];
        $member = $row[2];
        $a_level = $row[3];
        $point = $row[4];
        $data = $row[5];
        #print "$data\n"; 
        my $obj = decode_json($data);
        
        $re = $obj->{resource};
        $re = encode_json($re); 
        #print "$re\n";
        $obj2 = decode_json($re);
        $r1 = $obj2->{r1};
        $r2 = $obj2->{r2};
        $r3 = $obj2->{r3};
        $r4 = $obj2->{r4};
        $r5 = $obj2->{r5};
        #print "r1=$r1\n";  
         
        $IsAlliance{$alliance_id} = $rank;
        #print "$rank\n";
        $Ismb{$alliance_id} = $member;
        $IsLevel{$alliance_id} = $a_level;
        $IsPoint{$alliance_id} = $point;
        $IsR1{$alliance_id} = $r1;
        $IsR2{$alliance_id} = $r2;
        $IsR3{$alliance_id} = $r3;
        $IsR4{$alliance_id} = $r4;
        $IsR5{$alliance_id} = $r5;
}
$sth->finish();
#exit;
foreach $key(keys (%IsAlliance)){
       $sql = sprintf("select count(*) from user where alliance_id=$key and last_active_time>=unix_timestamp(date(now()))-24*3600 and last_active_time<unix_timestamp((date(now())))"); 
       #print $sql; 
       $dbh = $dbh_sanguo;
       $sth = $dbh->prepare($sql);
       if($DBI::errstr){print $sql . "\n";}
       $sth->execute();
       if($DBI::errstr){print $sql . "\n";}
       while (@row = $sth->fetchrow_array)
       {
          $online = $row[0];
          #print "$online\n";
          #exit;
          $IsOnline{$key} = $online; 
       }

}
$sth->finish();



$FileName = sprintf(">/usr/local/monitor_sanguo_s14/data/alliance/stat_alliance_%d.txt",$Date);
unless(open(TOPFILE, $FileName)) 
{
        print "can not open file " . $FileName . "!\n";
        exit -1;
}

$sTemp = sprintf("$Date|$count|$newCount|");
print TOPFILE $sTemp;

for($i=0;$i<@level;$i++)
{
    if($i<@level-1)
    {
       $sTemp = sprintf("$level[$i],");
       print TOPFILE $sTemp;
    }
    else{
           $sTemp = sprintf("$level[$i]|");
           print TOPFILE $sTemp;
        }
}

$sTemp = sprintf("$join|$fee|");
print TOPFILE $sTemp;

foreach $key(sort{$IsAlliance{$a} <=> $IsAlliance{$b} }keys(%IsAlliance)){
    #print "$IsAlliance{$key},$IsOnline{$key},$key\n";
    if($IsAlliance{$key}<=4){
      $sTemp = sprintf("$Ismb{$key},$IsOnline{$key},");
      print TOPFILE $sTemp;
      #print "$IsAlliance{$key},$IsOnline{$key},$key, $Ismb{$key}\n";
    }
    else{
        $sTemp = sprintf("$Ismb{$key},$IsOnline{$key}|");
        print TOPFILE $sTemp;
    }
    
}

foreach $key(sort{$IsAlliance{$a} <=> $IsAlliance{$b} }keys(%IsAlliance)){
    if($IsAlliance{$key}<=4){
      $sTemp = sprintf("$IsLevel{$key},$IsPoint{$key},");
      print TOPFILE $sTemp;
    }
    else{
        $sTemp = sprintf("$IsLevel{$key},$IsPoint{$key}|");
        print TOPFILE $sTemp;
    }

}

foreach $key(sort{$IsAlliance{$a} <=> $IsAlliance{$b} }keys(%IsAlliance)){
    if($IsAlliance{$key}<=4){
      $sTemp = sprintf("$IsR1{$key},$IsR2{$key},$IsR3{$key},$IsR4{$key},$IsR5{$key},");
      print TOPFILE $sTemp;
    }
    else{
        $sTemp = sprintf("$IsR1{$key},$IsR2{$key},$IsR3{$key},$IsR4{$key},$IsR5{$key}");
        print TOPFILE $sTemp;
    }

}

close(TOPFILE);

$dbh->disconnect();
