#!/bin/bash

svn_up(){
	svnpath="/data/release/htdocs_svn"
	for vfile in $1/*
	do
		if [ -f "$vfile" ]; then 
			while read _file
			do
				_svnfile=`echo $_file|awk '{print $2}'`
#				testz=`echo $_svnfile|grep "pairup\|sggame\|sgonline"`
				testz=`echo $_svnfile|grep "bayu"`
				testpath=`echo $_svnfile|cut -d"/" -f1`
				if [ $testpath == "htdocs" ];then
					_svnfile=`echo $_svnfile|awk -F"htdocs/" '{print $2}'`
				fi
				if [ ! -z "$testz" ];then
					echo $vfile, $_file, $_svnfile
					_svndir=`dirname $_svnfile`
					_svnroot=`echo $_svndir|cut -d"/" -f1`
					if [ -e "$svnpath/$_svnfile" ];then
						/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnfile"
						if [[ $?!=0 ]]; then
							/usr/bin/svn cleanup  --username dawx --password dawx1234 "$svnpath/$_svnroot"
							/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnfile"
						fi
					else
						if [ -d "$svnpath/$_svndir" ];then
							/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svndir"
							if [[ $?!=0 ]]; then
								/usr/bin/svn cleanup  --username dawx --password dawx1234 "$svnpath/$_svnroot"
								/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svndir"								
							fi
						else
							/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnroot"
							if [[ $?!=0 ]]; then
								/usr/bin/svn cleanup  --username dawx --password dawx1234 "$svnpath/$_svnroot"
								/usr/bin/svn up --username dawx --password dawx1234 "$svnpath/$_svnroot"
							fi
						fi
					fi
				fi
			done < $vfile	
			rm -f $vfile
		fi
	done
}

svn_up /usr/local/script/svn_up/data
