#!/bin/bash

fileList="/etc/owping/pies.txt"
ls "/var/log/owlogs/" > $fileList
while read line           
do
    cd /etc/owping/
    mkdir -p $line
    fileDate="/etc/owping/$line/outDate.txt"
    fileTime="/etc/owping/$line/outTime.txt"
    fileOpt="/etc/owping/$line/outOpt.txt"
    fileStat="/etc/owping/$line/lastupdated.txt"
    fileOut1="/etc/owping/$line/$line.js"
    fileOut2="/etc/owping/owcron"
    fileOut3="/etc/owping/$line/plot.log"
    fileFlag=1
    if [ -e "$fileOut2" ];then
	fileFlag=0
    else
	(umask 000 ; touch $fileOut3)
	echo "#!/bin/bash" > $fileOut3
	echo "#This script run every 5 seconds\n" >> $fileOut3
	chmod u+x $fileOut3
    fi
    if [ -e "$fileDate" ];then
	fileFlag=0
    else
	(umask 000 ; touch $fileDate)
	echo "~" > $fileDate
    fi
    if [ -e "$fileTime" ];then
	fileFlag=0
    else
      	(umask 000 ; touch $fileTime)
	echo "~" > $fileTime
    fi
    if [ -e "$fileOpt" ];then
	fileFlag=0
    else
	(umask 000 ; touch $fileOpt)
	echo j > $fileOpt
    fi
    if [ -e "$fileStat" ];then
	fileFlag=0
    else
	(umask 000 ; touch $fileStat)
    fi
    if [ -e "$fileOut1" ];then
	fileFlag=0
    else
	touch $fileOut1
	STR=$'while (sleep 5 && [ /tmp/.${line}_lastupdate -nt /etc/owping/$line/lastupdated.txt ] || ( /etc/owping/main.sh >> $fileOut3 ; touch /tmp/.${line}_lastupdate )) &\ndo\n\twait \$!\ndone\n'
	echo  $STR >> $fileOut2
    fi
    date=$(cat "$fileDate")
    time=$(cat "$fileTime")
    opt=$(cat "$fileOpt")
    echo "$(/bin/sh /etc/owping/owplot.sh $line -t $time -d $date -x $opt)"
    done<$fileList
rm $fileList
