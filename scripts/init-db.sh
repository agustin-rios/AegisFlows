#!/usr/bin/env bash
set -Eeuo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printf "${GREEN}[init-db]${NC} Initializing database: ${POSTGRES_DB}\n"

# Create extensions that Keycloak benefits from
psql --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<'SQL'
-- UUID extension for better UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Statistics extension for monitoring
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Performance analysis
CREATE EXTENSION IF NOT EXISTS "pg_buffercache";

-- Create a dedicated schema for Keycloak if it doesn't exist
CREATE SCHEMA IF NOT EXISTS keycloak AUTHORIZATION current_user;

-- Set default schema search path
ALTER DATABASE keycloak SET search_path TO keycloak, public;

-- Optimize database settings for Keycloak workload
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET log_statement = 'mod';
ALTER SYSTEM SET log_min_duration_statement = 1000;
ALTER SYSTEM SET log_checkpoints = on;
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_lock_waits = on;

-- Create indexes that help with Keycloak performance
-- Note: These will be created by Keycloak, but we ensure the schema is optimized
SQL

if [ $? -eq 0 ]; then
    printf "${GREEN}[init-db]${NC} Successfully initialized extensions and schema for database: ${POSTGRES_DB}\n"
    printf "${GREEN}[init-db]${NC} Available extensions:\n"
    psql --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" -c "\dx"
else
    printf "${RED}[init-db]${NC} Failed to initialize database extensions\n"
    exit 1
fi

printf "${GREEN}[init-db]${NC} Database initialization completed successfully\n"
