#!/usr/bin/bash
#
# VirSH start sequence script

# Autostart VMs
autostart=( vm001 vm002 vm005 vm007 vm014 )

# Priority 0: NFS server
printf "[$(date +"%Y-%m-%dT%H:%M:%S%:z")] Booting NFS server."
virsh start vm006 >/dev/null

while ! $(nc -z 172.16.0.6 2049); do
    printf "."
    sleep 15
done
printf " done. NFS server online.\n"

# Priority 1: DNS
printf "[$(date +"%Y-%m-%dT%H:%M:%S%:z")] Booting DNS server and Bastion proxy."
virsh start vm003 >/dev/null

while ! $(nc -z 172.16.0.30 53); do
    printf "."
    sleep 15
done
printf " done. DNS server online.\n"

# Priority 2: Autostart VMs
printf "[$(date +"%Y-%m-%dT%H:%M:%S%:z")] Booting other autostart VMs.\n"
for i in ${autostart[@]}; do
    virsh start $i >/dev/null
done
