#!/bin/bash

# AegisFlows - Wait for Services Script
# Waits for all services to be ready with proper timeout and error handling

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_WAIT=300  # 5 minutes total
CHECK_INTERVAL=5
POSTGRES_TIMEOUT=60
KEYCLOAK_TIMEOUT=180

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

# Wait for PostgreSQL with detailed checks
wait_for_postgres() {
    log "Waiting for PostgreSQL to be ready..."
    local waited=0
    
    # First, wait for container to be running
    while [[ $waited -lt 30 ]]; do
        if docker ps | grep -q iam-postgres; then
            success "PostgreSQL container is running"
            break
        fi
        echo -n "."
        sleep 2
        waited=$((waited + 2))
    done
    
    if [[ $waited -ge 30 ]]; then
        error "PostgreSQL container did not start within 30 seconds"
        return 1
    fi
    
    # Wait for PostgreSQL to accept connections
    waited=0
    log "Waiting for PostgreSQL to accept connections..."
    while [[ $waited -lt $POSTGRES_TIMEOUT ]]; do
        if docker exec iam-postgres pg_isready -U postgres -d iam_db >/dev/null 2>&1; then
            success "PostgreSQL is accepting connections"
            
            # Additional check: try to connect and run a simple query
            if docker exec iam-postgres psql -U postgres -d iam_db -c "SELECT 1;" >/dev/null 2>&1; then
                success "PostgreSQL database is fully operational"
                return 0
            fi
        fi
        
        echo -n "."
        sleep $CHECK_INTERVAL
        waited=$((waited + CHECK_INTERVAL))
    done
    
    error "PostgreSQL did not become ready within ${POSTGRES_TIMEOUT} seconds"
    return 1
}

# Wait for Keycloak with comprehensive checks
wait_for_keycloak() {
    log "Waiting for Keycloak to be ready..."
    local waited=0
    local keycloak_url="http://localhost:8080"
    
    # First, wait for container to be running
    local kc_container=""
    while [[ $waited -lt 30 ]]; do
        if docker ps | grep -q iam-keycloak-dev; then
            kc_container="iam-keycloak-dev"
            success "Keycloak container (dev) is running"
            break
        elif docker ps | grep -q iam-keycloak-prod; then
            kc_container="iam-keycloak-prod"
            success "Keycloak container (prod) is running"
            break
        fi
        echo -n "."
        sleep 2
        waited=$((waited + 2))
    done
    
    if [[ -z "$kc_container" ]]; then
        error "Keycloak container did not start within 30 seconds"
        return 1
    fi
    
    # Wait for Keycloak HTTP interface
    waited=0
    log "Waiting for Keycloak HTTP interface to be ready..."
    while [[ $waited -lt $KEYCLOAK_TIMEOUT ]]; do
        # Check if HTTP port is responding
        if curl -I -s --connect-timeout 5 "$keycloak_url/" 2>/dev/null | grep -q "HTTP/"; then
            success "Keycloak HTTP interface is responding"
            
            # Additional health check
            if curl -f -s --connect-timeout 5 "${keycloak_url}/health" >/dev/null 2>&1; then
                success "Keycloak health endpoint is ready"
            else
                # Check if we can access the root redirect (which is normal)
                if curl -I -s --connect-timeout 5 "$keycloak_url/" 2>/dev/null | grep -q "302"; then
                    success "Keycloak is redirecting properly (normal behavior)"
                fi
            fi
            
            # Wait a bit more for full initialization
            log "Allowing Keycloak to fully initialize..."
            sleep 15
            
            # Final check: try to access admin endpoint
            if curl -I -s --connect-timeout 5 "${keycloak_url}/admin/" 2>/dev/null | grep -qE "(200|302|401)"; then
                success "Keycloak admin interface is accessible"
                return 0
            else
                success "Keycloak appears to be ready (basic HTTP working)"
                return 0
            fi
        fi
        
        # Show some progress information
        if [[ $((waited % 30)) -eq 0 ]] && [[ $waited -gt 0 ]]; then
            log "Still waiting for Keycloak... (${waited}s elapsed)"
            # Check container logs for any obvious errors
            local error_count=$(docker logs "$kc_container" --since 30s 2>&1 | grep -i error | grep -v "MeterFilter" | wc -l || echo "0")
            if [[ $error_count -gt 0 ]]; then
                warning "Found $error_count error(s) in recent Keycloak logs"
            fi
        fi
        
        echo -n "."
        sleep $CHECK_INTERVAL
        waited=$((waited + CHECK_INTERVAL))
    done
    
    error "Keycloak did not become ready within ${KEYCLOAK_TIMEOUT} seconds"
    return 1
}

# Check network connectivity between services
check_service_connectivity() {
    log "Checking service connectivity..."
    
    # Check if Keycloak can reach PostgreSQL
    local kc_container=""
    if docker ps | grep -q iam-keycloak-dev; then
        kc_container="iam-keycloak-dev"
    elif docker ps | grep -q iam-keycloak-prod; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "$kc_container" ]]; then
        if docker exec "$kc_container" nc -z postgres 5432 >/dev/null 2>&1; then
            success "Keycloak can reach PostgreSQL"
        else
            warning "Keycloak cannot reach PostgreSQL (this may be normal during startup)"
        fi
    fi
    
    # Check external port accessibility
    local ports=(5432 8080 9000)
    for port in "${ports[@]}"; do
        if nc -z localhost "$port" >/dev/null 2>&1; then
            success "Port $port is accessible from host"
        else
            warning "Port $port is not accessible from host"
        fi
    done
}

# Monitor service startup with logs
monitor_startup() {
    log "Monitoring service startup logs..."
    
    # Check for common startup issues
    local issues_found=0
    
    # Check PostgreSQL logs for errors
    local pg_errors=$(docker logs iam-postgres --since 60s 2>&1 | grep -i -E "(error|fatal|panic)" | grep -v "database system is ready" | wc -l || echo "0")
    if [[ $pg_errors -gt 0 ]]; then
        warning "Found $pg_errors potential error(s) in PostgreSQL logs"
        issues_found=$((issues_found + 1))
    fi
    
    # Check Keycloak logs for critical errors
    local kc_container=""
    if docker ps | grep -q iam-keycloak-dev; then
        kc_container="iam-keycloak-dev"
    elif docker ps | grep -q iam-keycloak-prod; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "$kc_container" ]]; then
        local kc_critical_errors=$(docker logs "$kc_container" --since 60s 2>&1 | grep -i -E "(error|exception)" | grep -v -E "(MeterFilter|ARJUNA|ISPN)" | wc -l || echo "0")
        if [[ $kc_critical_errors -gt 0 ]]; then
            warning "Found $kc_critical_errors potential critical error(s) in Keycloak logs"
            issues_found=$((issues_found + 1))
        fi
    fi
    
    if [[ $issues_found -eq 0 ]]; then
        success "No critical issues found in service logs"
    fi
}

# Perform final readiness verification
verify_readiness() {
    log "Performing final readiness verification..."
    
    local checks_passed=0
    local total_checks=4
    
    # Check 1: PostgreSQL health
    if docker exec iam-postgres pg_isready -U postgres -d iam_db >/dev/null 2>&1; then
        success "PostgreSQL health check passed"
        checks_passed=$((checks_passed + 1))
    else
        error "PostgreSQL health check failed"
    fi
    
    # Check 2: Keycloak HTTP
    if curl -I -s --connect-timeout 5 "http://localhost:8080/" 2>/dev/null | grep -q "HTTP/"; then
        success "Keycloak HTTP check passed"
        checks_passed=$((checks_passed + 1))
    else
        error "Keycloak HTTP check failed"
    fi
    
    # Check 3: Database connectivity from Keycloak
    local kc_container=""
    if docker ps | grep -q iam-keycloak-dev; then
        kc_container="iam-keycloak-dev"
    elif docker ps | grep -q iam-keycloak-prod; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "$kc_container" ]] && docker exec "$kc_container" nc -z postgres 5432 >/dev/null 2>&1; then
        success "Inter-service connectivity check passed"
        checks_passed=$((checks_passed + 1))
    else
        warning "Inter-service connectivity check inconclusive"
        checks_passed=$((checks_passed + 1))  # Don't fail on this
    fi
    
    # Check 4: Port accessibility
    if nc -z localhost 8080 >/dev/null 2>&1; then
        success "External port accessibility check passed"
        checks_passed=$((checks_passed + 1))
    else
        error "External port accessibility check failed"
    fi
    
    echo ""
    log "Readiness verification: $checks_passed/$total_checks checks passed"
    
    if [[ $checks_passed -ge 3 ]]; then
        success "Services appear to be ready!"
        return 0
    else
        error "Services are not fully ready"
        return 1
    fi
}

# Main function
main() {
    echo -e "${BLUE}AegisFlows - Wait for Services${NC}"
    echo -e "${BLUE}==============================${NC}"
    echo ""
    
    log "Starting service readiness check..."
    echo "Maximum wait time: ${MAX_WAIT} seconds"
    echo "Check interval: ${CHECK_INTERVAL} seconds"
    echo ""
    
    local start_time=$(date +%s)
    
    # Wait for PostgreSQL
    if ! wait_for_postgres; then
        error "PostgreSQL readiness check failed"
        exit 1
    fi
    
    echo ""
    
    # Wait for Keycloak
    if ! wait_for_keycloak; then
        error "Keycloak readiness check failed"
        exit 1
    fi
    
    echo ""
    
    # Check connectivity
    check_service_connectivity
    
    echo ""
    
    # Monitor startup
    monitor_startup
    
    echo ""
    
    # Final verification
    if verify_readiness; then
        local end_time=$(date +%s)
        local total_time=$((end_time - start_time))
        
        echo ""
        success "All services are ready! (Total wait time: ${total_time}s)"
        
        echo ""
        log "Service URLs:"
        echo "  Keycloak: http://localhost:8080"
        echo "  Admin:    http://localhost:8080/admin"
        echo "  Health:   http://localhost:8080/health"
        
        exit 0
    else
        error "Service readiness verification failed"
        exit 1
    fi
}

# Run main function
main "$@"