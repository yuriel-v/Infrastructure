type=$1
selfip=`hostname -I | grep "172\.16\.[0-9]*\.[0-9]*"`
selfid=`cat /etc/os-release | grep ID= | head -n 1 | grep -o "[^=]*$" | grep -o "[^\"]*"`
ssh -i /root/id_ansible -o StrictHostKeyChecking=no vagrant@172.16.0.100 \
"ansible-playbook /shared/global/ansible/start.yml -i inv --limit \"$selfip,\" --tags \"$type\""
