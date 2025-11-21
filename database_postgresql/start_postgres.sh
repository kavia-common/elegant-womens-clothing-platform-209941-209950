#!/usr/bin/env bash
set -euo pipefail

# This script provisions a PostgreSQL database and applies schema.sql and seed.sql non-interactively.
# It reads configuration from .env located in the same directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "${SCRIPT_DIR}/.env" ]; then
  # shellcheck disable=SC2046
  export $(grep -v '^#' "${SCRIPT_DIR}/.env" | xargs -0 -I {} sh -c 'printf "%s\n" "{}"' 2>/dev/null | xargs)
else
  echo "Warning: .env not found. Falling back to environment variables in shell."
fi

# Defaults
POSTGRES_HOST="${POSTGRES_HOST:-localhost}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-}"
POSTGRES_DB="${POSTGRES_DB:-shopdb}"

# Build a psql connection string
BASE_CONN="host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} dbname=postgres sslmode=disable"
TARGET_CONN="host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} dbname=${POSTGRES_DB} sslmode=disable"

echo "==> Using PostgreSQL at ${POSTGRES_HOST}:${POSTGRES_PORT} as ${POSTGRES_USER}"
echo "==> Target database: ${POSTGRES_DB}"

# Export PGPASSWORD for non-interactive authentication if provided
if [ -n "${POSTGRES_PASSWORD}" ]; then
  export PGPASSWORD="${POSTGRES_PASSWORD}"
fi

# Create database if it doesn't exist
echo "==> Ensuring database exists..."
psql "${BASE_CONN}" -v ON_ERROR_STOP=1 -tc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_DB}'" | grep -q 1 || \
  psql "${BASE_CONN}" -v ON_ERROR_STOP=1 -c "CREATE DATABASE \"${POSTGRES_DB}\";"

# Apply schema
if [ -f "${SCRIPT_DIR}/schema.sql" ]; then
  echo "==> Applying schema.sql..."
  psql "${TARGET_CONN}" -v ON_ERROR_STOP=1 -f "${SCRIPT_DIR}/schema.sql"
else
  echo "!! schema.sql not found in ${SCRIPT_DIR}"
  exit 1
fi

# Apply seed
if [ -f "${SCRIPT_DIR}/seed.sql" ]; then
  echo "==> Applying seed.sql..."
  psql "${TARGET_CONN}" -v ON_ERROR_STOP=1 -f "${SCRIPT_DIR}/seed.sql"
else
  echo "-- seed.sql not found; skipping seed"
fi

# Print DATABASE_URL hint
if [ -z "${DATABASE_URL:-}" ]; then
  # Create an example DATABASE_URL
  ENCODED_USER="${POSTGRES_USER}"
  ENCODED_PASS="${POSTGRES_PASSWORD}"
  export DATABASE_URL="postgres://${ENCODED_USER}:${ENCODED_PASS}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
fi

echo "==> Done."
echo "DATABASE_URL=${DATABASE_URL}"
