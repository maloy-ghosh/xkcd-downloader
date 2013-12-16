#!/bin/bash

DIR="$HOME/Desktop/"
cd $DIR
mkdir xkcd
cd xkcd

if [[ `ls | grep already` -ne "already" ]]; then
	#statements
	echo "No download history exists: Creating a history file "
	touch already
	echo "" >already
	echo "history file created as $DIR/xkcd/already"
fi


i=1
while [[ true ]]; do
	#statements
	echo "Checking whether http://xkcd.com/$i/ has already been downloaded"
	if [[ $i = 404 ]]; then
		#statements
		echo "http://xkcd.com/$i returns 404 error"
		i=`expr $i + 1`
		continue
	fi
	
	if [[ `cat already | awk '{print $1}' |sed -n "/\<$i\>/="` -eq "" ]]; then
		#statements
		echo "----------------------"
		echo "Not found in history"
		echo "----------------------"
		wget -q `echo "http://xkcd.com/$i/"` -O temp
		j=`sed -n '/div id="comic"/=' temp`
		if [[ "$j" -eq "" ]]; then
			#statements
			break
		fi
		j=`expr $j + 1`	
		k=`sed -n "$j p" temp | grep -o 'http://[a-z0-9A-Z.,-+_-(]*["]'`
		var=`echo $k | sed -n -e 's/http:\/\/imgs.xkcd.com\/comics\///p'| sed -n -e 's/"//p'`
		wget -q `echo $k|sed -n -e 's/"//p'`
		echo "------------------------------"
		echo "http:xkcd.com/$i/ downloaded"
		echo "------------------------------"
		echo "$i. 	$var" >> already
	else
		echo "Already downloaded"
		
		#echo ""
	fi
	disp=`cat already | awk '{print $1}' | sed -n "/\<$i\>/="`
	echo "The file exists at"
	echo "------------------------------------------------"
	find `pwd` -name `cat already | awk '{print $2}' | sed -n "$disp p"`
	echo "------------------------------------------------"
	#echo "already downloaded"
	#Show the path here
	i=`expr $i + 1` 
done

