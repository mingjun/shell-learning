#!/bin/bash

SITE_URL="http://bbs.nju.edu.cn/"
BORARD_NAME="History"
BORARD_URL=$SITE_URL"bbstdoc?board="$BORARD_NAME  #主题mode

TMP_FILE="/tmp/crawler.lily.tmp"
LIST_FILE='/tmp/doc.url.list'
DOC_FILE='/tmp/doc.all.txt'


DOC_NUM_INTERVAL=20
OLDEST_NUM=1 #can be change

#get the url latest board page
curl $BORARD_URL \
 | awk '/charset=gb2312/ {gsub(/gb2312/, "UTF-8")} {print}' \
 | iconv -f GB2312 -t UTF-8 -c | hxclean > $TMP_FILE
LATEST_NUM=$( cat $TMP_FILE | hxselect "hr+table td:first-child" | awk 'BEGIN {RS="</td>";FS="<td>"} END {print $2}' )


#loop to get previous board
for (( START_NUM=$(( $LATEST_NUM - $DOC_NUM_INTERVAL )); START_NUM > $OLDEST_NUM ; START_NUM-= $DOC_NUM_INTERVAL ))
do
    echo $BORARD_URL"&start="$START_NUM
    curl $BORARD_URL"&start="$START_NUM \
	| awk '/charset=gb2312/ {gsub(/gb2312/, "UTF-8")} {print}' \
	| iconv -f GBK -t UTF-8 -c | hxclean > $TMP_FILE

    cat $TMP_FILE | hxselect "hr+table td>a" \
	| awk 'BEGIN {RS="</a>";FS="<a.+=\"|\">"}; /board='$BORARD_NAME'/{printf "'$SITE_URL'%s\a%s\n", $2, $3}' \
	| tee -a $LIST_FILE
#-----------------------------------------------------------------------------------------------^ update seperater
   # wait for web server
    sleep 1
done

#sort and remove duplicate
list_temp=$LIST_FILE".sorted"
sort -k 1,1 -u $LIST_FILE > $list_temp
mv $list_temp $LIST_FILE


#download docs
cat $LIST_FILE |\
    while read line
do
DOWNLOAD_URL=$( echo $line | awk 'BEGIN {FS="\a"} {print $1}' )

    if [ -n "$DOWNLOAD_URL" ] # when URL is not blank
    then
	printf "<url>=%s\n\n\n" $DOWNLOAD_URL >> $DOC_FILE
# download one web doc to tmp file
	curl $DOWNLOAD_URL | awk '/charset=gb2312/ {gsub(/gb2312/, "UTF-8")} {print}' | iconv -f GBK -t UTF-8 -c > $TMP_FILE
# html -> text
	cat $TMP_FILE | hxclean | hxselect "textarea"  |  awk '!/※ .+:|发信站:/{print}' | html2text -utf8 >>  $DOC_FILE
# print end of one doc
	printf "\n\0\n" >> $DOC_FILE
	sleep 1.5
    fi
done
