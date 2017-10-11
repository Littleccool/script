#/bin/bash

PATH=/usr/bin:$PATH
cd /usr/local/script/sanguo_s4/monitor_login
./get_average_data.pl > /usr/local/monitor_sanguo_s4/data/login/average.txt
