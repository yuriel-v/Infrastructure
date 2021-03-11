# Installing Ansible on Ubuntu
echo "-> (ansible.sh) Installing Ansible"
apt-get install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

echo "-> (ansible.sh) Copying Ansible key to userspace"
cp /root/id_ansible /home/vagrant/
chmod 0700 /home/vagrant/id_ansible
chown vagrant:vagrant /home/vagrant/id_ansible
