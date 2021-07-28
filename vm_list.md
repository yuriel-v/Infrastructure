# yurielnet: List of virtual machines

Notes to take:
- The VMs listed in the LAB environment are connected to the DEV network. They're the "bleeding edge" DEV VMs.
- They'll also be in the DEV Vagrantfile.
- Global internal network: 172.16.0.0/16
- Global external network: 172.30.0.0/16

### Development environment (DEV): vm000 ~ vm199
- Internal network: 172.16.0.0/24
- External network: 172.30.0.0/24
- vm000 (Template VM)
- vm001 (Ansible DEV)
- vm002 (Terraria-1)
- vm003 (Minecraft-1 Vanilla)
- vm004 (NFS DEV)
- vm010 (Dev-Linux)
- vm100 (DNS-1 DEV)
- vm101 (DNS-2 DEV)

---

### Production environment (PRD): vm200 ~ vm399
- Internal network: 172.16.1.0/24
- External network: 172.30.1.0/24
- vm200 (Template VM PRD)
- vm201 (Ansible PRD)
- vm202 (LDAP PRD)
- vm203 (NFS PRD)
- vm204 (DNS-1 PRD)
- vm205 (DNS-2 PRD)
- vm206 (Terraform PRD)

---

### Laboratory environment (LAB): vm900 ~ vm999
- Internal network: 172.16.2.0/24
- External network: 172.30.2.0/24
- vm999 (Test VM)

---

### Internal IP tables: DEV Environment
- vm000: Null, could be anything
- vm001: 172.16.0.100/24
- vm002: 172.16.0.2/24; 172.30.0.2/24
- vm003: 172.16.0.3/24; 172.30.0.3/24
- vm004: 172.16.0.4/24
- vm005: 172.16.0.5/24; 172.30.0.4/24