#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
        DATE=$1
else
        DATE=`date -d "1 days ago" +%Y%m%d`
fi

RLTFILE=/usr/local/monitor_sanguo_s14/data/rmbuserpay/daygetCoins_${DATE}.log


cat /data/release/sgonline/s14/log/business/coins_${DATE}.log |grep -v ",coins=-" |grep -v "dailypayreward" |sed "s/]/|/g"|sed "s/\[/|/g"|sed "s/,/|/g"|sed "s/=/|/g" |awk -F\| '{print $6,$18}'|awk '{b[$1]+=$2} END{for(i in b) print i,b[i]}'|sort > $RLTFILE  

