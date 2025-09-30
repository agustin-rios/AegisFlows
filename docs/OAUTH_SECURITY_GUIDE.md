# 🔐 Dynamic OAuth Security Configuration Guide

## Overview

This guide explains how to securely configure OAuth providers (GitHub, Google) for **any realm** using AegisFlows' dynamic API-based secret management system.

## 🛡️ Security Architecture

### Before (❌ Insecure)
```json
{
  "identityProviders": [
    {
      "alias": "github",
      "config": {
        "clientId": "your-github-client-id",
        "clientSecret": "your-github-client-secret"  // ❌ SECRET IN REPO!
      }
    }
  ]
}
```

### After (✅ Secure - API-Based)
```json
{
  "identityProviders": [
    {
      "alias": "github", 
      "config": {
        "clientId": "will-be-updated-via-api",     // ✅ Placeholder in JSON
        "clientSecret": "will-be-updated-via-api", // ✅ Injected via Keycloak API
        "useJwksUrl": "true"
      }
    }
  ]
}
```

**🎯 Dynamic API Injection**: Secrets are **never stored in files** - they're injected at runtime via Keycloak Admin API!

## 📁 Dynamic Security Architecture

```text
AegisFlows/
├── .env                           # ❌ Never commit (contains secrets)
├── .gitignore                     # ✅ Ignores .env automatically
├── config/realms/
│   ├── your-realm.json            # ✅ Clean templates (safe for git)
│   └── another-realm.json         # ✅ No secrets, API placeholders
└── scripts/
    └── realm-import.sh            # ✅ API-based secret injection
```

### 🔄 Dynamic Process Flow

1. **Clean Template**: Realm JSON contains placeholder values
2. **Environment Variables**: Real secrets stored in `.env` 
3. **API Injection**: `realm-import.sh` uses Keycloak Admin API
4. **Runtime Update**: Secrets injected after realm creation
5. **Zero Files**: No secrets ever touch the filesystem!

## 🚀 Setup Instructions

### 1. Copy Environment Template
```bash
cp .env.example .env
```

### 2. Configure GitHub OAuth (Dynamic)

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create a new OAuth App:
   - **Application name**: `AegisFlows - {Your App Name}`
   - **Homepage URL**: `http://localhost:3000`  
   - **Authorization callback URL**: `http://localhost:8080/realms/{YOUR-REALM-NAME}/broker/github/endpoint`
3. Update `.env`:
   ```bash
   GITHUB_CLIENT_ID=your_actual_client_id
   GITHUB_CLIENT_SECRET=your_actual_client_secret
   ```

💡 **Dynamic Callback**: Replace `{YOUR-REALM-NAME}` with your actual realm name from the JSON file.

### 3. Configure Google OAuth (Dynamic)

1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create a new OAuth 2.0 Client ID:
   - **Application type**: Web application
   - **Name**: `AegisFlows - {Your App Name}`
   - **Authorized redirect URIs**: `http://localhost:8080/realms/{YOUR-REALM-NAME}/broker/google/endpoint`
3. Update `.env`:
   ```bash
   GOOGLE_CLIENT_ID=your_actual_client_id.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=your_actual_client_secret
   ```

### 4. Import Realm with Dynamic Security

```bash
# Auto-detect and import with API-based secret injection
make realm-import

# Or specify exact realm file
make realm-import REALM=your-realm.json

# Verify successful OAuth configuration
make status
```

The system will:
- ✅ Import your clean realm template
- ✅ Detect GitHub/Google identity providers  
- ✅ Inject real secrets via Keycloak Admin API
- ✅ Configure OAuth endpoints dynamically
- ✅ Display access URLs with correct realm name

## 🔄 Deployment Workflow

### Development
```bash
# 1. Generate configuration from template
make generate-realm-config

# 2. Import realm with secrets
make realm-import

# 3. Verify configuration
make health
```

### Production
```bash
# 1. Set production environment variables
export GITHUB_CLIENT_ID="prod_github_client_id"
export GITHUB_CLIENT_SECRET="prod_github_secret" 
export GOOGLE_CLIENT_ID="prod_google_client_id"
# ... etc

# 2. Generate and import
make realm-import
```

## 🔍 Security Verification

### Check for Leaked Secrets
```bash
# Verify no secrets in template
grep -r "your-.*-secret" config/realms/zmart.template.json
# Should return no results

# Verify generated config has real values
grep -r "\${.*}" config/realms/zmart.json  
# Should return no results (all variables substituted)
```

### Validate Environment Variables
```bash
./scripts/generate-realm-config.sh
# Should complete without errors and validate all required variables
```

## 🚨 Security Best Practices

### ✅ DO
- Use `.env` files for local development
- Use environment variables in production
- Store secrets in secure secret management systems (AWS Secrets Manager, Azure Key Vault, etc.)
- Rotate OAuth secrets regularly
- Use different OAuth apps for dev/staging/production

### ❌ DON'T
- Commit `.env` files to version control
- Hardcode secrets in JSON files
- Share OAuth secrets via chat/email
- Use the same OAuth app across environments
- Store secrets in plain text files

## 🛠️ Advanced Configuration

### Environment-Specific Configs
```bash
# Development
KEYCLOAK_HOSTNAME=localhost
GITHUB_CLIENT_ID=dev_github_id

# Production
KEYCLOAK_HOSTNAME=auth.zmart.com
GITHUB_CLIENT_ID=prod_github_id
```

### Secret Rotation
```bash
# 1. Update OAuth provider with new secret
# 2. Update environment variable
# 3. Regenerate and reimport realm
make realm-import
```

### Backup and Restore
```bash
# Backup includes template (safe) but not generated config (contains secrets)
make backup

# Restore and regenerate with new environment
make restore BACKUP_FILE=backup_file.tar.gz
make realm-import
```

## 🔗 OAuth Redirect URIs

Make sure to configure these exact redirect URIs in your OAuth providers:

- **GitHub**: `http://localhost:8080/realms/zmart/broker/github/endpoint`
- **Google**: `http://localhost:8080/realms/zmart/broker/google/endpoint`

For production, replace `localhost:8080` with your actual Keycloak domain.

## 📞 Support

If you encounter issues:
1. Check that all environment variables are set: `make generate-realm-config`
2. Validate OAuth provider configuration
3. Check Keycloak logs: `docker logs iam-keycloak-dev`
4. Verify redirect URIs match exactly

The ZMart realm is now configured with enterprise-grade security! 🔐