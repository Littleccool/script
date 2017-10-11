#!/bin/bash

PATH=$PATH:/usr/bin:/bin/
if [ $# -eq 1 ]; then
        DATE=$1
else
        DATE=`date -d "1 days ago" +%Y%m%d`
fi

RLTFILE=/usr/local/monitor_sanguo_s14/data/rmbuserpay/rmbshopitem2_${DATE}.log
RLTFILE2=/usr/local/monitor_sanguo_s14/data/rmbuserpay/rmbuserpay2_${DATE}.log

grep "type=SHOP_" /data/release/sgonline/s14/log/business/coins_${DATE}.log |  awk -F"," '{print $6,$7,$8}' | sed -e 's/cash=//g' -e 's/coins=//g' -e 's/type=//g' | awk -F":" '{print $1}' | awk '{a[$3] += $1;b[$3]+=$2} END {for(k in a) print k,a[k],b[k]}' > .tmp1.txt

UC=`grep "SHOP_" /data/release/sgonline/s14/log/business/coins_${DATE}.log | awk -F"," '{print $1}' | awk -F"[" '{print $3}' | sort -u | wc -l`
 
grep ",coins=-" /data/release/sgonline/s14/log/business/coins_${DATE}.log |sed -e 's/type=://g' |awk '/type=/' | awk -F"," '{print $6,$7,$8'} |sed -e 's/cash=//g' -e 's/coins=//g'  -e 's/type=//g' | awk -F":" '{print $1}' | awk -F"_" '{print $1}' | awk '{a[$3] += $1;b[$3]+=$2} END {for(k in a) print k,a[k],b[k]}' > .tmp2.txt

grep ",cash=-"  /data/release/sgonline/s14/log/business/coins_${DATE}.log |sed -e 's/type=://g' | awk '/type=/' | awk -F"," '{print $6,$7,$8'} |sed -e 's/cash=//g' -e 's/coins=//g' -e 's/type=//g' | awk -F":" '{print $1}' | awk -F"_" '{print $1}' | awk '{a[$3] += $1;b[$3]+=$2} END {for(k in a) print k,a[k],b[k]}' >> .tmp2.txt

#Total uid number
UC2=`cat /data/release/sgonline/s14/log/business/coins_${DATE}.log | awk -F"," '{print $1}' | awk -F"[" '{print $3}' | sort -u | wc -l`

echo -n "$DATE|$UC|" > $RLTFILE
echo -n "$DATE|$UC2|" > $RLTFILE2

cat .tmp1.txt | awk '{a+=$2;b+=$3} END {printf "%d,%d|",-a,-b}' >>  $RLTFILE
cat .tmp2.txt | awk '{a+=$2;b+=$3} END {printf "%d,%d|",-a,-b}' >>  $RLTFILE2

cat .tmp1.txt | awk '{a[$1]=$2;b[$1]=$3} END {for(k in a) printf "%s,",k;printf "|"; for(k in a) {printf "%d:%d,",a[k]*(-1),b[k]*(-1);}}' >> $RLTFILE
cat .tmp2.txt | awk '{a[$1]=$2;b[$1]=$3} END {for(k in a) printf "%s,",k;printf "|"; for(k in a) {printf "%d:%d,",a[k]*(-1),b[k]*(-1);}}' >> $RLTFILE2
