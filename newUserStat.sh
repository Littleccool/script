#!/bin/bash
if [ $# -lt 1 ] ;then
endDate=20170818
else
endDate=$1
fi

beginDate=`date -d"1 days ago" "+%Y%m%d"`

rm ./data/npop/newuser* -f
for((i=100;i>=0;--i))
do

    date=`date -d"$beginDate $i days ago" "+%Y%m%d"`
    if [ $date -lt $endDate ] ;then
	continue;
    fi
#    ./newuser_pay_stat.pl 10000 $date
    ./newuser_pay_stat.pl 10001 $date
	sleep 3
	echo  $date . "\n";
done
