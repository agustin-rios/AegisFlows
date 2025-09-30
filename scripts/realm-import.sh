#!/bin/bash

# Dynamic Realm Import with API-based Secret Management
# This script imports any realm template and updates secrets via API

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}✅${NC} $1"; }
warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
error() { echo -e "${RED}❌${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REALM_CONFIG_DIR="$PROJECT_ROOT/config/realms"
KEYCLOAK_URL="http://localhost:8080"

# Dynamic realm configuration
REALM_CONFIG_FILE=""
REALM_NAME=""

# Show usage information
show_usage() {
    echo "Usage: $0 [realm-config.json]"
    echo ""
    echo "Import a Keycloak realm with API-based secret management."
    echo ""
    echo "Arguments:"
    echo "  realm-config.json    Optional. Specific realm config file (default: auto-detect)"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Auto-detect and import first realm config"
    echo "  $0 zmart.json       # Import specific realm config"
    echo ""
    echo "Environment Variables Required:"
    echo "  GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET    - GitHub OAuth credentials"
    echo "  GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET    - Google OAuth credentials"
    echo "  FRONTEND_CLIENT_ID, FRONTEND_SECRET       - Application client secrets"
    echo ""
}

# Function to detect and validate realm configuration
detect_realm_config() {
    # Handle help and options
    case "${1:-}" in
        -h|--help|help)
            show_usage
            exit 0
            ;;
        -*)
            error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    
    # Allow override via parameter
    if [[ -n "${1:-}" ]]; then
        REALM_CONFIG_FILE="$REALM_CONFIG_DIR/$1"
        if [[ ! -f "$REALM_CONFIG_FILE" ]]; then
            error "Specified realm config not found: $REALM_CONFIG_FILE"
            exit 1
        fi
    else
        # Auto-detect first JSON file in realm config directory
        local json_files=($(find "$REALM_CONFIG_DIR" -name "*.json" -type f))
        
        if [[ ${#json_files[@]} -eq 0 ]]; then
            error "No realm configuration files found in $REALM_CONFIG_DIR"
            exit 1
        elif [[ ${#json_files[@]} -gt 1 ]]; then
            warning "Multiple realm configs found. Using: $(basename "${json_files[0]}")"
        fi
        
        REALM_CONFIG_FILE="${json_files[0]}"
    fi
    
    # Extract realm name from JSON
    if command -v jq >/dev/null 2>&1; then
        REALM_NAME=$(jq -r '.realm' "$REALM_CONFIG_FILE" 2>/dev/null || echo "")
    else
        # Fallback without jq
        REALM_NAME=$(grep -o '"realm"[[:space:]]*:[[:space:]]*"[^"]*"' "$REALM_CONFIG_FILE" | sed 's/.*"realm"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    fi
    
    if [[ -z "$REALM_NAME" ]]; then
        error "Could not extract realm name from $REALM_CONFIG_FILE"
        exit 1
    fi
    
    log "Detected realm configuration:"
    log "  Config file: $(basename "$REALM_CONFIG_FILE")"
    log "  Realm name:  $REALM_NAME"
}

# Update identity provider secrets via API
update_identity_provider_secrets() {
    local access_token="$1"
    
    log "Updating identity provider secrets via API..."
    
    # Load environment variables
    source "$PROJECT_ROOT/.env"
    
    # Check required OAuth variables
    local oauth_vars=(
        "GITHUB_CLIENT_ID"
        "GITHUB_CLIENT_SECRET"
        "GOOGLE_CLIENT_ID"
        "GOOGLE_CLIENT_SECRET"
    )
    
    for var in "${oauth_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            warning "OAuth variable $var not set, skipping provider update"
            return 0
        fi
    done
    
    # Update GitHub provider
    log "Updating GitHub identity provider..."
    local github_config=$(cat <<EOF
{
  "clientId": "${GITHUB_CLIENT_ID}",
  "clientSecret": "${GITHUB_CLIENT_SECRET}",
  "useJwksUrl": "true"
}
EOF
)
    
    local response
    response=$(curl -s -w "%{http_code}" -X PUT \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d "$github_config" \
        "$KEYCLOAK_URL/admin/realms/$REALM_NAME/identity-provider/instances/github" 2>/dev/null || echo "000")
    
    local http_code="${response: -3}"
    if [[ "$http_code" == "204" ]]; then
        success "GitHub provider secrets updated"
    else
        warning "Failed to update GitHub provider (HTTP $http_code)"
    fi
    
    # Update Google provider  
    log "Updating Google identity provider..."
    local google_config=$(cat <<EOF
{
  "clientId": "${GOOGLE_CLIENT_ID}",
  "clientSecret": "${GOOGLE_CLIENT_SECRET}",
  "useJwksUrl": "true"
}
EOF
)
    
    response=$(curl -s -w "%{http_code}" -X PUT \
        -H "Authorization: Bearer $access_token" \
        -H "Content-Type: application/json" \
        -d "$google_config" \
        "$KEYCLOAK_URL/admin/realms/$REALM_NAME/identity-provider/instances/google" 2>/dev/null || echo "000")
    
    http_code="${response: -3}"
    if [[ "$http_code" == "204" ]]; then
        success "Google provider secrets updated"
    else
        warning "Failed to update Google provider (HTTP $http_code)"
    fi
}

# Update client secrets via API
update_client_secrets() {
    local access_token="$1"
    
    log "Updating client secrets via API..."
    
    # Load environment variables
    source "$PROJECT_ROOT/.env"
    
    # Check for frontend client variables (using realm-agnostic naming)
    local FRONTEND_CLIENT_ID="${FRONTEND_CLIENT_ID:-${ZMART_FRONTEND_CLIENT_ID:-}}"
    local FRONTEND_SECRET="${FRONTEND_SECRET:-${ZMART_FRONTEND_SECRET:-}}"
    
    if [[ -n "$FRONTEND_SECRET" ]]; then
        log "Updating frontend client secret..."
        
        # Get client UUID first
        local client_uuid
        client_uuid=$(curl -s -H "Authorization: Bearer $access_token" \
            "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients?clientId=${FRONTEND_CLIENT_ID}" | \
            jq -r '.[0].id' 2>/dev/null || echo "")
        
        if [[ -n "$client_uuid" && "$client_uuid" != "null" ]]; then
            local client_secret_config=$(cat <<EOF
{
  "type": "secret",
  "value": "${FRONTEND_SECRET}"
}
EOF
)
            
            local response
            response=$(curl -s -w "%{http_code}" -X POST \
                -H "Authorization: Bearer $access_token" \
                -H "Content-Type: application/json" \
                -d "$client_secret_config" \
                "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients/$client_uuid/client-secret" 2>/dev/null || echo "000")
            
            local http_code="${response: -3}"
            if [[ "$http_code" == "200" || "$http_code" == "204" ]]; then
                success "Frontend client secret updated"
            else
                warning "Failed to update frontend client secret (HTTP $http_code)"
            fi
        else
            warning "Frontend client not found, skipping secret update"
        fi
    fi
}

main() {
    echo -e "${BLUE}AegisFlows - Dynamic Realm Import${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
    
    # Detect and validate realm configuration
    detect_realm_config "${1:-}"
    
    # Load environment variables
    if [[ ! -f "$PROJECT_ROOT/.env" ]]; then
        error ".env file not found"
        exit 1
    fi
    
    source "$PROJECT_ROOT/.env"
    
    # Check if jq is available
    if ! command -v jq >/dev/null 2>&1; then
        error "jq is required for JSON processing. Please install jq."
        exit 1
    fi
    
    # Check if Keycloak is ready
    log "Checking if Keycloak is ready..."
    local mgmt_port="${KEYCLOAK_MGMT_PORT:-9000}"
    local health_url="http://localhost:$mgmt_port/health"
    
    if ! curl -sf "$health_url" >/dev/null 2>&1; then
        error "Keycloak is not ready. Please start services first."
        exit 1
    fi
    success "Keycloak is ready and healthy"
    
    # Get admin access token
    local access_token
    log "Obtaining admin access token..." >&2
    
    local auth_url="$KEYCLOAK_URL/realms/master/protocol/openid-connect/token"
    local response
    
    response=$(curl -s -X POST "$auth_url" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=admin-cli" \
        -d "username=${KC_BOOTSTRAP_ADMIN_USERNAME}" \
        -d "password=${KC_BOOTSTRAP_ADMIN_PASSWORD}" \
        -d "grant_type=password" 2>/dev/null || echo "")
    
    if [[ -z "$response" ]]; then
        error "Failed to get authentication response" >&2
        exit 1
    fi
    
    access_token=$(echo "$response" | jq -r '.access_token' 2>/dev/null || echo "null")
    
    if [[ "$access_token" == "null" || -z "$access_token" ]]; then
        error "Failed to obtain access token" >&2
        echo "Response: $response" >&2
        exit 1
    fi
    
    success "Admin access token obtained" >&2
    
    # Import clean realm template (without secrets)
    if [[ -f "$REALM_CONFIG_FILE" ]]; then
        log "Importing clean realm template..."
        
        local import_url="$KEYCLOAK_URL/admin/realms"
        local import_response
        
        # Check if realm exists
        local realm_exists=false
        if curl -sf -H "Authorization: Bearer $access_token" "$KEYCLOAK_URL/admin/realms/$REALM_NAME" >/dev/null 2>&1; then
            realm_exists=true
            warning "Realm '$REALM_NAME' already exists. Updating instead..."
            import_url="$import_url/$REALM_NAME"
            import_response=$(curl -s -w "%{http_code}" -X PUT \
                -H "Authorization: Bearer $access_token" \
                -H "Content-Type: application/json" \
                -d @"$REALM_CONFIG_FILE" \
                "$import_url" 2>/dev/null || echo "000")
        else
            log "Creating new realm..."
            import_response=$(curl -s -w "%{http_code}" -X POST \
                -H "Authorization: Bearer $access_token" \
                -H "Content-Type: application/json" \
                -d @"$REALM_CONFIG_FILE" \
                "$import_url" 2>/dev/null || echo "000")
        fi
        
        local http_code="${import_response: -3}"
        case "$http_code" in
            201|204|200)
                success "Clean realm configuration imported"
                ;;
            *)
                error "Failed to import realm (HTTP $http_code)"
                exit 1
                ;;
        esac
    else
        error "Clean realm template not found: $REALM_CONFIG_FILE"
        exit 1
    fi
    
    # Update secrets via API
    update_identity_provider_secrets "$access_token"
    update_client_secrets "$access_token"
    
    success "Realm import completed successfully!"
    
    # Display realm information
    log "Realm access information:"
    echo ""
    echo -e "${YELLOW}🏪 ${REALM_NAME^} Realm Access${NC}"
    echo -e "${YELLOW}$(printf '%*s' $((${#REALM_NAME} + 14)) '' | tr ' ' '=')${NC}"
    echo ""
    echo "Web Access:"
    echo "  ${REALM_NAME^} Realm:         $KEYCLOAK_URL/realms/$REALM_NAME"
    echo "  Account Console:       $KEYCLOAK_URL/realms/$REALM_NAME/account"
    echo "  Login Page:            $KEYCLOAK_URL/realms/$REALM_NAME/protocol/openid-connect/auth"
    echo ""
    echo "API Endpoints:"
    echo "  OpenID Configuration:  $KEYCLOAK_URL/realms/$REALM_NAME/.well-known/openid_configuration"
    echo "  Token Endpoint:        $KEYCLOAK_URL/realms/$REALM_NAME/protocol/openid-connect/token"
    echo "  User Info:             $KEYCLOAK_URL/realms/$REALM_NAME/protocol/openid-connect/userinfo"
    echo ""
}

main "$@"