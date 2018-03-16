#!/bin/bash
filename=$1
splits=$2

prefix="a"
a="aa"
b="ab"
c="ac"
path="efs/"

echo -e "Analyzing input file $filename"
lines=$(wc -l < $1)
echo -e "Total lines: $lines"

i=1
echo -e "Splits: $splits"
while [ $i -lt $splits ]
do
	#calculate approximate split point
	mid=$(($lines / $splits * $(($splits - $i)) + 1 ))
	n=0

	# find next identification record
	while IFS= read -r line
	do
		# read first two bytes
		recordtype=${line:1:1}
		if [ $recordtype -eq 1 ]
		then 
			echo -e "Breakpoint found at line $(($mid+$n)): $line"
			break
		else 
			n=$((n+1))
		fi
	done < <(tail -n +"$mid" $filename | head -n 20)

	echo -e "Splitting file ($i of $(($splits-1)))"
	split -l $(($mid+$n)) $filename $prefix$i

	# move splits over to efs storage so we don't consume disk
	mv $prefix$i$a $path
	mv $prefix$i$b $path

	# point next loop iteration to first half of split 
	filename=$path$prefix$i$a

	# delete previous input file (unless original) 
	if [ $i -gt 1 ]
	then
		rm $path$prefix$(($i-1))$a
	fi
	((i++))
done

# rename last piece accordingly
mv $path$prefix$(($i-1))$a $path$prefix$i$b

# for some reason an extra 62 byte "ac" split occurs during the final split.
cat $prefix$(($i-1))$c >> $path$prefix$i$b
rm $prefix$(($i-1))$c
