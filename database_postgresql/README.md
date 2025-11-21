# Database (PostgreSQL) - Elegant Women Clothing

This container stores data for products, users, and orders.

Environment variables (example in .env.example):
- POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD
- Or POSTGRES_URL

Schema and seed:
- Use the backend scripts to apply schema and seed using env values:
  - From backend_express_js: node scripts/run_db_schema.js
  - From backend_express_js: node scripts/run_db_seed.js
- Ensure the backend .env points to this database (DATABASE_URL or PG* variables)
