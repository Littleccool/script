#!/bin/bash

date=`date +"%Y%m%d" -d "0 days ago"`

mysql -uroot -p1234 -h10.142.17.30 -e "show global status" -N| grep -E "Bytes_received|Bytes_sent|Com_delete|Com_insert|Com_replace|Com_select|Com_update|Slow_queries"|sed -e 's/[[:space:]][[:space:]]*/,/g' > db.txt

received=`grep "Bytes_received," db.txt|awk -F, '{print $2}'`
sent=`grep "Bytes_sent," db.txt|awk -F, '{print $2}'`
delete=`grep "Com_delete," db.txt|awk -F, '{print $2}'` 
insert=`grep "Com_insert," db.txt|awk -F, '{print $2}'`
replace=`grep "Com_replace," db.txt|awk -F, '{print $2}'`
select=`grep "Com_select," db.txt|awk -F, '{print $2}'`
update=`grep "Com_update," db.txt|awk -F, '{print $2}'`
queries=`grep "Slow_queries," db.txt|awk -F, '{print $2}'`

MYSQL="/usr/bin/mysql -uroot -p1234 -h10.142.17.30 db_sanguo_stat_s14"

echo "replace into table_db_stat(date,Bytes_received,Bytes_sent,Com_delete,Com_insert,Com_replace,Com_select,Com_update,Slow_queries)values('$date',$received,$sent,$delete,$insert,$replace,$select,$update,$queries)" | $MYSQL
