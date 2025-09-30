# Dynamic Realm Configuration Guide

## 🎯 Dynamic System Overview

AegisFlows supports **any realm configuration** with automatic detection and setup:

- **🔍 Auto-Detection**: Discovers realm configurations from `config/realms/*.json`
- **📝 Name Extraction**: Dynamically extracts realm name from JSON
- **🔗 URL Generation**: Creates all endpoints using detected realm name
- **🔐 API Security**: Injects OAuth secrets via Keycloak Admin API

## ✅ Core Features Available

### 1. OAuth Identity Providers
- **GitHub OAuth Integration**
  - Provider ID: `github`  
  - OAuth 2.0 authentication flow
  - Email verification and trust
  - Token storage for profile linking

- **Google OAuth Integration**
  - Provider ID: `google`
  - OAuth 2.0 authentication flow  
  - Email verification and trust
  - Token storage for profile linking

### 2. Identity Provider Mappers (IPM)
- **GitHub Mappers:**
  - `github-username-mapper`: Maps GitHub `login` to user `githubUsername` attribute
  - `github-email-mapper`: Maps GitHub `email` to user `email` attribute

- **Google Mappers:**
  - `google-id-mapper`: Maps Google `sub` (subject) to user `googleId` attribute
  - `google-email-mapper`: Maps Google `email` to user `email` attribute

### 3. User Attributes
- `customerType`: Premium, regular, etc.
- `preferredLanguage`: User language preference
- `phoneNumber`: Contact phone number
- `githubUsername`: Linked GitHub username
- `googleId`: Linked Google account identifier

### 4. Enhanced User Management
- **Admin User**: admin@zmart.local (password: admin123)
- **Test Customer**: customer1@example.com (password: customer123)
- **Custom Attributes**: Each user has customerType, language preferences, etc.

### 5. Role-Based Access Control
- `admin`: Full system access
- `customer`: Standard shopping privileges
- `premium-customer`: Enhanced privileges (composite role)
- `moderator`: Content moderation
- `support`: Customer support access

## 🚧 Next Steps for Complete Implementation

### 1. Client Applications
The following clients need to be created manually in Keycloak Admin Console:

#### ZMart Frontend Client
```
Client ID: zmart-frontend
Client Type: OpenID Connect
Access Type: confidential
Valid Redirect URIs: http://localhost:3000/*
Web Origins: http://localhost:3000
```

#### ZMart API Client  
```
Client ID: zmart-api
Client Type: OpenID Connect
Access Type: bearer-only
```

### 2. Protocol Mappers Configuration
Add these mappers to the frontend client:
- GitHub Username → `github_username` claim
- Customer Type → `customer_type` claim  
- Phone Number → `phone_number` claim

### 3. Identity Provider Configuration
Update the following with your actual OAuth credentials:

#### GitHub OAuth App
1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create new OAuth App
3. Replace `your-github-client-id` and `your-github-client-secret` in realm config

#### Google OAuth Credentials
1. Go to Google Cloud Console → APIs & Credentials
2. Create OAuth 2.0 Client ID
3. Replace `your-google-client-id` and `your-google-client-secret` in realm config

## 🔗 Authentication Flow

### Standard Login
1. User visits ZMart application
2. Redirected to Keycloak login page
3. Options available:
   - Username/password login
   - "Login with GitHub" button
   - "Login with Google" button

### Social Login Flow
1. User clicks "Login with GitHub/Google"
2. Redirected to provider OAuth consent screen
3. After consent, user profile is mapped using IPM
4. User attributes are automatically populated:
   - GitHub: `githubUsername`, `email`
   - Google: `googleId`, `email`
5. User is created/updated in ZMart realm
6. JWT token issued with custom claims

### Token Claims Example
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "github_username": "johndoe",
  "customer_type": "premium",
  "phone_number": "+1-555-0123",
  "preferred_username": "johndoe",
  "roles": ["customer", "premium-customer"]
}
```

## ⚙️ Dynamic Configuration Commands

### Realm Management

```bash
# Auto-detect and import first realm
make realm-import

# Import specific realm configuration
make realm-import REALM=your-realm.json
./scripts/realm-import.sh your-realm.json

# Export current realm configuration
make realm-export

# Get help with realm import options
./scripts/realm-import.sh --help
```

### Access Your Dynamic Realm

The system automatically detects your realm name and creates the correct URLs:

- **Admin Console**: `http://localhost:8080/admin/console/#/{detected-realm-name}`
- **Account Console**: `http://localhost:8080/realms/{detected-realm-name}/account`
- **Login Page**: `http://localhost:8080/realms/{detected-realm-name}/protocol/openid-connect/auth`
- **OpenID Config**: `http://localhost:8080/realms/{detected-realm-name}/.well-known/openid_configuration`

### System Status

```bash
# Check overall system health
make status

# View service logs
make logs

# Performance metrics
make performance
```

## 🛡️ Security Features

- **Brute Force Protection**: Enabled with progressive delays
- **Email Verification**: Required for new accounts
- **Password Policies**: Configurable strength requirements
- **Session Management**: Timeout and refresh token handling
- **Token Security**: JWT with proper signing and validation

## 🚀 Getting Started with Your Realm

1. **Place your realm configuration** in `config/realms/your-realm.json`
2. **Set OAuth credentials** in `.env` file
3. **Run realm import**: `make realm-import`
4. **Access your realm** at the auto-generated URLs above

The dynamic system works with **any realm name and configuration** - no hardcoding required!

---

📚 **Related Documentation**: [OAuth Security Guide](OAUTH_SECURITY_GUIDE.md) | [Clean Architecture](CLEAN_ARCHITECTURE.md)
