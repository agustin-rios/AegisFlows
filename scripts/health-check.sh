#!/bin/bash

# AegisFlows - Health Check Script
# Comprehensive health monitoring for all services

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TIMEOUT=10
DETAILED_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --detailed)
            DETAILED_MODE=true
            shift
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

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

# Check if container is running
check_container_status() {
    local container_name="$1"
    local service_name="$2"
    
    if docker ps --format "table {{.Names}}" | grep -q "^$container_name$"; then
        success "$service_name container is running"
        return 0
    else
        error "$service_name container is not running"
        return 1
    fi
}

# Check PostgreSQL health
check_postgres_health() {
    log "Checking PostgreSQL health..."
    
    if ! check_container_status "iam-postgres" "PostgreSQL"; then
        return 1
    fi
    
    # Check if PostgreSQL is ready to accept connections
    if docker exec iam-postgres pg_isready -U postgres -d iam_db -t $TIMEOUT >/dev/null 2>&1; then
        success "PostgreSQL is accepting connections"
        
        if [[ "$DETAILED_MODE" == "true" ]]; then
            # Get detailed stats
            local db_size=$(docker exec iam-postgres psql -U postgres -d iam_db -t -c "SELECT pg_size_pretty(pg_database_size('iam_db'));" 2>/dev/null | xargs)
            local connections=$(docker exec iam-postgres psql -U postgres -d iam_db -t -c "SELECT count(*) FROM pg_stat_activity;" 2>/dev/null | xargs)
            echo "  Database size: $db_size"
            echo "  Active connections: $connections"
        fi
        return 0
    else
        error "PostgreSQL is not accepting connections"
        return 1
    fi
}

# Check Keycloak health
check_keycloak_health() {
    log "Checking Keycloak health..."
    
    local keycloak_container
    if docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-dev"; then
        keycloak_container="iam-keycloak-dev"
    elif docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-prod"; then
        keycloak_container="iam-keycloak-prod"
    else
        error "No Keycloak container found running"
        return 1
    fi
    
    if ! check_container_status "$keycloak_container" "Keycloak"; then
        return 1
    fi
    
    # Check HTTP endpoint
    local health_url="http://localhost:8080/health"
    if curl -f -s --connect-timeout $TIMEOUT "$health_url" >/dev/null 2>&1; then
        success "Keycloak HTTP endpoint is responding"
    else
        # Fallback to basic connectivity test
        if curl -I -s --connect-timeout $TIMEOUT "http://localhost:8080/" 2>/dev/null | grep -q "HTTP/"; then
            success "Keycloak is accessible (HTTP redirect detected)"
        else
            error "Keycloak HTTP endpoint is not responding"
            return 1
        fi
    fi
    
    # Check management endpoint
    if curl -f -s --connect-timeout $TIMEOUT "http://localhost:9000/health" >/dev/null 2>&1; then
        success "Keycloak management endpoint is responding"
    else
        warning "Keycloak management endpoint may not be available"
    fi
    
    if [[ "$DETAILED_MODE" == "true" ]]; then
        # Get memory usage
        local memory_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" "$keycloak_container" 2>/dev/null | tail -n1)
        echo "  Memory usage: $memory_usage"
        
        # Check if admin console is accessible
        if curl -I -s --connect-timeout 5 "http://localhost:8080/admin/" 2>/dev/null | grep -q "200\|302"; then
            success "  Admin console is accessible"
        else
            warning "  Admin console may not be ready yet"
        fi
    fi
    
    return 0
}

# Check network connectivity
check_network_health() {
    log "Checking network health..."
    
    # Check if containers can communicate
    if docker exec iam-postgres nc -z iam-postgres 5432 >/dev/null 2>&1; then
        success "Database port is accessible internally"
    else
        error "Database port is not accessible"
        return 1
    fi
    
    # Check external access
    local ports=(5432 8080 9000)
    for port in "${ports[@]}"; do
        if nc -z localhost "$port" >/dev/null 2>&1; then
            success "Port $port is accessible externally"
        else
            warning "Port $port is not accessible externally"
        fi
    done
    
    return 0
}

# Check disk space
check_disk_space() {
    log "Checking disk space..."
    
    local disk_usage=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
    local available_space=$(df -h . | awk 'NR==2 {print $4}')
    
    if [[ $disk_usage -gt 90 ]]; then
        error "Disk usage is ${disk_usage}% (available: $available_space)"
        return 1
    elif [[ $disk_usage -gt 80 ]]; then
        warning "Disk usage is ${disk_usage}% (available: $available_space)"
    else
        success "Disk usage is ${disk_usage}% (available: $available_space)"
    fi
    
    # Check Docker volumes
    if [[ "$DETAILED_MODE" == "true" ]]; then
        echo "  Docker volume sizes:"
        docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}" 2>/dev/null || true
    fi
    
    return 0
}

# Check container logs for errors
check_container_logs() {
    if [[ "$DETAILED_MODE" != "true" ]]; then
        return 0
    fi
    
    log "Checking container logs for errors..."
    
    # Check PostgreSQL logs
    local pg_errors=$(docker logs iam-postgres --since 5m 2>&1 | grep -i error | wc -l)
    if [[ $pg_errors -gt 0 ]]; then
        warning "PostgreSQL has $pg_errors error(s) in the last 5 minutes"
    else
        success "No recent errors in PostgreSQL logs"
    fi
    
    # Check Keycloak logs
    local kc_container
    if docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-dev"; then
        kc_container="iam-keycloak-dev"
    elif docker ps --format "table {{.Names}}" | grep -q "iam-keycloak-prod"; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "$kc_container" ]]; then
        local kc_errors=$(docker logs "$kc_container" --since 5m 2>&1 | grep -i error | grep -v "MeterFilter" | wc -l)
        if [[ $kc_errors -gt 0 ]]; then
            warning "Keycloak has $kc_errors error(s) in the last 5 minutes"
        else
            success "No recent errors in Keycloak logs"
        fi
    fi
}

# Generate health report
generate_health_report() {
    if [[ "$DETAILED_MODE" != "true" ]]; then
        return 0
    fi
    
    log "Generating detailed health report..."
    
    echo ""
    echo "=== SYSTEM INFORMATION ==="
    echo "Timestamp: $(date)"
    echo "Uptime: $(uptime -p 2>/dev/null || echo 'Unknown')"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}' 2>/dev/null || echo 'Unknown')"
    
    echo ""
    echo "=== DOCKER INFORMATION ==="
    echo "Docker Version: $(docker --version)"
    echo "Compose Version: $(docker compose version --short 2>/dev/null || echo 'Unknown')"
    echo "Running Containers: $(docker ps --format 'table {{.Names}}\t{{.Status}}' | grep -v NAMES)"
    
    echo ""
    echo "=== RESOURCE USAGE ==="
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" 2>/dev/null || true
}

# Main health check function
main() {
    echo -e "${BLUE}AegisFlows - Health Check${NC}"
    echo -e "${BLUE}=========================${NC}"
    echo ""
    
    local checks_passed=0
    local total_checks=0
    
    # Core service checks
    if check_postgres_health; then ((checks_passed++)); fi; ((total_checks++))
    if check_keycloak_health; then ((checks_passed++)); fi; ((total_checks++))
    if check_network_health; then ((checks_passed++)); fi; ((total_checks++))
    if check_disk_space; then ((checks_passed++)); fi; ((total_checks++))
    
    # Additional checks in detailed mode
    if [[ "$DETAILED_MODE" == "true" ]]; then
        check_container_logs
        generate_health_report
    fi
    
    echo ""
    echo -e "${BLUE}Health Check Summary:${NC}"
    echo -e "Checks passed: $checks_passed/$total_checks"
    
    if [[ $checks_passed -eq $total_checks ]]; then
        success "All health checks passed! System is healthy."
        exit 0
    elif [[ $checks_passed -ge $((total_checks * 3 / 4)) ]]; then
        warning "Most health checks passed. Some issues may need attention."
        exit 0
    else
        error "Multiple health checks failed. System may not be functioning properly."
        exit 1
    fi
}

# Run main function
main "$@"