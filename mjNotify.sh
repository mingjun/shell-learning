#!/bin/bash
APP_HOME=/home/mingjun/app/myApp

case $1 in  
start)
	# add code here
	java -jar $APP_HOME/DNS_Sync/dns.jar &
	java -jar $APP_HOME/Cervical_Spondylosis_Notifier.jar &
	;;  
stop)  
	echo "sorry stop not available.."
	;;
restart)  
	echo stopped
	
	echo started
	;;
*)  
	echo 'Usage:CMD start|stop|restart'
	;;
esac

exit 0