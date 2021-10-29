# ansible.sh: Ansible install script + Auto-provision Flask API activation
# Yes, I realize this script has next to no error handling. I'll add some later.
# Maybe.

# Figure out which OS we're dealing with
cur_os=`cat /etc/os-release | grep -o "^ID=.*" | grep -o "[^=]*$" | grep -o "[^\"]*"`

# Installing Ansible on Ubuntu
echo '==> (ansible.sh) Installing Ansible'
if [ "$cur_os" = "ubuntu" ]; then
    printf 'Updating apt-cache and upgrading... '
    apt-get update > /dev/null 2>&1
    apt-get upgrade > /dev/null 2>&1
    printf 'done.\n'

    printf 'Adding Ansible repo to apt... '
    apt-get -qq install -y software-properties-common >> /etc/vagrant-shell.log 2>&1
    apt-add-repository --yes --update ppa:ansible/ansible >> /etc/vagrant-shell.log 2>&1
    printf 'done.\n'

    printf 'Installing Ansible... '
    apt-get -qq install -y ansible >> /etc/vagrant-shell.log 2>&1
    printf 'done.\n'
elif [ "$cur_os" = "centos" ]; then
    printf 'Updating with DNF... '
    dnf update -y > /dev/null 2>&1
    printf 'done.\n'

    printf 'Enabling epel-release... '
    dnf install -y epel-release > /dev/null 2>&1
    printf 'done.\n'

    printf 'Installing Ansible... '
    dnf install -y ansible > /dev/null 2>&1
    printf 'done.\n'
else
    echo 'ERROR: This script only installs Ansible on Ubuntu or CentOS! Exiting...'
    exit 1
fi


#echo '==> (ansible.sh) Configuring password access from internal network'
#echo -e '\nPasswordAuthentication no\n\nMatch address 172.16.0.0/16\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config
#echo -e '\nMatch address 127.*.*.*\n    PasswordAuthentication yes' >> /etc/ssh/sshd_config
#systemctl restart ssh


printf '==> (ansible.sh) Disabling strict host key checking for internal networks... '
#has172=$(cat /etc/ssh/ssh_config | grep -c 'Match host 172\.16\.\*\.\*')
#has192=$(cat /etc/ssh/ssh_config | grep -c 'Match host 192\.168\.0\.\*')

if ! grep -q 'Match host 172\.16\.\*\.\*' /etc/ssh/ssh_config; then
    echo -e '\nMatch host 172.16.*.*\n    StrictHostKeyChecking no\n' >> /etc/ssh/ssh_config
fi

if ! grep -q 'Match host 192\.168\.0\.\*' /etc/ssh/ssh_config; then
    echo -e '\nMatch host 192.168.0.*\n    StrictHostKeyChecking no' >> /etc/ssh/ssh_config
fi
printf 'done.\n'

printf '==> (ansible.sh) Generating SSH key pair... '
if [ ! -d "/home/vagrant/.ssh" ]; then
    mkdir /home/vagrant/.ssh
    chmod 0755 /home/vagrant/.ssh
    chown vagrant:vagrant /home/vagrant/.ssh
fi

if [ ! -d "/home/vagrant/.ssh/ansible" ]; then
    mkdir /home/vagrant/.ssh/ansible
    chown vagrant:vagrant /home/vagrant/.ssh/ansible
fi


ansible localhost -m openssh_keypair -a "path=/home/vagrant/.ssh/ansible/id_ansible" >> /etc/vagrant-shell.log 2>&1
chown vagrant:vagrant /home/vagrant/.ssh/ansible/id_ansible
chown vagrant:vagrant /home/vagrant/.ssh/ansible/id_ansible.pub
printf 'done.\n'

printf '==> (ansible.sh) Cloning Ansible artifacts from GitHub... '
mkdir /home/vagrant/ansible
git clone https://github.com/yuriel-v/ansible.git /home/vagrant/ansible > /dev/null 2>&1
chown -R vagrant:vagrant /home/vagrant/ansible
printf 'done.\n'

printf '==> (ansible.sh) Adding port 4960 to firewall-cmd... '
firewall-cmd --permanent --add-port=4960/tcp > /dev/null 2>&1
firewall-cmd --reload > /dev/null 2>&1
systemctl restart firewalld > /dev/null 2>&1  # just in case
printf 'done.\n'

echo '==> (ansible.sh) Setting up autoprovisioner listener'
printf 'Making sure Python 3.9 is installed... '
dnf install -y python3.9 > /dev/null 2>&1
printf 'done.\n'

printf 'Creating autop-listener venv and installing flask... '
python3.9 -m venv --upgrade-deps /home/vagrant/autop-listener > /dev/null 2>&1
/home/vagrant/autop-listener/bin/python3.9 -m pip install flask > /dev/null 2>&1
printf 'done.\n'

printf 'Adding auto-provisioner to systemd... '
cat /home/vagrant/ansible/autop-listener/autoprovision.service > /etc/systemd/system/autoprovision.service
systemctl daemon-reload > /dev/null 2>&1
systemctl enable --now autoprovision > /dev/null 2>&1
printf 'done.\n'

printf '==> (ansible.sh) Checking if Ansible and the autoprovisioner are OK.'
ansible --version > /dev/null 2>&1
ansible_res=$?

curl --silent --output /dev/null -s http://172.16.0.100:4960/getkey 2>&1
autop_res=$?

if [ $ansible_res -eq 0 ]; then
    echo '- Ansible: OK'
else
    echo '- Ansible: FAIL'
fi

if [ $autop_res -eq 0 ]; then
    echo '- Autoprovisioner: OK'
else
    echo '- Autoprovisioner: FAIL'
fi

