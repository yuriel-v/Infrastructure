# Installing Ansible on Ubuntu
echo "-> (ansible.sh) Installing Ansible"
apt-get -qq install -y software-properties-common >> /etc/vagrant-shell.log 2>&1
apt-add-repository --yes --update ppa:ansible/ansible >> /etc/vagrant-shell.log 2>&1
apt-get -qq install -y ansible >> /etc/vagrant-shell.log 2>&1

echo "-> (ansible.sh) Configuring password access from internal network"
echo -e 'Match address 172.16.0.0/16\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config

echo "-> (ansible.sh) Generating SSH key pair"
ansible localhost -m openssh_keypair -a "path=/home/vagrant/id_ansible" >> /etc/vagrant-shell.log 2>&1

echo "-> (ansible.sh) Cloning Ansible artifacts from GitHub"
mkdir /home/vagrant/ansible
git clone https://github.com/yuriel-v/ansible.git /home/vagrant/ansible
