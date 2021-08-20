# Yurielnet: Yuriel's infrastructure network

Hi folks, it's a me. This here yurielnet is my personal project for a miniature infrastructure for hosting whatever it is that I feel like hosting.

In order to do this, I've employed infrastructure as code to take note of which virtual machines are which, as well as a few shell scripts to trigger self-provisioning.

With that being said, let's get into the plans' phases.

## Phase 1: VMs and their categories

The most basic version of this infrastructure has 4 virtual machines, with 1 to 2 templates.
- vm001: Ansible DEV
- vm002 Nexus
- vm003: LDAP DEV (master DNS for now)
- vm004: DNS-1 DEV (slave instance)

The templates are as follows.
- t1_dev: Ubuntu template (Ubuntu 20.04 LTS, Focal Fossa)
- t2_dev: CentOS template (to be implemented)

The categories:
- Core machines
  - vm001 (Ansible)
  - vm002 (Nexus)
- DNS/LDAP machines
  - vm003 (LDAP/master DNS)
  - vm004 (slave DNS)

Future plans will include the following categories:
- Game server machines
- NFS machines
- Web system machines
- Some other stuff that I can't remember anymore, but basically whatever else I need

## Phase 2: Network layout

The following will only refer to the DEV network. PRD network will be implemented much later.

- All VMs will initially only have this network plugged in.
- If a machine needs comms into another network (for instance, Nexus into PRD network), the adapter will be added when the network is available.

That being said, the details are as follows. Please note that the machines themselves will only have the host part of the IP, as the network is already defined at the top.
- Network: 172.16.0.0/24
- vm001: 100
- vm002: 200
- vm003: 30
- vm004: 31

Machines outside the virtual infrastructure:
- ESXi: 101
- Beta (my main computer): 77
- Templates and (if on Vagrant) first interface of any VM: DHCP

Do note that, due to Vagrant setting the first interface to DHCP, it should be removed shortly after provisioning to avoid the following cases:
- The virtual machine is a DEV VM and it's consuming 2 IPs from the network when it only needs 1;
- The virtual machine is a PRD/HOM VM and it has a connection to the DEV network when it shouldn't have;
- The virtual machine needs a static IP into the DEV network (ex. Ansible, DNS).

This list is not exhaustive, and there might be more cases where the machine's first interface is not needed. \
Rule of thumb: if the machine **needs** a static IP into the DEV network or shouldn't have a connection to it at all, remove the first interface.

## Phase 3: The template

The templates for Linux are pretty straightforward. I myself prefer Ubuntu due to its larger community and support, but my homologation/production systems might benefit more from CentOS after all.

- Initially, two templates are thought of:
  - Ubuntu for DEV
  - CentOS for HOM/PRD

Requirements for any template:
- Essential packages, such as:
  - gcc, g++, make
  - tar, zip, unzip
  - iptables, ufw, sshpass
  - tmux, links
- Yurielnet customizations, like the ascii art motd and the custom shell prompt
- Default editor set to vim
- Up-to-date packages
- Disabled IPv6 (we don't use that here)
- Disabled password-based SSH access (except for the Ansible VM which should listen to)

If using Vagrant:
- Main user `vagrant` with sudo password prompt disabled and password set to `vagrant`
- Vagrant insecure SSH key inserted

## Phase 4: VM specifics
-> Nexus
  - XRDP **or** VNC
    - If RDP, add `dconf-editor` and `gnome-tweak-tool`
  - Remmina
  - VSCode
  - Java/Maven
  - Insomnia
  - Vagrant
  - GitKraken
  - Visuals, namely Gnome Desktop (`ubuntu_desktop_minimal`)

-> XRDP on Nexus
  - Install XRDP
  - Add user `xrdp` to `ssl-cert` group

## Phase ???: Author

Once again, it's a me: [Leonardo "Yuriel" Valim](mailto:emberbec@gmail.com).
