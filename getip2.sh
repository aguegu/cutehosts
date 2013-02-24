#!/bin/sh

host=${1:-"google.com"}

curl -s "http://just-ping.com/index.php?vh=$host&s=ping%21" | grep "^xmlreqGET" | egrep -o "[^,]+," | sed "s%xmlreqGET('%http://just-ping.com/%" | tr -d "'," | while read line; do 
	curl -m 10 -w "\n" -s $line &
done;
sleep 12
