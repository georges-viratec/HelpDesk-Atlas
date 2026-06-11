# Ansible — Configuration Switches Atlas

## Topologie cible

```
Internet/WAN
     │
 pfSense HA (CARP)
     │  Trunk 802.1Q VLANs 10/20/30/40/50/60
     │
 Cisco Catalyst 3750 PoE-48  ◄──EtherChannel LACP──► HP ProCurve 2510-24 x2
 (Root Bridge STP)                                    (Secondary STP)
     │
 Proxmox PVE1/PVE2 + TrueNAS
```

## VLANs déployés

| VLAN | Nom           | Réseau          | Usage                        |
|------|---------------|-----------------|------------------------------|
| 10   | Management    | 10.10.10.0/24   | Hyperviseurs, switches, bastion |
| 20   | Core-Services | 10.10.20.0/24   | DNS, LDAP/AD, DHCP           |
| 30   | Applications  | 10.10.30.0/24   | Docker/GLPI, postes users    |
| 40   | Data-BDD      | 10.10.40.0/24   | Galera MariaDB               |
| 50   | Stockage-SAN  | 10.10.50.0/24   | iSCSI/NFS TrueNAS (L2 only)  |
| 60   | Corosync-HA   | 10.10.60.0/24   | Heartbeat Proxmox (L2 only)  |

## Prérequis

### Sur le bastion Ansible (10.10.10.100)
```bash
# Installer Ansible
pip install ansible

# Installer les collections réseau requises
ansible-galaxy collection install -r requirements.yml

# Vérifier la connectivité SSH vers les switches
ssh admin@10.10.10.251   # Cisco
ssh admin@10.10.10.252   # ProCurve
```

### Préparer les switches manuellement (bootstrap SSH)
Avant de lancer Ansible, configurer l'accès SSH minimal à la main :

**Cisco 3750 :**
```
enable
conf t
hostname sw-cisco-3750
ip domain-name atlas.local
crypto key generate rsa modulus 2048
ip ssh version 2
username admin privilege 15 secret VOTRE_MOT_DE_PASSE
line vty 0 15
 transport input ssh
 login local
interface vlan 10
 ip address 10.10.10.251 255.255.255.0
 no shutdown
ip default-gateway 10.10.10.254
end
write memory
```

**ProCurve 2510-24 :**
```
password manager
  [entrer le mot de passe]
vlan 10
  ip address 10.10.10.252 255.255.255.0
  exit
ip default-gateway 10.10.10.254
ip ssh
```

## Chiffrer les credentials avec Vault

```bash
# Éditer le vault
ansible-vault edit group_vars/vault.yml

# Ou chiffrer après édition
ansible-vault encrypt group_vars/vault.yml
```

## Utilisation

```bash
# Configuration complète de tous les switches
ansible-playbook -i inventory/hosts.yml playbooks/configure_switches.yml --ask-vault-pass

# Uniquement les VLANs
ansible-playbook ... --tags vlans

# Uniquement le durcissement sécurité
ansible-playbook ... --tags hardening,security

# Uniquement le Cisco
ansible-playbook ... --limit sw-cisco-3750

# Backup des configurations
ansible-playbook -i inventory/hosts.yml playbooks/backup_switches.yml --ask-vault-pass

# Dry-run (check mode)
ansible-playbook ... --check --diff
```

## Structure des fichiers

```
ansible-switches/
├── ansible.cfg
├── requirements.yml
├── inventory/
│   └── hosts.yml                    # Inventaire des switches
├── group_vars/
│   ├── switches.yml                 # Vars communes (VLANs, SNMP, NTP)
│   └── vault.yml                    # Credentials chiffrés (ansible-vault)
├── host_vars/
│   ├── sw-cisco-3750.yml            # Mapping ports Cisco
│   └── sw-procurve-1.yml            # Mapping ports ProCurve
├── roles/
│   ├── cisco_3750/
│   │   ├── tasks/main.yml           # VLANs, trunks, LACP, STP, SNMP...
│   │   └── handlers/main.yml        # write memory
│   └── procurve_2510/
│       ├── tasks/main.yml           # même chose pour ProCurve
│       └── handlers/main.yml        # write memory
└── playbooks/
    ├── configure_switches.yml       # Playbook principal
    └── backup_switches.yml          # Sauvegarde configs
```

## Points importants à adapter

1. **`host_vars/sw-cisco-3750.yml`** : vérifie les numéros d'interface (`GigabitEthernet1/0/X`)
   selon ton câblage réel — utilise `show interfaces status` pour lister.
2. **`host_vars/sw-procurve-1.yml`** : les ports ProCurve sont numérotés `1-24` + `25-26` (uplinks).
3. **IP des switches** : les IPs dans `inventory/hosts.yml` doivent être accessibles depuis le bastion Ansible.
4. **EtherChannel** : le Cisco est configuré en `mode active` (LACP). Le ProCurve doit être en mode `auto` ou `active` aussi — vérifier la compatibilité.

## Intégration Zabbix

Une fois les switches configurés, ajouter dans Zabbix :
- Template **`Template Net HP Enterprise Switch SNMPv2`** pour les ProCurve
- Template **`Template Net Cisco IOS SNMPv2`** pour le Catalyst
- Community : `atlas_ro` (tel que configuré dans group_vars)
