#!/bin/bash

export LC_CTYPE="en_US.UTF-8"

svn_up(){
	svnpath="/data/release/htdocs"
	for vfile in $1/*
	do
		if [ -f "$vfile" ]; then 
			id_succ=0
			_svndir_old=""
			while read _file
			do
				_svnfile=`echo "$_file"|awk '{print $2}'`
				testpath=`echo "$_svnfile"|cut -d"/" -f1`
				if [ $testpath == "htdocs" ];then
					_svnfile=`echo "$_svnfile"|awk -F"htdocs/" '{print $2}'`
				fi

				testz=`echo "$_svnfile"|cut -d"/" -f1|grep "bayu"`
				if [ ! -z "$testz" ];then
					echo $vfile, $_file, $_svnfile
					_svndir=`dirname "$_svnfile"`
					if [ "$_svndir_old" != "$_svndir" ];then
						_svnroot=`echo "$_svndir"|cut -d"/" -f1`
						if [ -d "$svnpath/$_svndir" ];then
							/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svndir"
							 if [ $? -ne 0 ]; then
							 	/usr/bin/svn cleanup  --username dawx --password dawx1234 "$svnpath/$_svnroot"
								if [ $? -ne 0 ]; then
									echo $?
									id_succ=1
									echo "fail cleanup $svnpath/$_svnroot" 
								else					
									echo $?
									echo "done cleanup $svnpath/$_svnroot" 
									/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svndir"
								fi
							 fi
						else
							/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnroot"
							if [ $? -ne 0 ]; then
								/usr/bin/svn cleanup  --username dawx --password dawx1234 "$svnpath/$_svnroot"
								if [ $? -ne 0 ]; then
									echo $?
									id_succ=1
									echo "fail cleanup $svnpath/$_svnroot" 
								else
									echo $?
									echo "done cleanup $svnpath/$_svnroot" 
									/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnroot"
								fi
							fi
						fi
						_svndir_old="$_svndir"
					else
						echo "$_svndir hasbeen updated"
					fi
				fi				
			done < $vfile	
			if [ $id_succ -eq 0 ];then
				rm -f $vfile
			fi
		fi
	done
}

testz=`ps aux|grep svn|grep -v grep|grep -v svnserve|grep -v svn_up|wc -l`
if [[ $testz -eq 0 ]];then
	echo "doing..."
	svn_up /usr/local/script/svn_up/data
fi
