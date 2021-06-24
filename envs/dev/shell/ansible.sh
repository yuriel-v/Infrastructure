# Installing Ansible on Ubuntu
echo "-> (ansible.sh) Installing Ansible"
apt-get install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

echo "-> (ansible.sh) Configuring password access from internal network"
echo -e 'Match address 172.16.0.0/16\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config

echo "-> (ansible.sh) Generating SSH key pair"
ansible localhost -m openssh_keypair -a "path=/home/vagrant/id_ansible" > /dev/null
