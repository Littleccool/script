#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
	Date=$1
else
	Date=`date -d "1 days ago" +%Y%m%d`
fi

TempFile=./StatReturningTemp.txt
for i in `seq 30 -1 1`
do
	tmpDate=`date -d "$i days ago $Date" +%Y%m%d`
	echo $tmpDate
	#./pay_new.pl $tmpDate
	./pay_returning_rate.sh $tmpDate
	
	
done

