#!/usr/bin/env bash
# =============================================================================
# AegisFlows Restore Script
# =============================================================================
# This script restores AegisFlows from backups created by backup.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

show_help() {
    echo "AegisFlows Restore Script"
    echo "========================="
    echo ""
    echo "Usage: $0 <backup_directory>"
    echo ""
    echo "Arguments:"
    echo "  backup_directory     Path to the backup directory to restore from"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  --db-only           Restore only the database"
    echo "  --force             Skip confirmation prompts"
    echo ""
    echo "Examples:"
    echo "  $0 backups/20231201_120000"
    echo "  $0 --db-only backups/20231201_120000"
}

# Parse arguments
BACKUP_DIR=""
DB_ONLY=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --db-only)
            DB_ONLY=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -*)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            BACKUP_DIR="$1"
            shift
            ;;
    esac
done

if [[ -z "$BACKUP_DIR" ]]; then
    log_error "Backup directory is required!"
    show_help
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    log_error "Backup directory does not exist: $BACKUP_DIR"
    exit 1
fi

# Confirmation
if [[ "$FORCE" != "true" ]]; then
    log_warning "This will restore from backup: $BACKUP_DIR"
    log_warning "Current data will be overwritten!"
    read -p "Are you sure you want to continue? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Restore cancelled."
        exit 0
    fi
fi

log "Starting restore from: $BACKUP_DIR"

# Load environment variables
if [[ -f "${PROJECT_DIR}/.env" ]]; then
    source "${PROJECT_DIR}/.env"
fi

# Restore database
restore_database() {
    log "Restoring PostgreSQL database..."
    
    local db_file="${BACKUP_DIR}/postgres_keycloak.sql"
    
    # Check for compressed file
    if [[ -f "${db_file}.gz" && ! -f "$db_file" ]]; then
        log "Decompressing database backup..."
        gunzip -c "${db_file}.gz" > "$db_file"
    fi
    
    if [[ ! -f "$db_file" ]]; then
        log_error "Database backup file not found: $db_file"
        return 1
    fi
    
    # Stop Keycloak to avoid connection issues
    log "Stopping Keycloak service..."
    docker compose stop keycloak 2>/dev/null || true
    
    # Drop and recreate database
    log "Recreating database..."
    docker compose exec -T postgres psql -U "${POSTGRES_USER:-keycloak}" -d postgres << EOF
DROP DATABASE IF EXISTS "${POSTGRES_DB:-keycloak}";
CREATE DATABASE "${POSTGRES_DB:-keycloak}" OWNER "${POSTGRES_USER:-keycloak}";
EOF
    
    # Restore database
    if docker compose exec -T postgres psql -U "${POSTGRES_USER:-keycloak}" -d "${POSTGRES_DB:-keycloak}" < "$db_file"; then
        log_success "Database restored successfully"
    else
        log_error "Failed to restore database!"
        return 1
    fi
}

# Restore Keycloak data
restore_keycloak_data() {
    log "Restoring Keycloak data..."
    
    local data_file="${BACKUP_DIR}/keycloak_data/keycloak_data.tar.gz"
    
    if [[ ! -f "$data_file" ]]; then
        log_warning "Keycloak data backup not found: $data_file"
        return 0
    fi
    
    # Stop Keycloak
    docker compose stop keycloak 2>/dev/null || true
    
    # Remove existing data and restore
    if docker compose exec -T postgres sh -c "rm -rf /opt/keycloak/data/* && tar -xzf - -C /opt/keycloak/data" < "$data_file"; then
        log_success "Keycloak data restored successfully"
    else
        log_error "Failed to restore Keycloak data!"
        return 1
    fi
}

# Restore configuration
restore_config() {
    log "Restoring configuration files..."
    
    local config_dir="${BACKUP_DIR}/config"
    
    if [[ ! -d "$config_dir" ]]; then
        log_warning "Configuration backup not found: $config_dir"
        return 0
    fi
    
    # Restore config directories
    if [[ -d "${config_dir}/config" ]]; then
        cp -r "${config_dir}/config" "${PROJECT_DIR}/" 2>/dev/null || true
    fi
    
    if [[ -d "${config_dir}/themes" ]]; then
        cp -r "${config_dir}/themes" "${PROJECT_DIR}/" 2>/dev/null || true
    fi
    
    if [[ -d "${config_dir}/certs" ]]; then
        cp -r "${config_dir}/certs" "${PROJECT_DIR}/" 2>/dev/null || true
        log_success "SSL certificates restored"
    fi
    
    log_success "Configuration files restored"
}

# Start services
start_services() {
    log "Starting services..."
    
    if docker compose up -d; then
        log_success "Services started successfully"
        
        # Wait for services to be healthy
        log "Waiting for services to be ready..."
        sleep 30
        
        # Check health
        if docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-keycloak}" -d "${POSTGRES_DB:-keycloak}" >/dev/null 2>&1; then
            log_success "PostgreSQL is ready"
        else
            log_warning "PostgreSQL may not be ready yet"
        fi
        
    else
        log_error "Failed to start services!"
        return 1
    fi
}

# Main restore function
main() {
    log "Starting AegisFlows restore..."
    
    # Check if backup manifest exists
    if [[ -f "${BACKUP_DIR}/backup_manifest.txt" ]]; then
        log "Backup manifest found:"
        head -n 10 "${BACKUP_DIR}/backup_manifest.txt"
        echo ""
    fi
    
    # Restore database
    restore_database
    
    # Restore other components if not DB-only
    if [[ "$DB_ONLY" != "true" ]]; then
        restore_keycloak_data
        restore_config
    fi
    
    # Start services
    start_services
    
    log_success "Restore completed successfully!"
    log "You can access Keycloak at: http://localhost:8080"
}

# Error handling
trap 'log_error "Restore failed with error on line $LINENO. Exit code: $?"' ERR

# Run main function
main "$@"