#!/bin/sh

raw=$1

cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e "\." > $raw.ipv4.tmp
cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e ":" > $raw.ipv6.tmp

fping -a < $raw.ipv4.tmp > $raw.ipv4
fping6 -a < $raw.ipv6.tmp > $eaw.ipv6

rm $raw.ipv4.tmp $raw.ipv6.tmp

>$raw.ipv4.list
cat $raw.ipv4 | while read line; do
	
	result=$(ping -c 3 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line
		echo $rrt $line >> $raw.ipv4.list
	fi

done

>$raw.ipv6.list
cat $raw.ipv6 | while read line; do
	
	result=$(ping6 -c 3 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line
		echo $rrt $line >> $raw.ipv6.list
	fi

done

cat $raw.ipv4.list | sort -n | head -n 1
cat $raw.ipv6.list | sort -n | head -n 1

