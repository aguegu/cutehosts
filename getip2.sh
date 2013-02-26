#!/bin/sh

raw=${1:-"google.com"}

>$raw

curl -s "http://just-ping.com/index.php?vh=$raw&s=ping%21" | egrep -o "^xmlreqGET\('[^']+" | sed "s%xmlreqGET('%http://just-ping.com/%" | while read line; do
	curl -m 10 -w "\n" -s $line &
done
#sleep 12
