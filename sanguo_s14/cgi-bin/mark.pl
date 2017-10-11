#!/usr/bin/perl

#use   CGI   qw(:all); 
#use   strict; 

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime time;
my $Date=sprintf("%04d%02d%02d",$year+1900,$mon+1,$mday);
my $FileName = sprintf(">>/usr/local/script/sanguo_s14/log/red_%s.log",$Date);
unless(open(MYFILE, $FileName)) 
{
	print "can not open file" . $FileName . "!\n";
}
my $remote_ip = $ENV{"REMOTE_ADDR"};
my $sTemp = sprintf("%04d%02d%02d %02d:%02d:%02d| {%s}|%s\n",$year+1900,$mon+1,$mday,$hour,$min,$sec,$ENV{"QUERY_STRING"},$ENV{"REMOTE_ADDR"});
print MYFILE $sTemp;
close(MYFILE);
#my $target="http://rc.qzone.qq.com/myhome/29421"; 
#print   redirect(-uri=> $target); 
