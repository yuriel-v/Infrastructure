#!/bin/bash

# 0: type; 1 onwards: extra vars
type=$2
extra_vars=$3
selfip=`hostname -I | grep -o "172\.16\.[0-9]*\.[0-9]*"`
network=0

if [ "$1" = "prd" ]; then
  network=1
fi

#selfid=`cat /etc/os-release | grep ID= | head -n 1 | grep -o "[^=]*$" | grep -o "[^\"]*"`

# actually fine to place these on git since password is only accepted among the internal network

echo '-> (self-ansible.sh) Starting global provisioning play'
# avoid host-checking issues
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@172.16.$network.100 "rm /home/vagrant/.ssh/known_hosts"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@172.16.$network.100 \
"ansible-playbook /home/vagrant/ansible/global.yml -v -i ${selfip}, --tags \"$type\" --extra-vars \"$extra_vars\""
