#!/bin/bash
# Script à lancer manuellement - ne jamais committer les secrets
# Variables d'environnement requises :
#   GLPI_DB_PASSWORD
#   KEYCLOAK_DB_PASSWORD
#   KEYCLOAK_ADMIN_PASSWORD
#   GITLAB_DB_PASSWORD
#   GRAFANA_ADMIN_PASSWORD

set -euo pipefail

: "${GLPI_DB_PASSWORD:?Variable GLPI_DB_PASSWORD non définie}"
: "${KEYCLOAK_DB_PASSWORD:?Variable KEYCLOAK_DB_PASSWORD non définie}"
: "${KEYCLOAK_ADMIN_PASSWORD:?Variable KEYCLOAK_ADMIN_PASSWORD non définie}"
: "${GITLAB_DB_PASSWORD:?Variable GITLAB_DB_PASSWORD non définie}"
: "${GRAFANA_ADMIN_PASSWORD:?Variable GRAFANA_ADMIN_PASSWORD non définie}"

kubectl create secret generic glpi-secret \
  --from-literal=mariadb-password="$GLPI_DB_PASSWORD" \
  -n glpi --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic keycloak-secret \
  --from-literal=admin-password="$KEYCLOAK_ADMIN_PASSWORD" \
  --from-literal=db-password="$KEYCLOAK_DB_PASSWORD" \
  -n keycloak --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic gitlab-secret \
  --from-literal=db-password="$GITLAB_DB_PASSWORD" \
  -n gitlab --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic grafana-secret \
  --from-literal=admin-password="$GRAFANA_ADMIN_PASSWORD" \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "Secrets appliqués avec succès."
