#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
        Date=$1
else
        Date=`date -d "1 days ago" +%Y%m%d`
fi

cd /data/release/sgonline/s14/log/business 
res=`cat exectime_$Date.log|
awk -F\| '{
   a[$4]+=$7;b[$4]++;
   if(($6+0) == 0){ok[$4]++;}
   if(($7+0) > max[$4]){ max[$4]=$7;}
   }END {
   for (i in max){
      printf("{\"name\":\"'%s'\",\"count\":'%d',\"average\":'%.4f'},",i,b[i],a[i]/b[i]);
   }  
 }'`
res=`echo "["$res"]"`
data=`echo $res|sed 's/},]/}]/g'`
echo $data
sql="replace into table_cgi_stat(date,data)values($Date,'$data')"
echo $sql|/usr/bin/mysql -u root -h "10.142.17.30" -p1234 db_sanguo_stat_s14
