# 🏛️ Architecture Projet ATLAS

Voici le diagramme de flux illustrant notre Haute Disponibilité DNS (Failover) :

```mermaid
sequenceDiagram
    autonumber
    participant Client as Client (VLAN 30)
    participant DNS1 as DNS Primaire (10.10.20.53)
    participant DNS2 as DNS Secondaire (10.10.20.54)
    participant Google as DNS Google (8.8.8.8)

    Note over Client, DNS2: Cas 1 : Nominal (Requête locale)
    Client->>DNS1: Résolution de 'glpi.atlas.lan'
    DNS1-->>Client: Réponse : 10.10.30.80 (Cache/Zone)

    Note over Client, DNS2: Cas 3 : Panne du Primaire (Failover)
    Note over DNS1: HORS-LIGNE ❌
    Client->>DNS1: Échec de connexion (Timeout)
    Client->>DNS2: Basculement auto vers DNS 2
    DNS2-->>Client: Réponse : 10.10.30.80
