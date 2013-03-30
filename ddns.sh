#!/bin/bash
USER=some-user-name
PASS=some-password
DN=some-domain-name

# host `hostname` | awk '{print $NF}'
# nslookup -sil `hostname` | grep Address: | sed '1d' | sed 's/Address: //g'
# curl http://ip.cn/getip.php?action=getip | iconv -f GBK -t UTF8
IP=`ifconfig | awk '{if (match($0, /9(\.[0-9]+)+/)) print substr($0, RSTART, RLENGTH)}' | awk '{if(NR == 1) print}'`

echo http://$USER:$PASS@ddns.oray.com/ph/update?hostname=$DN\&myip=$IP
curl http://$USER:$PASS@ddns.oray.com/ph/update?hostname=$DN\&myip=$IP

echo " DONE!"


