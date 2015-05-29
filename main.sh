#!/bin/bash

fileList="/etc/owping/pies.txt"
sourceDir="/var/log/owlogs/"
lastOne=""
mkdir -m 777 -p $sourceDir
ls $sourceDir > $fileList
######################################
fileStat="/etc/owping/lastupdated.txt"
if [ ! -e "$fileStat" ];then
    (umask 000 ; touch $fileStat)
fi
######################################
filetk="/etc/owping/tk.txt"
if [ ! -e "$filetk" ];then
    (umask 000 ; touch $filetk)
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
#########################################
while read line           
do
    mkdir -p "/etc/owping/$line"
    fileDate="/etc/owping/$line/outDate.txt"
    fileTime="/etc/owping/$line/outTime.txt"
    fileOpt="/etc/owping/$line/outOpt.txt"
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
    if [ ! -e "$fileOut2" ];then
	touch $fileOut2
    fi
    if [ ! -e "$fileOut4" ];then
	/bin/sh /etc/owping/owhtml.sh $line
    fi
    lastOne=$line
    done<$fileList
rm $fileList
echo $lastOne > $filetk
