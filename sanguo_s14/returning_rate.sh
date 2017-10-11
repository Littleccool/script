#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
cd /usr/local/monitor_sanguo_s14/data/newuser
if [ $# -eq 1 ]; then
	Date=$1
else
	Date=`date -d "1 days ago" +%Y%m%d`
fi

TempFile=./StatReturningTemp.txt
for i in `seq 14 -1 1`
do
	StatDate=`date -d "$i days ago $Date" +%Y%m%d`
	echo "StatDate $StatDate" >>/usr/local/script/sanguo_s14/log/return_rate.log
	RookieFile=/usr/local/monitor_sanguo_s14/data/newuser/user_$StatDate.txt
	if [ -f $RookieFile ]; then
		rm -f $TempFile
		stat_number=`expr $i - 1`
		for j in `seq $stat_number -1 0`
		do
			TempDate=`date -d "$j days ago $Date" +%Y%m%d`
			echo "TempDate $TempDate"  >> /usr/local/script/sanguo_s14/log/return_rate.log
			echo $StatDate >> /usr/local/script/sanguo_s14/log/return_rate.log
			FileName="/usr/local/monitor_sanguo_s14/data/DAU/data_$TempDate.log"
			if [ -f $FileName ]; then
				cat $FileName >> $TempFile
			fi
		done
		sort $TempFile | uniq > a.txt
		sort $RookieFile | uniq > b.txt
		rookie_count=`wc -l b.txt|cut -d" " -f1`
		returning_count=`sort a.txt b.txt|uniq -d|wc -l`
		
		echo "$i $StatDate $rookie_count $returning_count " >> /usr/local/script/sanguo_s14/log/return_rate.log
		if [ $i -eq 1 ];then
			sql="replace into table_returning_stat(date,all_rookie_count,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14) values('$StatDate',$rookie_count,$returning_count/$rookie_count,0,0,0,0,0,0,0,0,0,0,0,0,0)"
		else
			sql="update table_returning_stat set d$i=$returning_count/$rookie_count where date='$StatDate'"
		fi
		echo $sql >> /usr/local/script/sanguo_s14/log/return_rate.log
		echo $sql|/usr/bin/mysql -u root -h "10.142.17.30" -p1234 db_sanguo_stat_s14 >> /usr/local/script/sanguo_s14/log/return_rate.log 2>>/usr/local/script/sanguo_s14/log/return_rate_err.log
	fi
	
	
done

