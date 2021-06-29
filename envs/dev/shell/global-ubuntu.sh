#!/bin/bash
echo '-> Running global script'
echo -e '-> Please note that the apt related commands will be logged to /etc/vagrant-shell.log\n'

echo '-> Adding DNS Servers - Stage 1'
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

echo '-> Disabling IPv6'
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.conf
sysctl -p > /dev/null
# just in case
echo -e '#!/bin/bash\n# /etc/rc.local\n\n/etc/sysctl.d\n/etc/init.d/procps restart\n\nexit 0' >> /etc/rc.local

echo '-> Disabling password-based SSH access'
echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
echo 'PubKeyAuthentication yes' >> /etc/ssh/sshd_config

echo '-> Updating apt cache'
apt-get update >> /etc/vagrant-shell.log 2>&1

echo '-> Adding DNS Servers - Stage 2'
apt-get install -y resolvconf >> /etc/vagrant-shell.log 2>&1
systemctl enable resolvconf.service > /dev/null 2>&1
systemctl start resolvconf.service > /dev/null 2>&1

echo 'search yuriel.net' >> /etc/resolvconf/resolv.conf.d/head
echo -e 'nameserver 172.16.0.30\nnameserver 172.16.0.31\nnameserver 8.8.8.8\n' >> /etc/resolvconf/resolv.conf.d/head
resolvconf --enable-updates
resolvconf -u

echo '-> Upgrading packages'
apt-get upgrade -y >> /etc/vagrant-shell.log 2>&1

echo '-> Installing sshpass and links'
apt-get install -y sshpass >> /etc/vagrant-shell.log 2>&1
apt-get install -y links >> /etc/vagrant-shell.log 2>&1

service ssh restart
