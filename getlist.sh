#!/bin/sh

for file in $(ls raw/*.html); do
	echo $file
	file=${file%.*}
	file=${file#*/}
	echo $file

	cat raw/$file.html | egrep "^ [[:alpha:]]" | cut -f 6 | grep "\." | sort | uniq > lists/$file
	cat raw/$file.html | egrep "^ [[:alpha:]]" | cut -f 6 | grep ":" | sort | uniq >> lists/$file

done
