#!/bin/bash

echo '-> Adding DNS Servers'
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
echo 'nameserver 8.8.4.4' >> /etc/resolv.conf

echo '-> Disabling IPv6'
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.conf
sysctl -p
# just in case
echo -e '#!/bin/bash\n# /etc/rc.local\n\n/etc/sysctl.d\n/etc/init.d/procps restart\n\nexit 0' >> /etc/rc.local

echo '-> Enabling password-based SSH for Ansible PRD host'
echo -e 'Match address 172.16.1.100\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config

echo '-> Getting some stuff done'
apt-get update
apt-get install -y sshpass
