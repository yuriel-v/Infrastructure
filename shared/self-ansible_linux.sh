#!/usr/bin/bash

# 0: type; 1 onwards: extra vars
type=$1
extra_vars=$2
selfip=`hostname -I | grep -o "172\.16\.[0-9]*\.[0-9]*"`
selfid=`cat /etc/os-release | grep ID= | head -n 1 | grep -o "[^=]*$" | grep -o "[^\"]*"`
ssh -i /root/id_ansible -o StrictHostKeyChecking=no vagrant@172.16.0.100 \
"ansible-playbook /shared/global/ansible/start.yml -i /shared/global/ansible/inv --limit \"$selfip,\" --tags \"$type\" --extra-vars \"$extra_vars\""
