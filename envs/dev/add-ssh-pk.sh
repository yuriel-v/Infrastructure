vm=$1

if [ -z "$vm" ]; then
    echo "Usage: $0 <vm-name>"
    echo "Adds the VM's private key file to this user's SSH config and copies it to ~/.ssh"
    echo "Note: Run this from the same dir as the Vagrantfile's!"
    exit 1
fi

if [ ! -d ".vagrant/machines/$vm/libvirt" ]; then
    echo "Warning: Directory '.vagrant/machines/$vm/libvirt' does not exist."
    echo "Make sure you're running this script from the Vagrantfile folder and try again."
    exit 1
fi

if [ ! -f ".vagrant/machines/$vm/libvirt/private_key" ]; then
    echo "Warning: Private key file for '$vm' does not exist."
    exit 1
fi

mkdir -p "$HOME/.ssh/vagrant_pks"
cp ".vagrant/machines/$vm/libvirt/private_key" "$HOME/.ssh/vagrant_pks/id_$vm"

if [ ! $? -eq 0 ]; then
    echo "Something went wrong with the copy."
    echo "Make sure you have read access to the file and try again."
else
    echo "Copy created at '$HOME/.ssh/vagrant_pks/id_$vm'."
fi
