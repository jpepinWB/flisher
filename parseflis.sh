#!/bin/bash
# parse FLIS database
rowstart=$1
maxlines=$2
lines=0
#rm segment*
filename='efs/flisfoi.txt'

IFS=''
while read -r line
do
	lines=$((lines+1))
	recordtype=$(cut -c 2 <<< "$line")
	if [ $recordtype -eq 1 ]	# item identification data
	then
		NIIN=${line:6:9}
		echo $lines
		echo -e "$NIIN\t${line:2:4}\t${line:15:6}\t${line:21:5}\t${line:26:19}\t${line:45:1}\t${line:46:1}\t${line:47:1}\t${line:48:1}\t$(date -d "${line:49:4}-01-01 +${line:53:3} days -1 day" "+%Y%m%d")\t${line:56:1}\t${line:57:1}\t${line:58:1}\t${line:59:1}" >> segment_a.txt
	#elif [ $recordtype -eq 2 ]	# MOE rule data
	#then
	#	echo -e "$NIIN\t$recordtype"
	elif [ $recordtype -eq 3 ]	# reference number / CAGE data
	then
                echo -e "$NIIN\t${line:2:1}\t${line:3:1}\t${line:4:1}\t${line:5:1}\t${line:6:2}\t${line:8:1}\t${line:9:1}\t${line:10:5}\t${line:15:32}\t${line:47:2}\t${line:49:2}\t${line:51:5}" >> segment_c.txt
	#elif [ $recordtype -eq 4 ]	# item standardization data
	#then
        #        echo $NIIN $recordtype
	#elif [ $recordtype -eq 5 ] 	# management data
	#then
        #        echo $NIIN $recordtype
	elif [ $recordtype -eq 8 ]	# packaging data
	then
		if [ ${line:7:1} != " " ]
		then
			upweight="${line:7:4}.${line:11:1}"
		else
			upweight=""
		fi	
                if [ ${line:12:1} != " " ]
                then
                        upsizel="${line:12:3}.${line:15:1}"
			upsizew="${line:16:3}.${line:19:1}"
			upsizeh="${line:20:3}.${line:23:1}"
                else
                        upsize1=upsizew=upsizeh=""
                fi
                if [ ${line:24:1} != " " ]
                then
                        upcube="${line:24:4}.${line:28:3}"
                else
                        upcube=""
                fi
                if [ ${line:36:1} != " " ]
                then
                        unpkgweight="${line:36:4}.${line:40:1}"
                else
                        unpkgweight=""
                fi
                if [ ${line:41:1} != " " ]
                then
                        unpkgsizel="${line:41:3}.${line:44:1}"
                        unpkgsizew="${line:45:3}.${line:48:1}"
                        unpkgsizeh="${line:49:3}.${line:52:1}"
                else
                        unpkgsize1=unpkgsizew=unpkgsizeh=""
                fi
		#echo -e "${line:74}"

		echo -e "$NIIN\t${line:2:1}\t${line:3:1}\t${line:4:3}\t$upweight\t$upsizel\t$upsizew\t$upsizeh\t$upcube\t${line:31:4}\t${line:35:1}\t$unpkgweight\t$unpkgsizel\t$unpkgsizew\t$unpkgsizeh\t${line:53:2}\t${line:55:1}\t${line:56:2}\t${line:58:2}\t${line:60:2}\t${line:62:1}\t${line:63:2}\t${line:65:2}\t${line:67:1}\t${line:68:2}\t${line:70:1}\t${line:71:1}\t${line:72:1}\t${line:73:1}" >> segment_w.txt 
	#elif [ $recordtype -eq 9 ]	# freight data
	#then
        #        echo $NIIN $recordtype
	#else
        #        echo $NIIN $recordtype
	fi
	if [ $lines -eq $maxlines ]
	then
		break
	fi

done < <(tail -n +"$rowstart" "$filename" | head -n "$maxlines")

echo -e "Processed $maxlines lines"
