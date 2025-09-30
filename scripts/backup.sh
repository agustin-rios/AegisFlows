#!/usr/bin/env bash
# =============================================================================
# AegisFlows Backup Script
# =============================================================================
# This script creates comprehensive backups of Keycloak data including:
# - PostgreSQL database dump
# - Keycloak data directory
# - Configuration files
# - SSL certificates (if present)
# =============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_BASE_DIR="${PROJECT_DIR}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${BACKUP_BASE_DIR}/${TIMESTAMP}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
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

# Help message
show_help() {
    echo "AegisFlows Backup Script"
    echo "========================"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help message"
    echo "  -d, --destination    Backup destination directory (default: ./backups)"
    echo "  -c, --compress       Compress backup using gzip"
    echo "  -k, --keep DAYS      Keep backups for DAYS days (default: 30)"
    echo "  -q, --quiet          Quiet mode - minimal output"
    echo "  --db-only            Backup only the database"
    echo "  --no-data            Backup only Keycloak data directory"
    echo ""
    echo "Examples:"
    echo "  $0                   # Create full backup"
    echo "  $0 --compress        # Create compressed backup"
    echo "  $0 --db-only         # Backup only database"
    echo "  $0 -k 7              # Keep backups for 7 days"
}

# Parse command line arguments
COMPRESS=false
KEEP_DAYS=30
QUIET=false
DB_ONLY=false
DATA_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--destination)
            BACKUP_BASE_DIR="$2"
            BACKUP_DIR="${BACKUP_BASE_DIR}/${TIMESTAMP}"
            shift 2
            ;;
        -c|--compress)
            COMPRESS=true
            shift
            ;;
        -k|--keep)
            KEEP_DAYS="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        --db-only)
            DB_ONLY=true
            shift
            ;;
        --no-data)
            DATA_ONLY=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Quiet mode
if [[ "$QUIET" == "true" ]]; then
    exec 1>/dev/null
fi

# Check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running!"
        exit 1
    fi
}

# Check if services are running
check_services() {
    log "Checking if services are running..."
    
    if ! docker compose ps postgres | grep -q "running"; then
        log_error "PostgreSQL service is not running!"
        log_error "Start services with: docker compose up -d"
        exit 1
    fi
    
    log_success "Services are running"
}

# Create backup directory
create_backup_dir() {
    log "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
}

# Backup database
backup_database() {
    log "Backing up PostgreSQL database..."
    
    # Load environment variables
    if [[ -f "${PROJECT_DIR}/.env" ]]; then
        source "${PROJECT_DIR}/.env"
    fi
    
    local db_file="${BACKUP_DIR}/postgres_keycloak.sql"
    
    if docker compose exec -T postgres pg_dump -U "${POSTGRES_USER:-keycloak}" "${POSTGRES_DB:-keycloak}" > "$db_file"; then
        log_success "Database backup completed: $(basename "$db_file")"
        
        if [[ "$COMPRESS" == "true" ]]; then
            log "Compressing database backup..."
            gzip "$db_file"
            log_success "Database backup compressed: $(basename "$db_file").gz"
        fi
    else
        log_error "Failed to backup database!"
        return 1
    fi
}

# Backup Keycloak data
backup_keycloak_data() {
    log "Backing up Keycloak data directory..."
    
    local data_dir="${BACKUP_DIR}/keycloak_data"
    mkdir -p "$data_dir"
    
    # Copy Keycloak data volume
    if docker compose exec keycloak tar -czf - -C /opt/keycloak/data . > "${data_dir}/keycloak_data.tar.gz"; then
        log_success "Keycloak data backup completed"
    else
        log_warning "Failed to backup Keycloak data (service might not be running)"
    fi
}

# Backup configuration files
backup_config() {
    log "Backing up configuration files..."
    
    local config_dir="${BACKUP_DIR}/config"
    mkdir -p "$config_dir"
    
    # Copy configuration files
    cp -r "${PROJECT_DIR}/config" "$config_dir/" 2>/dev/null || true
    cp -r "${PROJECT_DIR}/themes" "$config_dir/" 2>/dev/null || true
    cp -r "${PROJECT_DIR}/scripts" "$config_dir/" 2>/dev/null || true
    
    # Copy Docker files
    cp "${PROJECT_DIR}/docker-compose.yml" "$config_dir/" 2>/dev/null || true
    cp "${PROJECT_DIR}/Dockerfile" "$config_dir/" 2>/dev/null || true
    cp "${PROJECT_DIR}/Dockerfile.dev" "$config_dir/" 2>/dev/null || true
    
    # Copy environment files (excluding sensitive data)
    cp "${PROJECT_DIR}/.env.example" "$config_dir/" 2>/dev/null || true
    
    # Copy SSL certificates if they exist
    if [[ -d "${PROJECT_DIR}/certs" ]]; then
        cp -r "${PROJECT_DIR}/certs" "$config_dir/" 2>/dev/null || true
        log_success "SSL certificates backed up"
    fi
    
    log_success "Configuration files backed up"
}

# Create backup manifest
create_manifest() {
    log "Creating backup manifest..."
    
    local manifest_file="${BACKUP_DIR}/backup_manifest.txt"
    
    cat > "$manifest_file" << EOF
AegisFlows Backup Manifest
=========================
Backup Date: $(date)
Backup Directory: $BACKUP_DIR
Hostname: $(hostname)
Docker Version: $(docker --version)
Docker Compose Version: $(docker compose version --short)

Backup Contents:
EOF
    
    if [[ "$DB_ONLY" != "true" ]]; then
        echo "- PostgreSQL database dump" >> "$manifest_file"
    fi
    
    if [[ "$DATA_ONLY" != "true" ]]; then
        echo "- Keycloak data directory" >> "$manifest_file"
        echo "- Configuration files" >> "$manifest_file"
        echo "- SSL certificates (if present)" >> "$manifest_file"
    fi
    
    echo "" >> "$manifest_file"
    echo "Files:" >> "$manifest_file"
    find "$BACKUP_DIR" -type f -exec ls -lh {} \; >> "$manifest_file"
    
    log_success "Backup manifest created"
}

# Cleanup old backups
cleanup_old_backups() {
    log "Cleaning up backups older than $KEEP_DAYS days..."
    
    find "$BACKUP_BASE_DIR" -maxdepth 1 -type d -name "[0-9]*_[0-9]*" -mtime +$KEEP_DAYS -exec rm -rf {} \; 2>/dev/null || true
    
    local remaining_backups
    remaining_backups=$(find "$BACKUP_BASE_DIR" -maxdepth 1 -type d -name "[0-9]*_[0-9]*" | wc -l)
    
    log_success "Cleanup completed. $remaining_backups backup(s) remaining."
}

# Calculate backup size
calculate_size() {
    local size
    size=$(du -sh "$BACKUP_DIR" | cut -f1)
    log_success "Backup completed! Total size: $size"
    log_success "Backup location: $BACKUP_DIR"
}

# Main backup function
main() {
    log "Starting AegisFlows backup..."
    log "Timestamp: $TIMESTAMP"
    
    check_docker
    check_services
    create_backup_dir
    
    if [[ "$DATA_ONLY" != "true" ]]; then
        backup_database
    fi
    
    if [[ "$DB_ONLY" != "true" ]]; then
        backup_keycloak_data
        backup_config
    fi
    
    create_manifest
    calculate_size
    cleanup_old_backups
    
    log_success "Backup process completed successfully!"
    
    # Output final location for scripting
    if [[ "$QUIET" == "true" ]]; then
        echo "$BACKUP_DIR"
    fi
}

# Error handling
trap 'log_error "Backup failed with error on line $LINENO. Exit code: $?"' ERR

# Run main function
main "$@"