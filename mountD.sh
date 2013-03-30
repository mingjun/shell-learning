#!/bin/bash
ifs_bak=$IFS
export IFS=$'\n'

dev_type="ntfs"
dev_name="/dev/sda3"
label="Delta HD"

sudo mkdir -p /media/${label}
sudo mount -t $dev_type -o rw $dev_name /media/${label}

echo "done"

export IFS=$ifs_bak
