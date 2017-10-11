#!/bin/bash
cd /usr/local/script/
if [ $# -eq 1 ];then
date=$1
else
date=`date -d"0 days ago" "+%Y%m%d"`
fi

./reportParse.pl  $date
mysql -uroot -p1234 stat -h10.135.72.229 -N -e"select appId from game_list" >gameList.txt

cat gameList.txt|while read line
do
appId=$line;
./key_data.pl $appId $date
./return_rate.pl $appId $date
./newuser_pay_stat.pl $appId $date
./userPayStat.pl $appId $date
./balanceDis.pl $appId
./chargeDistribute.pl $appId
done

