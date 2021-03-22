#!/bin/bash

ztip=`hostname -I | grep -o 172\.20\.[0-9]*\.[0-9]*`

while [[ -z $ztip ]]
do
  sleep 1
  ztip=`hostname -I | grep -o 172\.20\.[0-9]*\.[0-9]*`
done

sudo echo "$ztip" > /etc/server-ip.txt
