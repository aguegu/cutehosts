curl -s "http://just-ping.com/index.php?vh=$1&c=&s=ping%21" | sed 's/.*\/\/<!\[CDATA\[ //' | sed 's/\/\/\]\]>.*//' | tr ";" "\n" | sed 's/ *xmlreqGET(./http:\/\/just-ping.com\//' | sed "s/',.*//" | grep "^http:\/\/just-ping.com" | while read line; do curl -m 10 -w "\n" -s $line 
done
