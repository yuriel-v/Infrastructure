selfip=`ifconfig | sed -n '/eth1/,$p' | grep -o '10.0.0.[0-9]*' | head -n 1`
selfid=`cat /etc/os-release | grep ID= | head -n 1 | grep -o "[^=]*$" | grep -o "[^\"]*"`
ssh -i /root/id_ansible -o StrictHostKeyChecking=no vagrant@10.0.0.100 "ansible-playbook /shared/ubuntu/playbooks/dev.yml -i \"$selfip,\" --tags \"$selfid\""