#!/bin/sh

raw=$1

curl -s "http://just-ping.com/index.php?vh=$raw&s=ping%21" | grep "^xmlreqGET" | egrep -o "[^,]+," | sed "s%xmlreqGET('%http://just-ping.com/%" | tr -d "'," | xargs -n 1 curl -w "\n" -s 


cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e "\." > $raw.ipv4.tmp
cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e ":" > $raw.ipv6.tmp

fping -a < $raw.ipv4.tmp > $raw.ipv4
fping6 -a < $raw.ipv6.tmp > $raw.ipv6

#rm $raw.ipv4.tmp $raw.ipv6.tmp

>$raw.ipv4.list
test -f $raw.ipv4 && cat $raw.ipv4 | while read line; do
	
	result=$(ping -c 3 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line
		echo $rrt $line >> $raw.ipv4.list
	fi

done

>$raw.ipv6.list
test -f $raw.ipv6 && cat $raw.ipv6 | while read line; do
	
	result=$(ping6 -c 3 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line
		echo $rrt $line >> $raw.ipv6.list
	fi

done

cat $raw.ipv4.list | sort -n | head -n 1
cat $raw.ipv6.list | sort -n | head -n 1

