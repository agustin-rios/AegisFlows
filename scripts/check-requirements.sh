#!/bin/bash

# AegisFlows - System Requirements Checker
# Validates system requirements and dependencies

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Docker installation and version
check_docker() {
    log "Checking Docker installation..."
    
    if ! command_exists docker; then
        error "Docker is not installed. Please install Docker first."
        echo "  Installation guide: https://docs.docker.com/get-docker/"
        return 1
    fi
    
    local docker_version=$(docker --version | cut -d' ' -f3 | sed 's/,//')
    local min_version="20.10.0"
    
    if ! docker version >/dev/null 2>&1; then
        error "Docker daemon is not running. Please start Docker."
        return 1
    fi
    
    success "Docker is installed and running (version: $docker_version)"
    
    # Check if user is in docker group (Linux only)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if ! groups | grep -q docker 2>/dev/null; then
            warning "Current user is not in the docker group. You may need to use sudo."
            echo "  To fix: sudo usermod -aG docker \$USER && newgrp docker"
        fi
    fi
}

# Check Docker Compose installation and version
check_docker_compose() {
    log "Checking Docker Compose installation..."
    
    if ! docker compose version >/dev/null 2>&1; then
        error "Docker Compose is not available. Please install Docker Compose."
        echo "  Installation guide: https://docs.docker.com/compose/install/"
        return 1
    fi
    
    local compose_version
    compose_version=$(docker compose version --short 2>/dev/null || docker compose version 2>/dev/null | head -1 | cut -d' ' -f4 || echo "Unknown")
    success "Docker Compose is available (version: $compose_version)"
}

# Check system resources
check_system_resources() {
    log "Checking system resources..."
    
    # Check available memory
    if command_exists free; then
        local mem_gb=$(free -g | awk '/^Mem:/{print $2}')
        if [[ $mem_gb -lt 4 ]]; then
            warning "System has ${mem_gb}GB RAM. Keycloak may run slowly with less than 4GB."
        else
            success "System has ${mem_gb}GB RAM available"
        fi
    fi
    
    # Check available disk space
    local disk_space=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $disk_space -lt 5 ]]; then
        warning "Available disk space: ${disk_space}GB. Consider freeing up space for Docker images and data."
    else
        success "Available disk space: ${disk_space}GB"
    fi
}

# Check network connectivity
check_network() {
    log "Checking network connectivity..."
    
    # Check if required ports are available
    local ports=(5432 8080 9000)
    for port in "${ports[@]}"; do
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            warning "Port $port is already in use. This may cause conflicts."
        fi
    done
    
    # Test internet connectivity for pulling images
    if command_exists curl; then
        if curl -s --connect-timeout 5 https://quay.io >/dev/null; then
            success "Network connectivity to image registries is working"
        else
            warning "Cannot reach quay.io. Image pulls may fail."
        fi
    fi
}

# Check if .env file exists and is properly configured
check_env_file() {
    log "Checking environment configuration..."
    
    if [[ ! -f ".env" ]]; then
        error ".env file not found. Please create one based on .env.example"
        return 1
    fi
    
    # Check for required variables
    local required_vars=(
        "DB_USER"
        "DB_PASSWORD"
        "DB_NAME"
        "KC_BOOTSTRAP_ADMIN_USERNAME"
        "KC_BOOTSTRAP_ADMIN_PASSWORD"
        "KEYCLOAK_HOSTNAME"
    )
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if ! grep -q "^$var=" .env; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        error "Missing required environment variables in .env:"
        printf '  - %s\n' "${missing_vars[@]}"
        return 1
    fi
    
    success "Environment configuration is valid"
}

# Check if realm files exist
check_realm_files() {
    log "Checking realm configuration files..."
    
    if [[ ! -d "config/realms" ]]; then
        warning "config/realms directory not found"
        return 0
    fi
    
    local realm_files=($(find config/realms -name "*.json" -type f))
    if [[ ${#realm_files[@]} -eq 0 ]]; then
        warning "No realm configuration files found in config/realms/"
    else
        success "Found ${#realm_files[@]} realm configuration file(s)"
        for file in "${realm_files[@]}"; do
            echo "  - $file"
        done
    fi
}

# Main function
main() {
    echo -e "${BLUE}AegisFlows - System Requirements Check${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo ""
    
    local checks_passed=0
    local total_checks=6
    
    # Run all checks
    if check_docker; then checks_passed=$((checks_passed + 1)); fi
    if check_docker_compose; then checks_passed=$((checks_passed + 1)); fi
    if check_system_resources; then checks_passed=$((checks_passed + 1)); fi
    if check_network; then checks_passed=$((checks_passed + 1)); fi
    if check_env_file; then checks_passed=$((checks_passed + 1)); fi
    if check_realm_files; then checks_passed=$((checks_passed + 1)); fi
    
    echo ""
    echo -e "${BLUE}Results Summary:${NC}"
    echo -e "Checks passed: $checks_passed/$total_checks"
    
    if [[ $checks_passed -eq $total_checks ]]; then
        success "All requirements satisfied! System is ready for AegisFlows."
        exit 0
    elif [[ $checks_passed -ge 4 ]]; then
        warning "Most requirements satisfied. Some warnings may need attention."
        exit 0
    else
        error "Critical requirements not met. Please address the issues above."
        exit 1
    fi
}

# Run main function
main "$@"