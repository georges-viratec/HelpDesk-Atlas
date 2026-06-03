sequenceDiagram
    autonumber
    participant User as Utilisateur (Client Web)
    participant GLPI as GLPI (VLAN 30)
    participant LDAP as LDAP Master (VLAN 20)
    participant Galera as Cluster Galera (VLAN 40)

    User->>GLPI: Saisie du login/mot de passe
    
    Note over GLPI, LDAP: Phase 1 : Authentification
    GLPI->>LDAP: "Est-ce que ce mot de passe est correct ?"
    LDAP-->>GLPI: "Oui, accès autorisé."
    
    Note over GLPI, Galera: Phase 2 : Autorisation & Données
    GLPI->>Galera: "Charge le profil, les droits et les tickets de cet utilisateur"
    Galera-->>GLPI: Renvoi des données SQL
    
    GLPI-->>User: Affichage du tableau de bord
