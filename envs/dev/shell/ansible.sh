# Installing Ansible on Ubuntu
echo "-> (ansible.sh) Installing Ansible"
apt-get update > /dev/null 2>&1
apt-get upgrade > /dev/null 2>&1

apt-get -qq install -y software-properties-common >> /etc/vagrant-shell.log 2>&1
apt-add-repository --yes --update ppa:ansible/ansible >> /etc/vagrant-shell.log 2>&1
apt-get -qq install -y ansible >> /etc/vagrant-shell.log 2>&1


echo "-> (ansible.sh) Configuring password access from internal network"
echo -e '\nPasswordAuthentication no\n\nMatch address 172.16.0.0/16\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config
echo -e '\nMatch address 127.*.*.*\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config
systemctl restart ssh


echo "-> (ansible.sh) Disabling strict host key checking for internal networks"
has172=$(cat /etc/ssh/ssh_config | grep -c 'Match host 172\.16\.\*\.\*')
has192=$(cat /etc/ssh/ssh_config | grep -c 'Match host 192\.168\.0\.\*')

if [ $has172 -eq 0 ]; then
    echo -e '\nMatch host 172.16.*.*\n    StrictHostKeyChecking no\n' >> /etc/ssh/ssh_config
fi

if [ $has192 -eq 0 ]; then
    echo -e '\nMatch host 192.168.0.*\n    StrictHostKeyChecking no' >> /etc/ssh/ssh_config
fi


echo "-> (ansible.sh) Generating SSH key pair"
if [ ! -d "/home/vagrant/.ssh" ]; then
    mkdir /home/vagrant/.ssh
    chown vagrant:vagrant /home/vagrant/.ssh
fi

if [ ! -d "/home/vagrant/.ssh/ansible" ]; then
    mkdir /home/vagrant/.ssh/ansible
    chown vagrant:vagrant /home/vagrant/.ssh/ansible
fi


ansible localhost -m openssh_keypair -a "path=/home/vagrant/.ssh/ansible/id_ansible" >> /etc/vagrant-shell.log 2>&1
chown vagrant:vagrant /home/vagrant/.ssh/ansible/id_ansible
chown vagrant:vagrant /home/vagrant/.ssh/ansible/id_ansible.pub


echo "-> (ansible.sh) Cloning Ansible artifacts from GitHub"
mkdir /home/vagrant/ansible
git clone https://github.com/yuriel-v/ansible.git /home/vagrant/ansible
chown -R vagrant:vagrant /home/vagrant/ansible
