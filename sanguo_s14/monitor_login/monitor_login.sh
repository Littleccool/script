#!/bin/bash

PATH=/usr/bin:$PATH

Date=`date -d "1 days ago" +%Y%m%d`
echo $Date >>/usr/local/script/sanguo_s4/monitor_login/log/monitor_$Date.log
cd /usr/local/script/sanguo_s4/monitor_login/
/usr/local/script/sanguo_s4/monitor_login/self_log.pl $Date >>/usr/local/script/sanguo_s4/monitor_login/log/monitor_$Date.log &
ln -sf /usr/local/monitor_sanguo_s4/data/login/monitor_`date +%Y%m%d`.txt /usr/local/monitor_sanguo_s4/data/login/monitor.txt
touch /usr/local/monitor_sanguo_s4/data/login/monitor_$Date.txt
ln -sf /usr/local/monitor_sanguo_s4/web/login/login_`date +%Y%m%d`.htm /data/release/sgonline/s4/webroot/login.htm
/usr/local/script/sanguo_s4/monitor_login/get_data.pl >>/usr/local/script/sanguo/monitor_login_s4/log/monitor_$Date.log 2>>/usr/local/script/sanguo_s4/monitor_login/log/err_$Date.log &
