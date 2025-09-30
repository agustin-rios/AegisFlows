#!/bin/bash

# AegisFlows - Display Information Script
# Shows comprehensive system and service information

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
ENV="${1:-dev}"

# Display header
display_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                      AegisFlows - ZMart IAM                   ║
    ║                   Identity & Access Management                 ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Display service status
display_service_status() {
    echo -e "${BLUE}📊 Service Status (${ENV} environment)${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
    
    # Check PostgreSQL
    if docker ps | grep -q iam-postgres; then
        echo -e "${GREEN}🐘 PostgreSQL:${NC} Running"
        local pg_version=$(docker exec iam-postgres psql -U postgres -t -c "SELECT version();" 2>/dev/null | head -1 | awk '{print $2}' || echo "Unknown")
        echo "   Version: $pg_version"
        echo "   Container: iam-postgres"
        echo "   Port: 5432"
    else
        echo -e "${RED}🐘 PostgreSQL:${NC} Not Running"
    fi
    
    echo ""
    
    # Check Keycloak
    local kc_container=""
    if docker ps | grep -q iam-keycloak-dev; then
        kc_container="iam-keycloak-dev"
    elif docker ps | grep -q iam-keycloak-prod; then
        kc_container="iam-keycloak-prod"
    fi
    
    if [[ -n "$kc_container" ]]; then
        echo -e "${GREEN}🔐 Keycloak:${NC} Running ($ENV mode)"
        echo "   Version: 26.1.2"
        echo "   Container: $kc_container"
        echo "   Ports: 8080 (HTTP), 9000 (Management)"
        
        # Check if accessible
        if curl -I -s --connect-timeout 3 "http://localhost:8080/" 2>/dev/null | grep -q "HTTP/"; then
            echo -e "   Status: ${GREEN}Accessible${NC}"
        else
            echo -e "   Status: ${YELLOW}Starting up...${NC}"
        fi
    else
        echo -e "${RED}🔐 Keycloak:${NC} Not Running"
    fi
    
    echo ""
}

# Display access information
display_access_info() {
    echo -e "${BLUE}🌐 Access Information${NC}"
    echo -e "${BLUE}=====================${NC}"
    echo ""
    
    echo -e "${PURPLE}🔐 Keycloak Admin Console:${NC}"
    echo "   URL:      http://localhost:8080/admin/"
    echo "   Username: admin"
    echo "   Password: admin"
    echo ""
    
    echo -e "${PURPLE}🏪 ZMart Realm (after import):${NC}"
    echo "   Realm URL:       http://localhost:8080/realms/zmart"
    echo "   Account Console: http://localhost:8080/realms/zmart/account/"
    echo "   Well-known:      http://localhost:8080/realms/zmart/.well-known/openid_configuration"
    echo ""
    
    echo -e "${PURPLE}🐘 PostgreSQL Database:${NC}"
    echo "   Host:     localhost:5432"
    echo "   Database: iam_db"
    echo "   Username: postgres"
    echo "   Password: postgres"
    echo ""
    
    echo -e "${PURPLE}📊 Management Endpoints:${NC}"
    echo "   Health Check: http://localhost:8080/health"
    echo "   Metrics:      http://localhost:9000/metrics"
    echo ""
}

# Display test users (if ZMart realm is imported)
display_test_users() {
    echo -e "${BLUE}👤 Test Users (ZMart Realm)${NC}"
    echo -e "${BLUE}============================${NC}"
    echo ""
    
    echo -e "${GREEN}🔑 Administrator:${NC}"
    echo "   Username: admin"
    echo "   Email:    admin@zmart.local"
    echo "   Role:     ADMIN"
    echo "   Password: [Set during realm import]"
    echo ""
    
    echo -e "${GREEN}🛒 Customer:${NC}"
    echo "   Username: customer1"
    echo "   Email:    customer1@example.com"
    echo "   Role:     USER/CUSTOMER"
    echo "   Tier:     STANDARD"
    echo ""
    
    echo -e "${GREEN}⚖️ Moderator:${NC}"
    echo "   Username: moderator1"
    echo "   Email:    moderator@zmart.local"
    echo "   Role:     MODERATOR"
    echo "   Department: MODERATION"
    echo ""
}

# Display quick commands
display_quick_commands() {
    echo -e "${BLUE}⚡ Quick Commands${NC}"
    echo -e "${BLUE}=================${NC}"
    echo ""
    
    echo -e "${YELLOW}Service Management:${NC}"
    echo "   make start          - Start all services"
    echo "   make stop           - Stop all services"
    echo "   make restart        - Restart all services"
    echo "   make status         - Show service status"
    echo "   make logs           - View all logs"
    echo ""
    
    echo -e "${YELLOW}Health & Monitoring:${NC}"
    echo "   make health         - Run health checks"
    echo "   make test           - Run test suite"
    echo "   make logs-keycloak  - View Keycloak logs"
    echo "   make logs-postgres  - View PostgreSQL logs"
    echo ""
    
    echo -e "${YELLOW}Realm Management:${NC}"
    echo "   make realm-import   - Import ZMart realm"
    echo "   make realm-export   - Export realm configuration"
    echo "   make setup          - Complete initial setup"
    echo ""
    
    echo -e "${YELLOW}Maintenance:${NC}"
    echo "   make backup         - Create backup"
    echo "   make clean          - Clean up resources"
    echo "   make update         - Update container images"
    echo ""
}

# Display environment-specific notes
display_environment_notes() {
    echo -e "${BLUE}📝 Environment Notes${NC}"
    echo -e "${BLUE}====================${NC}"
    echo ""
    
    if [[ "$ENV" == "dev" ]]; then
        echo -e "${YELLOW}🔧 Development Mode Active${NC}"
        echo "   • TLS/HTTPS disabled for easy testing"
        echo "   • Debug features enabled"
        echo "   • Theme caching disabled"
        echo "   • Verbose logging enabled"
        echo "   • Hot reload for themes"
        echo ""
        echo -e "${RED}⚠️  Security Warnings:${NC}"
        echo "   • Default passwords in use"
        echo "   • HTTP only (no encryption)"
        echo "   • Not suitable for production"
        echo ""
    else
        echo -e "${GREEN}🚀 Production Mode Active${NC}"
        echo "   • TLS/HTTPS enforced"
        echo "   • Optimized performance"
        echo "   • Security headers enabled"
        echo "   • Theme caching enabled"
        echo ""
        echo -e "${RED}⚠️  Production Checklist:${NC}"
        echo "   • Change default passwords"
        echo "   • Configure proper TLS certificates"
        echo "   • Set up monitoring"
        echo "   • Configure backup schedule"
        echo "   • Review security settings"
        echo ""
    fi
}

# Display troubleshooting info
display_troubleshooting() {
    echo -e "${BLUE}🔧 Troubleshooting${NC}"
    echo -e "${BLUE}==================${NC}"
    echo ""
    
    echo -e "${YELLOW}Common Issues:${NC}"
    echo ""
    
    echo -e "${GREEN}Port Conflicts:${NC}"
    echo "   Check: netstat -tuln | grep -E '(5432|8080|9000)'"
    echo "   Fix:   Stop conflicting services or change ports in .env"
    echo ""
    
    echo -e "${GREEN}Container Won't Start:${NC}"
    echo "   Check: docker compose logs [service-name]"
    echo "   Fix:   make clean && make start"
    echo ""
    
    echo -e "${GREEN}Database Connection Issues:${NC}"
    echo "   Check: make health"
    echo "   Fix:   Ensure PostgreSQL is running and healthy"
    echo ""
    
    echo -e "${GREEN}Keycloak Not Accessible:${NC}"
    echo "   Check: curl -I http://localhost:8080/"
    echo "   Fix:   Wait for startup (can take 30-60 seconds)"
    echo ""
    
    echo -e "${YELLOW}Getting Help:${NC}"
    echo "   • Check logs: make logs"
    echo "   • Run health check: make health --detailed"
    echo "   • Verify requirements: make check-requirements"
    echo ""
}

# Main function
main() {
    clear
    display_header
    
    echo -e "${CYAN}Environment: ${ENV}${NC}"
    echo -e "${CYAN}Timestamp: $(date)${NC}"
    echo ""
    
    display_service_status
    echo ""
    
    display_access_info
    echo ""
    
    display_test_users
    echo ""
    
    display_quick_commands
    echo ""
    
    display_environment_notes
    echo ""
    
    display_troubleshooting
    
    echo -e "${CYAN}For more help, run: make help${NC}"
    echo ""
}

# Run main function
main "$@"