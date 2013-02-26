#!/bin/sh

raw=${1:-"google.com"}

#>$raw

#curl -s "http://just-ping.com/index.php?vh=$raw&s=ping%21" | egrep -o "^xmlreqGET\('[^']+" | sed "s%xmlreqGET('%http://just-ping.com/%" | while read line; do 
#	curl -m 10 -w "\n" -s $line >> $raw &
#done;
#sleep 12

#cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e "\." | fping -a > $raw.ipv4
#cat $raw | cut -d ";" -f 5 | sort -n | uniq | grep -e ":" | fping6 -a > $raw.ipv6

cat lists/$raw | sort -n | uniq | egrep "\." | fping -a > $raw.ipv4
cat lists/$raw | sort -n | uniq | egrep ":" | fping6 -a > $raw.ipv6


>$raw.ipv4.list
test -f $raw.ipv4 && cat $raw.ipv4 | while read line; do
	
	result=$(ping -c 8 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line | tee -a $raw.ipv4.list
	fi

done

>$raw.ipv6.list
test -f $raw.ipv6 && cat $raw.ipv6 | while read line; do
	
	result=$(ping6 -c 8 -W 1 $line)

	if [ $? -eq 0 ]; then
		rrt=$(echo $result  | sed "s%/%\n%g" | tail -n 2 | head -n 1)
		echo $rrt $line | tee -a $raw.ipv6.list
	fi

done

echo "quickest server for $raw:"
cat $raw.ipv4.list | sort -n | head -n 1 | tee $raw.choice.tmp
cat $raw.ipv6.list | sort -n | head -n 1 | tee -a $raw.choice.tmp

echo "records:"
>$raw.choice
cat $raw.choice.tmp | cut -d " " -f 2 | while read lines; do
	printf "address=/%s/%s\n" $raw $lines | tee -a $raw.choice
done

#rm $raw
rm $raw.ipv4 $raw.ipv6
rm $raw.ipv4.list $raw.ipv6.list
rm $raw.choice.tmp
