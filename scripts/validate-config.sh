#!/usr/bin/env bash
# =============================================================================
# AegisFlows Security and Configuration Validation Script
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
WARNINGS=0
ERRORS=0
CHECKS=0

print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}AegisFlows Configuration Validator${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo
}

print_check() {
    local message=$1
    local status=${2:-"INFO"}
    CHECKS=$((CHECKS + 1))
    
    case $status in
        "PASS")
            echo -e "[${GREEN}✓${NC}] $message"
            ;;
        "WARN")
            echo -e "[${YELLOW}⚠${NC}] $message"
            WARNINGS=$((WARNINGS + 1))
            ;;
        "FAIL")
            echo -e "[${RED}✗${NC}] $message"
            ERRORS=$((ERRORS + 1))
            ;;
        *)
            echo -e "[${BLUE}i${NC}] $message"
            ;;
    esac
}

check_file_exists() {
    local file=$1
    local required=${2:-true}
    
    if [[ -f "$file" ]]; then
        print_check "File exists: $file" "PASS"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            print_check "Required file missing: $file" "FAIL"
        else
            print_check "Optional file missing: $file" "WARN"
        fi
        return 1
    fi
}

check_env_security() {
    local env_file=${1:-.env}
    
    if [[ ! -f "$env_file" ]]; then
        print_check "Environment file not found: $env_file" "FAIL"
        return 1
    fi
    
    # Check for default passwords
    if grep -q "admin" "$env_file" 2>/dev/null; then
        print_check "Default admin credentials detected in $env_file" "WARN"
    fi
    
    if grep -q "keycloak" "$env_file" 2>/dev/null; then
        print_check "Default database credentials detected in $env_file" "WARN"
    fi
    
    # Check password strength
    local postgres_pass
    postgres_pass=$(grep "POSTGRES_PASSWORD=" "$env_file" | cut -d'=' -f2 | tr -d '"')
    if [[ ${#postgres_pass} -lt 16 ]]; then
        print_check "PostgreSQL password should be at least 16 characters" "WARN"
    else
        print_check "PostgreSQL password length is adequate" "PASS"
    fi
    
    local keycloak_pass
    keycloak_pass=$(grep "KEYCLOAK_ADMIN_PASSWORD=" "$env_file" | cut -d'=' -f2 | tr -d '"')
    if [[ ${#keycloak_pass} -lt 16 ]]; then
        print_check "Keycloak admin password should be at least 16 characters" "WARN"
    else
        print_check "Keycloak admin password length is adequate" "PASS"
    fi
}

check_docker_resources() {
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        print_check "Docker is not running" "FAIL"
        return 1
    fi
    
    print_check "Docker is running" "PASS"
    
    # Check available memory
    local mem_bytes
    mem_bytes=$(docker system info --format '{{.MemTotal}}' 2>/dev/null || echo "0")
    local mem_gb=$((mem_bytes / 1024 / 1024 / 1024))
    
    if [[ $mem_gb -lt 2 ]]; then
        print_check "Available memory ($mem_gb GB) is less than recommended 2GB" "WARN"
    else
        print_check "Available memory ($mem_gb GB) is adequate" "PASS"
    fi
}

check_docker_compose() {
    # Validate docker-compose.yml syntax
    if docker compose config --quiet 2>/dev/null; then
        print_check "docker-compose.yml syntax is valid" "PASS"
    else
        print_check "docker-compose.yml has syntax errors" "FAIL"
    fi
    
    # Check for exposed database ports in production
    if docker compose config 2>/dev/null | grep -A5 "postgres:" | grep -q "5432:5432"; then
        print_check "PostgreSQL port is exposed - consider removing in production" "WARN"
    fi
}

check_ssl_config() {
    if [[ -d "certs" ]]; then
        print_check "SSL certificates directory exists" "PASS"
        
        if [[ -f "certs/server.crt" && -f "certs/server.key" ]]; then
            print_check "SSL certificate files found" "PASS"
        else
            print_check "SSL certificate files missing (required for production)" "WARN"
        fi
    else
        print_check "SSL certificates directory missing (create for production)" "WARN"
    fi
}

check_backup_config() {
    if [[ -f "scripts/backup.sh" ]]; then
        print_check "Backup script exists" "PASS"
        
        if [[ -x "scripts/backup.sh" ]]; then
            print_check "Backup script is executable" "PASS"
        else
            print_check "Backup script is not executable" "WARN"
        fi
    else
        print_check "Backup script missing (recommended for production)" "WARN"
    fi
}

print_summary() {
    echo
    echo -e "${BLUE}===============${NC}"
    echo -e "${BLUE}Summary Report${NC}"
    echo -e "${BLUE}===============${NC}"
    
    echo "Total checks performed: $CHECKS"
    
    if [[ $ERRORS -eq 0 ]]; then
        echo -e "Errors: ${GREEN}$ERRORS${NC}"
    else
        echo -e "Errors: ${RED}$ERRORS${NC}"
    fi
    
    if [[ $WARNINGS -eq 0 ]]; then
        echo -e "Warnings: ${GREEN}$WARNINGS${NC}"
    else
        echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
    fi
    
    echo
    
    if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
        echo -e "${GREEN}🎉 All checks passed! Your configuration looks good.${NC}"
        exit 0
    elif [[ $ERRORS -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Configuration is functional but has warnings. Review before production deployment.${NC}"
        exit 0
    else
        echo -e "${RED}❌ Configuration has errors that need to be fixed before deployment.${NC}"
        exit 1
    fi
}

main() {
    print_header
    
    echo "Checking required files..."
    check_file_exists "docker-compose.yml"
    check_file_exists "Dockerfile"
    check_file_exists "Dockerfile.dev"
    check_file_exists ".env"
    check_file_exists ".env.example"
    check_file_exists "scripts/init-db.sh"
    
    echo
    echo "Checking optional files..."
    check_file_exists ".env.prod.example" false
    check_file_exists "docker-compose.prod.yml" false
    check_file_exists "docker-compose.monitoring.yml" false
    
    echo
    echo "Checking security configuration..."
    check_env_security ".env"
    check_ssl_config
    
    echo
    echo "Checking Docker configuration..."
    check_docker_resources
    check_docker_compose
    
    echo
    echo "Checking backup configuration..."
    check_backup_config
    
    print_summary
}

# Run main function
main "$@"