#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
        Date=$1
else
        Date=`date -d "1 days ago" +%Y%m%d`
fi

date=`date +%s -d "$Date"`

cd /usr/local/script/sanguo_s14/
MYSQL="mysql -uroot -p1234 sgonline_s13 -h10.207.252.58"

$MYSQL -N -e "select viplevel,count(viplevel) from user where viplevel>0 group by viplevel order by viplevel" > /usr/local/monitor_sanguo_s14/data/rmbuserpay/vip_$Date.log 
