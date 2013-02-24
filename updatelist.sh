#!/bin/sh

#curl -s "http://just-ping.com/index.php?vh=google.com&c=&s=ping%21" | egrep -o "^xmlreqGET\('[^']+" | cut -d "&" -f 2,4,5 > list

curl -s "http://just-ping.com/index.php?vh=google.com&c=&s=ping%21" | egrep -o "^xmlreqGET\('[^']+"


