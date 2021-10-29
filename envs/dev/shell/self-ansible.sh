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
#      - dns-server
# <extra-vars>: Any extra variables to pass for the Ansible
#               role called by the type above. Must be passed
#               as a single string, between single or double
#               quotes!
#
# -> Mandatory extra vars include:
#    - global_vm_shortname: The machine's description, as it
#                           should appear on the terminal
#                           prompt in blue;
#    - global_vm_hostname: The machine's computer name, as
#                          it should be shown on the terminal
#                          prompt as user@name.
#
# Example valid call:
# (...)/self-ansible.sh dev general "global_vm_shortname='Test VM' global_vm_hostname='vm123'"

type=$2
extra_vars=${3//\'/\"}
network=0

if [ "$1" = "prd" ]; then
  network=1
fi

selfip=`ip a | grep 'inet.*' | grep '.*scope global' | grep -v 'dynamic' | grep -o "172\.16\.$network\.[0-9]*" | grep -v "172\.16\.$network\.255" | tail -n 1`
id_ansible=`curl -s http://172.16.0.100:4960/getkey | grep -o "ssh-rsa[^\"]*"`

# ok to change to vagrant user from this point on
su vagrant

mkdir -p -m755 "/home/vagrant/.ssh"
if ! grep -q "$id_ansible" /home/vagrant/.ssh/authorized_keys 2>/dev/null; then
  echo '-> (self-ansible.sh) Adding Ansible public key to authorized keys'
  echo $id_ansible >> /home/vagrant/.ssh/authorized_keys
fi
chmod 0600 /home/vagrant/.ssh/authorized_keys

echo '-> (self-ansible.sh) Starting global provisioning play'
echo '  -> The logs will not be shown here, but are available in the Ansible host.'
response=$(curl -X POST http://172.16.0.100:4960/provision -H "Content-Type: application/json" -d "{\"type\": \"$type\", \"ip\": \"$selfip\", \"extras\": $extra_vars}" 2>&1)

if [ ! $? -eq 0 ]; then
    echo "$response"
    echo "The command failed. See above for details."
else
    echo "Ansible has been fired successfully."
fi
