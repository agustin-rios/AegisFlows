#!/bin/bash

# AegisFlows - Post-startup Script
# Actions to perform after services start

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'  
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENV="${1:-dev}"
MAX_WAIT=300  # 5 minutes maximum wait time
CHECK_INTERVAL=5

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

# Wait for PostgreSQL to be ready
wait_for_postgres() {
    log "Waiting for PostgreSQL to be ready..."
    local waited=0
    
    while [[ $waited -lt $MAX_WAIT ]]; do
        if docker exec iam-postgres pg_isready -U postgres -d iam_db >/dev/null 2>&1; then
            success "PostgreSQL is ready"
            return 0
        fi
        
        echo -n "."
        sleep $CHECK_INTERVAL
        waited=$((waited + CHECK_INTERVAL))
    done
    
    error "PostgreSQL did not become ready within ${MAX_WAIT} seconds"
    return 1
}

# Wait for Keycloak to be ready
wait_for_keycloak() {
    log "Waiting for Keycloak to be ready..."
    local waited=0
    local keycloak_url="http://localhost:8080"
    
    while [[ $waited -lt $MAX_WAIT ]]; do
        # Try health endpoint first
        if curl -f -s --connect-timeout 5 "${keycloak_url}/health" >/dev/null 2>&1; then
            success "Keycloak health endpoint is ready"
            return 0
        fi
        
        # Fallback to basic HTTP check
        if curl -I -s --connect-timeout 5 "$keycloak_url/" 2>/dev/null | grep -q "HTTP/"; then
            success "Keycloak HTTP interface is ready"
            return 0
        fi
        
        echo -n "."
        sleep $CHECK_INTERVAL
        waited=$((waited + CHECK_INTERVAL))
    done
    
    error "Keycloak did not become ready within ${MAX_WAIT} seconds"
    return 1
}

# Check if admin user can authenticate
verify_admin_access() {
    log "Verifying admin access..."
    
    # Get admin credentials from environment
    source .env
    
    local auth_url="http://localhost:8080/realms/master/protocol/openid-connect/token"
    local client_id="admin-cli"
    
    # Try to get access token
    local response=$(curl -s -X POST "$auth_url" \
        -d "client_id=$client_id" \
        -d "username=${KC_BOOTSTRAP_ADMIN_USERNAME}" \
        -d "password=${KC_BOOTSTRAP_ADMIN_PASSWORD}" \
        -d "grant_type=password" 2>/dev/null || echo "")
    
    if echo "$response" | grep -q "access_token"; then
        success "Admin authentication successful"
        return 0
    else
        warning "Admin authentication failed or not ready yet"
        return 1
    fi
}

# Display service information
display_service_info() {
    log "Service startup complete! Here's your access information:"
    
    echo ""
    echo -e "${GREEN}🏪 ZMart IAM Platform (${ENV} mode)${NC}"
    echo -e "${GREEN}=================================${NC}"
    echo ""
    echo -e "${BLUE}🔐 Keycloak Access:${NC}"
    echo "   Web Interface:     http://localhost:8080"
    echo "   Admin Console:     http://localhost:8080/admin"
    echo "   Management:        http://localhost:9000"
    echo ""
    echo -e "${BLUE}🐘 PostgreSQL Access:${NC}" 
    echo "   Host:              localhost:5432"
    echo "   Database:          iam_db"
    echo "   Username:          postgres"
    echo ""
    
    # Load credentials from .env
    if [[ -f ".env" ]]; then
        source .env
        echo -e "${BLUE}🔑 Default Credentials:${NC}"
        echo "   Admin User:        ${KC_BOOTSTRAP_ADMIN_USERNAME:-admin}"
        echo "   Admin Password:    ${KC_BOOTSTRAP_ADMIN_PASSWORD:-admin}"
        echo ""
    fi
    
    echo -e "${BLUE}📚 Next Steps:${NC}"
    echo "   1. Access admin console: http://localhost:8080/admin"
    echo "   2. Import ZMart realm:   make realm-import"
    echo "   3. Run health checks:    make health"
    echo "   4. View logs:            make logs"
    echo ""
    
    if [[ "$ENV" == "dev" ]]; then
        echo -e "${YELLOW}⚠️  Development Mode Active${NC}"
        echo "   - TLS/HTTPS disabled"
        echo "   - Debug features enabled"
        echo "   - Not suitable for production"
        echo ""
    fi
}

# Perform initial setup tasks
perform_initial_setup() {
    log "Performing initial setup tasks..."
    
    # Create any necessary directories
    mkdir -p config/realms config/themes logs backups
    
    # Set proper permissions if needed
    if [[ -d "themes" ]]; then
        chmod -R 755 themes
    fi
    
    success "Initial setup completed"
}

# Check for common issues and provide suggestions
check_common_issues() {
    log "Checking for common issues..."
    
    # Check if ports are accessible
    local ports=(5432 8080 9000)
    for port in "${ports[@]}"; do
        if ! nc -z localhost "$port" >/dev/null 2>&1; then
            warning "Port $port is not accessible. Check firewall settings."
        fi
    done
    
    # Check disk space
    local disk_usage=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 85 ]]; then
        warning "Disk usage is ${disk_usage}%. Consider cleaning up to avoid issues."
    fi
    
    # Check if realm files exist for import
    if [[ -d "config/realms" ]] && [[ -n "$(ls -A config/realms/*.json 2>/dev/null)" ]]; then
        success "Realm configuration files found and ready for import"
    else
        warning "No realm configuration files found. You may need to configure realms manually."
    fi
}

# Main function
main() {
    echo -e "${BLUE}AegisFlows - Post-Startup Setup${NC}"
    echo -e "${BLUE}===============================${NC}"
    echo ""
    
    # Perform initial setup
    perform_initial_setup
    
    # Wait for services to be ready
    if ! wait_for_postgres; then
        error "PostgreSQL startup failed"
        exit 1
    fi
    
    if ! wait_for_keycloak; then
        error "Keycloak startup failed"  
        exit 1
    fi
    
    # Give Keycloak a bit more time to fully initialize
    log "Allowing Keycloak to fully initialize..."
    sleep 10
    
    # Verify admin access (optional - don't fail if it doesn't work yet)
    verify_admin_access || true
    
    # Check for common issues
    check_common_issues
    
    # Display service information
    display_service_info
    
    success "Post-startup setup completed successfully!"
}

# Run main function
main "$@"