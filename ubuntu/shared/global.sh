# Global Ubuntu configs script
echo "-> (global.sh) Refreshing apt-cache"
apt-get update

echo "-> (global.sh) Installing unzip"
apt-get install unzip

echo "-> (global.sh) Unzipping Ansible keys"
unzip /shared/global/id_ansible.zip -d /root/

echo "-> (global.sh) Copying Ansible key to authorized keys"
cat /root/id_ansible.pub >> /home/vagrant/.ssh/authorized_keys
chmod 0700 /root/id_ansible
