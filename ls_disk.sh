#!/bin/bash

# hello there !!!

alias sudo="${1}"

mounted=$(mount | grep /dev/sd | cut -f 1 -d ' ')

for dev_name in $(ls /dev/sd??); #查找分区（但不包括硬盘设备，如/dev/sda,/dev/sdb）
do
	dev_type=$(mount --guess-fstype ${dev_name}) 
	dev_info="$dev_name - (${dev_type})"

	if [ -n "$(echo $mounted | grep ${dev_name})" ]; then
		echo $dev_info $'\t' {mounted}
		continue
	fi;

	case "$dev_type" in
	ntfs)
		label=$(sudo ntfslabel ${dev_name})
		;;
	ext?)
		label="*unknown*"		
		;;
	*)
		label="*unknown*"
		;;
	esac

	echo $dev_info $'\t' [$label]
done;


