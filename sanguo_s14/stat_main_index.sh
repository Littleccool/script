#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
        Date=$1
else
        Date=`date -d "1 days ago" +%Y%m%d`
fi

cd /usr/local/script/sanguo_s14/

/usr/local/script/sanguo_s14/stat_main_index.pl $Date >> /usr/local/script/sanguo_s14/log/stat_main_index.log
/usr/local/script/sanguo_s14/stat_fight_count.pl
/usr/local/script/sanguo_s14/cgi-bin/get_tutorial_stage_web.pl $Date
/usr/local/script/sanguo_s14/cgi-bin/lose_user_stat.pl $Date
/usr/local/script/sanguo_s14/cgi-bin/get_top_op.pl $Date
/usr/local/script/sanguo_s14/stat_rmb_pay_tools.pl $Date
/usr/local/script/sanguo_s14/stat_all_pay_tools.pl $Date 
/usr/local/script/sanguo_s14/stat_pay_by_day_all.pl $Date
/usr/local/script/sanguo_s14/stat_pay_top_user.pl $Date

ln -sf /usr/local/stat_s14/web/user_action/top_op_$Date.htm /data/release/sgonline/s14/webroot/top_op.htm
ln -sf /usr/local/monitor_sanguo_s14/data/sanguo/user_data_$Date.txt /data/release/sgonline/s14/webroot/data/rank_top10
ln -sf /usr/local/stat_s14/web/user_action/tutorial_stage_$Date.htm /data/release/sgonline/s14/webroot/tutorial_stage.htm
ln -sf /usr/local/stat_s14/web/lose_stat/lose_stat_$Date.htm /data/release/sgonline/s14/webroot/lose_stat.htm
