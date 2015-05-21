#!/bin/bash

fileList="/etc/owping/pies.txt"
sourceDir="/var/log/owlogs/"
mkdir -m 777 -p $sourceDir
ls $sourceDir > $fileList
########Create Cron Job###############
fileOut1="/etc/owping/owcron"
if [ -e "$fileOut1" ];then
	fileFlag=0
else
    (umask 000 ; touch $fileOut1)
    echo "#!/bin/bash" > $fileOut1
    echo "#This script run every 5 seconds" >> $fileOut1
    chmod u+x $fileOut1
    echo $fileOut1 >> "/etc/rc.d/rc.local"
fi
##########Web Setup####################
webDir="/var/www/html/owplot/"
mkdir -p $webDir
link1="/var/www/html/owplot/owping"
link2="/var/www/html/owplot/js"
if [ ! -L $link1 ]; then
    ls -l "/etc/owping/" "owping"
fi
 
if [ ! -L $link2 ]; then
    ls -l "/usr/local/share/gnuplot/5.0/js/" "js"
fi
mkdir -p "/var/www/html/owplot/index.html"
#######################################

while read line           
do
    mkdir -p "/etc/owping/$line"
    fileDate="/etc/owping/$line/outDate.txt"
    fileTime="/etc/owping/$line/outTime.txt"
    fileOpt="/etc/owping/$line/outOpt.txt"
    fileStat="/etc/owping/$line/lastupdated.txt"
    fileOut2="/etc/owping/$line/$line.js"
    fileOut3="/etc/owping/$line/plot.log"
    fileOut4="/var/www/html/owplot/index.html/$line.php"
    if [ ! -e "$fileOut3" ];then
	(umask 000 ; touch $fileOut3)
    fi
    if [ ! -e "$fileDate" ];then
	(umask 000 ; touch $fileDate)
	echo "~" > $fileDate
    fi
    if [ ! -e "$fileTime" ];then
      	(umask 000 ; touch $fileTime)
	echo "~" > $fileTime
    fi
    if [ ! -e "$fileOpt" ];then
	(umask 000 ; touch $fileOpt)
	echo j > $fileOpt
    fi
    if [ ! -e "$fileStat" ];then
	(umask 000 ; touch $fileStat)
    fi
    if [ ! -e "$fileOut2" ];then
	touch $fileOut2
	echo "while (sleep 5 && [ /tmp/.${line}_lastupdate -nt /etc/owping/$line/lastupdated.txt ] || ( /etc/owping/main.sh >> $fileOut3 ; touch /tmp/.${line}_lastupdate )) &" >> $fileOut1
	echo "do" >> $fileOut1
	echo "wait \$!" >> $fileOut1
	echo "done" >> $fileOut1
    fi
    date=$(cat "$fileDate")
    time=$(cat "$fileTime")
    opt=$(cat "$fileOpt")
    echo "$(/bin/sh /etc/owping/owplot.sh $line -t $time -d $date -x $opt)"
    if [ ! -e "$fileOut4" ];then
	echo "$(/bin/sh /etc/owping/owhtml.sh $line)"
    fi
    done<$fileList
rm $fileList