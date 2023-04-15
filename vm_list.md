# yurielnet: List of virtual machines

Notes to take:
- The VMs listed in the LAB environment should be connected to the DEV network. They're the "bleeding edge" DEV VMs.
- Global internal network: 172.16.0.0/16
- LAN Bridge network: 172.21.0.0/24

### Development environment (DEV): vm000 ~ vm199
- Network: 172.16.0.0/24
- vm000 (Template VM)
- vm001 (Ansible DEV)
- vm002 (Nexus)
- vm003 (LDAP DEV)
- vm004 (DNS-1 DEV)
- vm005 (Bastion DEV)
- vm006 (NFS DEV)
- vm007 (Minecraft-MedievalFabric)
- vm009 (Factorio-1)
- vm010 (Manjaro - Retired)
- vm011 (Satisfactory-Dedicated)
- vm012 (Light-backends - Retired)
- vm013 (DB1-MySQL - Retired)
- vm014 (Docker DEV)
- vm015 (MC-Valhelsia3)

---

### Production environment (PRD): vm200 ~ vm399
- Network: 172.16.1.0/24
- None yet!

---

### Laboratory environment (LAB): vm900 ~ vm999
- Network: 172.16.2.0/24
- vm999 (Test VM)