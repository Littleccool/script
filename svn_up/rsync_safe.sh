#!/bin/bash
PATH=$PATH:/usr/bin:/bin
ts=`date -u`

testz=`ps aux | grep rsyncd.conf | grep -v grep `
if [ -z "$testz" ]
then
    cd /usr/local/script/svn_up
        rm /var/run/rsyncd.pid -rf  #some cases the process is died,but the pid file still exist
    /usr/bin/rsync --daemon --no-detach --config=/etc/rsyncd.conf &
    echo "start rsyncd success!"
    echo "$ts rsyncd restart !">>rsync_safe.log
fi
