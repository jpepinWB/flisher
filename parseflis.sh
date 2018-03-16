#!/bin/bash
# parseflis.sh
#
# author: Erich Oelschlegel
#         oelschlegel@gmail.com
#
# description: parses DLA's FLIS data into separate text files
#              for easy MySQL import
#
# usage: ./parseflis.sh [options] filename
#  e.g.: ./parseflis.sh efs/flisfoi.txt
#        ./parseflis.sh -s 5000 efs/flisfoi.txt
#

if [ $# -eq 0 ]
then
	echo -e "No target file provided"
	exit 1
fi

lines=0
haveid=0

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--start)
    x=$2  # x = starting row
    lines=$x
    shift # past argument
    shift # past value
    ;;
    -n|--numlines)
    y=$2  # y = row count
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

filename=$1

while IFS= read -r line
do
	lines=$((lines+1))
	recordtype=${line:1:1}

	# check for item idenfication data
	if [[ $recordtype -eq 1 ]]
	then
		haveid=1
		NIIN=${line:6:9}
		echo $lines
		echo -e "$NIIN\t${line:2:4}\t${line:15:6}\t${line:21:5}\t${line:26:19}\t${line:45:1}\t${line:46:1}\t${line:47:1}\t${line:48:1}\t$(date -d "${line:49:4}-01-01 +${line:53:3} days -1 day" "+%Y%m%d")\t${line:56:1}\t${line:57:1}\t${line:58:1}\t${line:59:1}" >> segment_a.txt

	# check for MOE rule data
	#elif [ $recordtype -eq 2 ]
	#then
	#	echo -e "$NIIN\t$recordtype"

	# check for reference number / CAGE data
	elif [[ $recordtype -eq 3 && $haveid -eq 1 ]]
	then
		echo -e "$NIIN\t${line:2:1}\t${line:3:1}\t${line:4:1}\t${line:5:1}\t${line:6:2}\t${line:8:1}\t${line:9:1}\t${line:10:5}\t${line:15:32}\t${line:47:2}\t${line:49:2}\t${line:51:5}" >> segment_c.txt
	
	# check for item standardization data
	#elif [ $recordtype -eq 4 && $haveid -eq 1 ]
	#then
        #        echo $NIIN $recordtype

	# check for management data
	#elif [ $recordtype -eq 5 && $haveid -eq 1 ]
	#then
        #        echo $NIIN $recordtype

	# check for packaging data
	elif [[ $recordtype -eq 8 && $haveid -eq 1 ]]
	then
		if [[ ${line:7:1} != " " ]]
		then
			upweight="${line:7:4}.${line:11:1}"
		else
			upweight=""
		fi	
                if [[ ${line:12:1} != " " ]]
                then
                        upsizel="${line:12:3}.${line:15:1}"
			upsizew="${line:16:3}.${line:19:1}"
			upsizeh="${line:20:3}.${line:23:1}"
                else
                        upsize1=upsizew=upsizeh=""
                fi
                if [[ ${line:24:1} != " " ]]
                then
                        upcube="${line:24:4}.${line:28:3}"
                else
                        upcube=""
                fi
                if [[ ${line:36:1} != " " ]]
                then
                        unpkgweight="${line:36:4}.${line:40:1}"
                else
                        unpkgweight=""
                fi
                if [[ ${line:41:1} != " " ]]
                then
                        unpkgsizel="${line:41:3}.${line:44:1}"
                        unpkgsizew="${line:45:3}.${line:48:1}"
                        unpkgsizeh="${line:49:3}.${line:52:1}"
                else
                        unpkgsize1=unpkgsizew=unpkgsizeh=""
                fi
		#echo -e "${line:74}"

		echo -e "$NIIN\t${line:2:1}\t${line:3:1}\t${line:4:3}\t$upweight\t$upsizel\t$upsizew\t$upsizeh\t$upcube\t${line:31:4}\t${line:35:1}\t$unpkgweight\t$unpkgsizel\t$unpkgsizew\t$unpkgsizeh\t${line:53:2}\t${line:55:1}\t${line:56:2}\t${line:58:2}\t${line:60:2}\t${line:62:1}\t${line:63:2}\t${line:65:2}\t${line:67:1}\t${line:68:2}\t${line:70:1}\t${line:71:1}\t${line:72:1}\t${line:73:1}" >> segment_w.txt 

	# check for freight data
	#elif [[ $recordtype -eq 9 && $haveid -eq 0 ]]
	#then
        #        echo $NIIN $recordtype
	#else
        #        echo $NIIN $recordtype
	fi

done < <(
	if   [[ $x && $y ]];  then  tail -n +"$x" "$filename" | head -n "$y"
	elif [[ $x ]];        then  tail -n +"$x" "$filename"
	elif [[ $y ]];        then  head -n "$y" "$filename"
	else                        cat "$filename"
	fi
)

echo -e "Processed $lines lines"
