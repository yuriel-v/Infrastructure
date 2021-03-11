# Global Ubuntu configs script
echo "-> (global.sh) Copying Ansible key to authorized keys"
cat /shared/global/id_ansible.pub >> /home/vagrant/.ssh/authorized_keys
cp /shared/global/id_ansible /root/
chmod 0700 /root/id_ansible

echo "-> (global.sh) Installing net-tools"
apt-get update
apt-get install -y net-tools
