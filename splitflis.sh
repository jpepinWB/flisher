#!/bin/bash
filename=$1
splits=$2

echo -e "Analyzing input file $filename"
lines=$(wc -l < $1)
#lines=58482519
echo -e "Total lines: $lines"
i=1
echo -e "Splits: $splits"
while [ $i -lt $splits ]
do
	mid=$(($lines / $splits * $(($splits - $i)) + 1 ))
	n=0
	while IFS= read -r line
	do
		recordtype=$(cut -c 2 <<< "$line")
		if [ $recordtype -eq 1 ]
		then 
			echo -e "Breakpoint found at line $(($mid+$n)): $line"
			break
		else 
			n=$((n+1))
		fi
	done < <(tail -n +"$mid" $filename | head -n 20)

	echo -e "Splitting file ($i of $(($splits-1)))"
	prefix="a"
	split -l $(($mid+$n)) $filename $prefix$i
	path="efs/"
	a="aa"
	b="ab"
	c="ac"
	mv $prefix$i$a $path
	mv $prefix$i$b $path 
	filename=$path$prefix$i$a
	if [ $i -gt 1 ]
	then
		rm $path$prefix$(($i-1))$a
	fi
	((i++))
done
lastpiece="$prefix$(($i-1))$a"
mv $path$lastpiece $path$prefix$b
# for some reason an extra 62 byte "ac" split occurs during the final split.
cat $prefix$(($i-1))$c >> $path$prefix$b
rm $prefix$(($i-1))$c
