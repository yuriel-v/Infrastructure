#!/bin/bash
echo "-> Setting hostname: $1"
host=$1
hostnamectl set-hostname $host

echo "-> Setting .bashrc for Vagrant user: $2"
vm=$2

rm /home/vagrant/.bashrc
awk -vvm="$vm" '{if (NR == 60) printf "    PS1=\"\\[\\033[01;32m\\]\\u@\\h \\[\\033[01;36m\\](%s)\\[\\033[01;37m\\]: \\[\\033[01;34m\\]\\w \\[\\033[00m\\]\\$ \"\n", vm; else print $0}' /etc/skel/.bashrc \
 | awk -vvm="$vm" '{if (NR == 62) printf "    PS1=\"\\u@\\h (%s): \\w \\$ \"\n", vm; else print $0}' > /home/vagrant/.bashrc
