#!/bin/bash
#
# self-ansible.sh: Self-provisioning Ansible script
# Author: Leonardo "yuriel-v" Valim
#
# This script calls up the Ansible controller through SSH
# The Ansible controller MUST be reachable on the address
# 172.16.0.100 (development) OR 172.16.1.100 (production)
#
# Arguments are POSITIONAL!
# Syntax: <env> <type> <extra-vars>
#
# <env>: The machine's environment. Treats 'prd' as
#        production and everything else as development.
# <type>: The machine's type. Can be one of the following:
#      - general
#      - template-vm
#      - dev-master
#      - game-server
#      - dns (to be implemented!)
# <extra-vars>: Any extra variables to pass for the Ansible
#               role called by the type above. Must be passed
#               as a single string, between single or double
#               quotes!
#
# -> Mandatory extra vars include:
#    - global_vm_shortname: The machine's short name, as it
#                           should appear on the terminal
#                           prompt in blue;
#    - global_vm_hostname: The machine's computer name, as
#                          it should be shown on the terminal
#                          prompt as user@name.
#
# Example valid call:
# (...)/self-ansible.sh dev general "global_vm_shortname='Test VM' global_vm_hostname='vm123'"

type=$2
extra_vars=$3
selfip=`hostname -I | grep -o "172\.16\.[0-9]*\.[0-9]*"`
network=0

if [ "$1" = "prd" ]; then
  network=1
fi

# actually fine to place these on git since password is only accepted among the internal network

echo '-> (self-ansible.sh) Fetching and adding Ansible public key to authorized keys'
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@172.16.$network.100 \
"cat /home/vagrant/id_ansible.pub" | grep -o "^ssh-rsa.*" >> /home/vagrant/.ssh/authorized_keys

echo '-> (self-ansible.sh) Starting global provisioning play'
# avoid host-checking issues
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@172.16.$network.100 "rm /home/vagrant/.ssh/known_hosts"
sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@172.16.$network.100 \
"ansible-playbook /home/vagrant/ansible/global.yml -i ${selfip}, --tags \"$type\" --extra-vars \"$extra_vars\""
