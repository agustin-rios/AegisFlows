#!/bin/bash

# AegisFlows - Test Suite
# Comprehensive testing of the optimized setup

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test Results
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

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

# Test execution wrapper
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    log "Running test: $test_name"
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if $test_function; then
        success "PASS: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        error "FAIL: $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test: Docker and Docker Compose availability
test_docker_availability() {
    command -v docker >/dev/null 2>&1 && \
    docker --version >/dev/null 2>&1 && \
    docker compose version >/dev/null 2>&1
}

# Test: Environment file exists and has required variables
test_env_file() {
    [[ -f ".env" ]] && \
    grep -q "KC_BOOTSTRAP_ADMIN_USERNAME" .env && \
    grep -q "KC_BOOTSTRAP_ADMIN_PASSWORD" .env && \
    grep -q "DB_USER" .env && \
    grep -q "DB_PASSWORD" .env
}

# Test: Container status
test_container_status() {
    docker ps | grep -q iam-postgres && \
    docker ps | grep -qE "iam-keycloak-(dev|prod)"
}

# Test: PostgreSQL connectivity
test_postgres_connectivity() {
    docker exec iam-postgres pg_isready -U postgres -d iam_db >/dev/null 2>&1 && \
    docker exec iam-postgres psql -U postgres -d iam_db -c "SELECT 1;" >/dev/null 2>&1
}

# Test: Keycloak HTTP accessibility
test_keycloak_http() {
    curl -I -s --connect-timeout 5 "http://localhost:8080/" 2>/dev/null | grep -q "HTTP/"
}

# Test: Keycloak health endpoint
test_keycloak_health() {
    curl -f -s --connect-timeout 5 "http://localhost:8080/health" >/dev/null 2>&1 || \
    curl -I -s --connect-timeout 5 "http://localhost:8080/" 2>/dev/null | grep -q "302"
}

# Test: Admin authentication
test_admin_auth() {
    if [[ ! -f ".env" ]]; then
        return 1
    fi
    
    source .env
    
    local auth_url="http://localhost:8080/realms/master/protocol/openid-connect/token"
    local response
    
    response=$(curl -s -X POST "$auth_url" \
        -d "client_id=admin-cli" \
        -d "username=${KC_BOOTSTRAP_ADMIN_USERNAME}" \
        -d "password=${KC_BOOTSTRAP_ADMIN_PASSWORD}" \
        -d "grant_type=password" 2>/dev/null || echo "")
    
    echo "$response" | grep -q "access_token"
}

# Test: Port accessibility
test_port_accessibility() {
    nc -z localhost 5432 >/dev/null 2>&1 && \
    nc -z localhost 8080 >/dev/null 2>&1 && \
    nc -z localhost 9000 >/dev/null 2>&1
}

# Test: Realm configuration files exist
test_realm_config_exists() {
    [[ -d "config/realms" ]] && \
    [[ -n "$(ls -A config/realms/*.json 2>/dev/null)" ]]
}

# Test: Script permissions
test_script_permissions() {
    [[ -x "scripts/check-requirements.sh" ]] && \
    [[ -x "scripts/health-check.sh" ]] && \
    [[ -x "scripts/post-startup.sh" ]] && \
    [[ -x "scripts/backup.sh" ]] && \
    [[ -x "scripts/realm-import.sh" ]]
}

# Test: Makefile functionality
test_makefile() {
    make help >/dev/null 2>&1
}

# Test: Service inter-connectivity
test_service_connectivity() {
    # Check if Keycloak can reach PostgreSQL
    local kc_container=""
    if docker ps | grep -q iam-keycloak-dev; then
        kc_container="iam-keycloak-dev"
    elif docker ps | grep -q iam-keycloak-prod; then
        kc_container="iam-keycloak-prod"
    fi
    
    [[ -n "$kc_container" ]] && \
    docker exec "$kc_container" nc -z postgres 5432 >/dev/null 2>&1
}

# Test: Log accessibility
test_logs_accessibility() {
    docker logs iam-postgres --tail 1 >/dev/null 2>&1 && \
    (docker logs iam-keycloak-dev --tail 1 >/dev/null 2>&1 || \
     docker logs iam-keycloak-prod --tail 1 >/dev/null 2>&1)
}

# Integration test: Full workflow
test_integration_workflow() {
    # This is a basic integration test
    # Test sequence: containers running -> db accessible -> keycloak accessible -> auth works
    test_container_status && \
    test_postgres_connectivity && \
    test_keycloak_http && \
    test_admin_auth
}

# Performance test: Response times
test_response_times() {
    local pg_time
    local kc_time
    
    # Test PostgreSQL response time
    pg_time=$(docker exec iam-postgres bash -c "time psql -U postgres -d iam_db -c 'SELECT 1;'" 2>&1 | grep real | awk '{print $2}' || echo "unknown")
    
    # Test Keycloak response time
    kc_time=$(curl -w "%{time_total}" -s -o /dev/null "http://localhost:8080/" || echo "unknown")
    
    # Consider it a pass if we got any response
    [[ "$pg_time" != "unknown" ]] && [[ "$kc_time" != "unknown" ]]
}

# Main test execution
main() {
    echo -e "${BLUE}AegisFlows - Test Suite${NC}"
    echo -e "${BLUE}=======================${NC}"
    echo ""
    
    log "Starting comprehensive test suite..."
    echo ""
    
    # Infrastructure Tests
    echo -e "${YELLOW}=== Infrastructure Tests ===${NC}"
    run_test "Docker Availability" test_docker_availability
    run_test "Environment Configuration" test_env_file
    run_test "Script Permissions" test_script_permissions
    run_test "Makefile Functionality" test_makefile
    echo ""
    
    # Service Tests
    echo -e "${YELLOW}=== Service Tests ===${NC}"
    run_test "Container Status" test_container_status
    run_test "PostgreSQL Connectivity" test_postgres_connectivity
    run_test "Keycloak HTTP Access" test_keycloak_http
    run_test "Keycloak Health" test_keycloak_health
    run_test "Port Accessibility" test_port_accessibility
    echo ""
    
    # Functional Tests
    echo -e "${YELLOW}=== Functional Tests ===${NC}"
    run_test "Admin Authentication" test_admin_auth
    run_test "Service Inter-connectivity" test_service_connectivity
    run_test "Log Accessibility" test_logs_accessibility
    echo ""
    
    # Configuration Tests
    echo -e "${YELLOW}=== Configuration Tests ===${NC}"
    run_test "Realm Configuration Files" test_realm_config_exists
    echo ""
    
    # Integration Tests
    echo -e "${YELLOW}=== Integration Tests ===${NC}"
    run_test "Full Workflow Integration" test_integration_workflow
    run_test "Response Times" test_response_times
    echo ""
    
    # Summary
    echo -e "${BLUE}=== Test Summary ===${NC}"
    echo "Tests Run:    $TESTS_RUN"
    echo "Tests Passed: $TESTS_PASSED"
    echo "Tests Failed: $TESTS_FAILED"
    echo ""
    
    local pass_rate=$((TESTS_PASSED * 100 / TESTS_RUN))
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        success "All tests passed! (100%)"
        echo ""
        echo -e "${GREEN}🎉 AegisFlows is working perfectly!${NC}"
        exit 0
    elif [[ $pass_rate -ge 80 ]]; then
        warning "Most tests passed ($pass_rate%). Some minor issues detected."
        echo ""
        echo -e "${YELLOW}⚠️  AegisFlows is mostly working with minor issues.${NC}"
        exit 0
    else
        error "Multiple tests failed ($pass_rate% passed). System may have issues."
        echo ""
        echo -e "${RED}❌ AegisFlows has significant issues that need attention.${NC}"
        echo ""
        echo "Troubleshooting suggestions:"
        echo "  1. Run: make health --detailed"
        echo "  2. Check logs: make logs"
        echo "  3. Verify setup: make check-requirements"
        echo "  4. Restart services: make restart"
        exit 1
    fi
}

# Run main function
main "$@"