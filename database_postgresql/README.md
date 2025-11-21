# PostgreSQL Database Setup

This folder contains PostgreSQL assets for the women's clothing platform:
- schema.sql: database schema (users, products, orders) and useful indexes
- seed.sql: sample admin/customer users and ~10 seed products
- start_postgres.sh: helper script to create the database and apply schema/seed using psql (reads .env)
- .env.example: environment variables to configure Postgres locally

Important: Existing MongoDB helper files remain untouched. These Postgres assets are added alongside them.

Requirements
- PostgreSQL 13+ installed and psql available on PATH
- A running PostgreSQL instance accessible with the credentials provided in your .env

Environment variables
Copy .env.example to .env and fill in values:

- POSTGRES_DB: Database name (e.g., shopdb)
- POSTGRES_USER: Database user (e.g., appuser)
- POSTGRES_PASSWORD: User password
- POSTGRES_HOST: Hostname (default: localhost)
- POSTGRES_PORT: Port (default: 5432)
- DATABASE_URL: Full Postgres URL used by the backend (format: postgres://USER:PASSWORD@HOST:PORT/DB)

Note: The backend service uses DATABASE_URL for connecting to Postgres.

Provisioning a Postgres database

1) Create .env
cp .env.example .env
# Edit .env to set your local credentials

2) Create database and run schema/seed via script
chmod +x start_postgres.sh
./start_postgres.sh

The script:
- Reads .env
- Creates the database if it does not exist
- Applies schema.sql
- Applies seed.sql

3) Manual commands (optional)
If you prefer to run commands manually using psql:

# Create DB (if needed)
psql "host=$POSTGRES_HOST port=$POSTGRES_PORT user=$POSTGRES_USER password=$POSTGRES_PASSWORD dbname=postgres sslmode=disable" -v ON_ERROR_STOP=1 -c "CREATE DATABASE \"$POSTGRES_DB\";"

# Apply schema
psql "host=$POSTGRES_HOST port=$POSTGRES_PORT user=$POSTGRES_USER password=$POSTGRES_PASSWORD dbname=$POSTGRES_DB sslmode=disable" -v ON_ERROR_STOP=1 -f schema.sql

# Apply seed
psql "host=$POSTGRES_HOST port=$POSTGRES_PORT user=$POSTGRES_USER password=$POSTGRES_PASSWORD dbname=$POSTGRES_DB sslmode=disable" -v ON_ERROR_STOP=1 -f seed.sql

Security notes
- The seed admin user uses a placeholder bcrypt hash for 'Admin123!'. For production, replace this with a secure hash created by your backend seeding mechanism or an admin creation flow.
- Do not commit real secrets to source control. Use .env for local development and managed secrets in deployment.

Troubleshooting
- psql: FATAL: database "..." does not exist
  - Run the create database command (script handles this)
- psql: could not connect to server
  - Ensure PostgreSQL is running and your host/port are correct
- Permission denied on creating extensions
  - You may need a superuser to enable extensions. The schema works without uuid-ossp; it is included as optional.
