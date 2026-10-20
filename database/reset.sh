#!/bin/sh
# Recrée la base de zéro en se connectant au port exposé par Docker.
set -e
cd "$(dirname "$0")"
NIVEAU=${1:-0}

# Comme PostgreSQL tourne dans Docker et expose le port 5432 sur votre machine :
export PGPASSWORD="${PGPASSWORD:-gargote}"
PSQL="psql -h localhost -U gargote -d gargote -q -v ON_ERROR_STOP=1"

# Supprime TOUTES les tables
$PSQL -c "DROP OWNED BY gargote;"

# Niveau 0
$PSQL -f 01_schema.sql -f 02_donnees.sql
echo "Niveau 0 chargé."

i=1
while [ "$i" -le "$NIVEAU" ]; do
  $PSQL -f "niveau${i}_schema.sql" -f "niveau${i}_donnees.sql"
  echo "Niveau $i chargé."
  i=$((i + 1))
done