#!/bin/bash

# AegisFlows - Backup Script
# Comprehensive backup solution for database and configuration

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="aegisflows_backup_${TIMESTAMP}"
RETENTION_DAYS=30

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Create backup directory
create_backup_dir() {
    local backup_path="$BACKUP_DIR/$BACKUP_NAME"
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    mkdir -p "$backup_path"/{database,config,logs}
    log "Created backup directory structure: $backup_path"
    echo "$backup_path"
}

# Backup PostgreSQL database
backup_database() {
    local backup_path="$1"
    log "Backing up PostgreSQL database..."
    
    # Check if PostgreSQL container is running
    if ! docker ps | grep -q iam-postgres; then
        error "PostgreSQL container is not running"
        return 1
    fi
    
    # Create database dump
    local db_backup_file="$backup_path/database/iam_db_${TIMESTAMP}.sql"
    
    if docker exec iam-postgres pg_dump -U postgres -d iam_db > "$db_backup_file"; then
        success "Database backup created: $(basename "$db_backup_file")"
        
        # Compress the backup
        gzip "$db_backup_file"
        success "Database backup compressed: $(basename "$db_backup_file").gz"
        
        # Create metadata file
        cat > "$backup_path/database/metadata.txt" << EOF
Backup Information
==================
Database: iam_db
Timestamp: $(date)
PostgreSQL Version: $(docker exec iam-postgres psql -U postgres -t -c "SELECT version();" | head -1 | xargs)
Database Size: $(docker exec iam-postgres psql -U postgres -d iam_db -t -c "SELECT pg_size_pretty(pg_database_size('iam_db'));" | xargs)
Tables Count: $(docker exec iam-postgres psql -U postgres -d iam_db -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';" | xargs)
EOF
        
        return 0
    else
        error "Failed to backup database"
        return 1
    fi
}

# Backup configuration files
backup_config() {
    local backup_path="$1"
    log "Backing up configuration files..."
    
    # Copy important configuration files
    local config_files=(
        ".env"
        "docker-compose.yml"
        "Dockerfile.dev"
        "Dockerfile.prod"
        "Makefile"
    )
    
    for file in "${config_files[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_path/config/"
            success "Backed up: $file"
        else
            warning "Configuration file not found: $file"
        fi
    done
    
    # Copy entire config directory if it exists
    if [[ -d "config" ]]; then
        cp -r config/* "$backup_path/config/" 2>/dev/null || true
        success "Backed up config directory"
    fi
    
    # Copy themes if they exist
    if [[ -d "themes" ]]; then
        cp -r themes "$backup_path/config/" 2>/dev/null || true
        success "Backed up themes directory"
    fi
    
    # Create system info
    cat > "$backup_path/config/system_info.txt" << EOF
System Information
==================
Hostname: $(hostname)
Operating System: $(uname -a)
Docker Version: $(docker --version)
Docker Compose Version: $(docker compose version --short 2>/dev/null || echo 'Unknown')
Backup Date: $(date)
Backup Script Version: 1.0

Environment Variables (sensitive data removed):
$(grep -v -E "(PASSWORD|SECRET|KEY)" .env 2>/dev/null || echo "No .env file found")
EOF
}

# Backup container logs
backup_logs() {
    local backup_path="$1"
    log "Backing up container logs..."
    
    # Backup Keycloak logs
    local kc_container
    if docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-dev"; then
        kc_container="iam-keycloak-dev"
    elif docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-prod"; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "${kc_container:-}" ]]; then
        docker logs "$kc_container" > "$backup_path/logs/keycloak_${TIMESTAMP}.log" 2>&1
        success "Backed up Keycloak logs"
    fi
    
    # Backup PostgreSQL logs
    if docker ps | grep -q iam-postgres; then
        docker logs iam-postgres > "$backup_path/logs/postgres_${TIMESTAMP}.log" 2>&1
        success "Backed up PostgreSQL logs"
    fi
    
    # Backup system logs if available
    if [[ -d "logs" ]]; then
        cp -r logs/* "$backup_path/logs/" 2>/dev/null || true
    fi
}

# Create backup manifest
create_manifest() {
    local backup_path="$1"
    log "Creating backup manifest..."
    
    cat > "$backup_path/MANIFEST.txt" << EOF
AegisFlows Backup Manifest
==========================
Backup Name: $BACKUP_NAME
Creation Date: $(date)
Backup Path: $backup_path

Contents:
---------
$(find "$backup_path" -type f -exec basename {} \; | sort)

Directory Structure:
-------------------
$(tree "$backup_path" 2>/dev/null || find "$backup_path" -type d | sort)

File Sizes:
-----------
$(du -h "$backup_path"/* 2>/dev/null | sort -hr)

Total Size: $(du -sh "$backup_path" | cut -f1)

Verification:
-------------
MD5 Checksums:
$(find "$backup_path" -type f -name "*.sql.gz" -o -name "*.env" -o -name "*.yml" | xargs md5sum 2>/dev/null || echo "No files to checksum")
EOF

    success "Backup manifest created"
}

# Compress backup
compress_backup() {
    local backup_path="$1"
    log "Compressing backup archive..."
    
    local backup_archive="${backup_path}.tar.gz"
    
    if tar -czf "$backup_archive" -C "$BACKUP_DIR" "$(basename "$backup_path")"; then
        success "Backup compressed: $(basename "$backup_archive")"
        
        # Remove uncompressed directory
        rm -rf "$backup_path"
        
        # Display archive information
        echo ""
        echo -e "${BLUE}Backup Archive Information:${NC}"
        echo "File: $backup_archive"
        echo "Size: $(du -h "$backup_archive" | cut -f1)"
        echo "Created: $(date)"
        
        return 0
    else
        error "Failed to compress backup"
        return 1
    fi
}

# Clean old backups
cleanup_old_backups() {
    log "Cleaning up old backups (older than $RETENTION_DAYS days)..."
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        return 0
    fi
    
    local deleted_count=0
    while IFS= read -r -d '' file; do
        rm "$file"
        deleted_count=$((deleted_count + 1))
        log "Deleted old backup: $(basename "$file")"
    done < <(find "$BACKUP_DIR" -name "aegisflows_backup_*.tar.gz" -mtime +$RETENTION_DAYS -print0 2>/dev/null)
    
    if [[ $deleted_count -gt 0 ]]; then
        success "Cleaned up $deleted_count old backup(s)"
    else
        log "No old backups to clean up"
    fi
}

# Verify services are running
verify_services() {
    log "Verifying services are running..."
    
    local services_ok=true
    
    if ! docker ps | grep -q iam-postgres; then
        error "PostgreSQL container is not running"
        services_ok=false
    fi
    
    if ! docker ps | grep -qE "iam-keycloak-(dev|prod)"; then
        error "Keycloak container is not running"
        services_ok=false
    fi
    
    if [[ "$services_ok" == "false" ]]; then
        error "Some services are not running. Backup may be incomplete."
        read -p "Continue anyway? [y/N]: " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            exit 1
        fi
    else
        success "All services are running"
    fi
}

# Display backup summary
display_summary() {
    local backup_archive="$1"
    
    echo ""
    echo -e "${GREEN}🎉 Backup Completed Successfully!${NC}"
    echo -e "${GREEN}=================================${NC}"
    echo ""
    echo -e "${BLUE}Backup Details:${NC}"
    echo "Archive: $(basename "$backup_archive")"
    echo "Location: $backup_archive"
    echo "Size: $(du -h "$backup_archive" | cut -f1)"
    echo "Created: $(date)"
    echo ""
    echo -e "${BLUE}Restore Command:${NC}"
    echo "make restore BACKUP_FILE=$backup_archive"
    echo ""
    echo -e "${BLUE}Available Backups:${NC}"
    ls -lh "$BACKUP_DIR"/aegisflows_backup_*.tar.gz 2>/dev/null | tail -5 || echo "No previous backups found"
}

# Main backup function
main() {
    echo -e "${BLUE}AegisFlows - Backup System${NC}"
    echo -e "${BLUE}==========================${NC}"
    echo ""
    
    # Verify services
    verify_services
    
    # Create backup directory structure
    local backup_path
    backup_path=$(create_backup_dir)
    
    # Perform backups
    local backup_success=true
    
    if ! backup_database "$backup_path"; then
        backup_success=false
    fi
    
    backup_config "$backup_path"
    backup_logs "$backup_path"
    create_manifest "$backup_path"
    
    # Compress backup
    local backup_archive="${backup_path}.tar.gz"
    if compress_backup "$backup_path"; then
        # Clean old backups
        cleanup_old_backups
        
        # Display summary
        display_summary "$backup_archive"
        
        if [[ "$backup_success" == "true" ]]; then
            exit 0
        else
            warning "Backup completed with some issues"
            exit 1
        fi
    else
        error "Backup compression failed"
        exit 1
    fi
}

# Run main function
main "$@"