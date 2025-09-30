# ⚡ AegisFlows Quick Start

Get your dynamic IAM platform running in under 2 minutes!

## 🚀 Zero-to-Ready Setup

1. **Clone & Setup**
   ```bash
   git clone https://github.com/agustin-rios/AegisFlows.git
   cd AegisFlows
   make setup
   ```

2. **That's it!** The `make setup` command automatically:
   - ✅ Validates system requirements
   - ✅ Starts PostgreSQL + Keycloak services
   - ✅ Auto-detects and imports your realm configuration
   - ✅ Configures OAuth providers (if credentials provided)

3. **Access Your System**
   - **Keycloak Admin**: <http://localhost:8080/admin> (admin/admin)
   - **Your Realm**: <http://localhost:8080/realms/{detected-realm-name}>
   - **Account Console**: <http://localhost:8080/realms/{detected-realm-name}/account>

## 🛠️ Essential Commands

```bash
# Check system status
make status

# View logs
make logs

# Stop services
make stop

# Complete cleanup (⚠️ removes all data)
make clean

# Get help with all commands
make help
```

## 🔧 Custom Configuration

### Option 1: Quick OAuth Setup

Edit `.env` with your OAuth credentials:

```bash
# GitHub OAuth (optional)
GITHUB_CLIENT_ID=your-actual-github-client-id
GITHUB_CLIENT_SECRET=your-actual-github-client-secret

# Google OAuth (optional)  
GOOGLE_CLIENT_ID=your-actual-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-actual-google-client-secret
```

Then update secrets: `make realm-import`

### Option 2: Multiple Realms

Add any realm configuration to `config/realms/`:

```bash
# Import specific realm
make realm-import REALM=your-custom-realm.json

# Auto-detect and import first found
make realm-import
```

## 🩺 Troubleshooting

**Services won't start?**

```bash
make check-requirements  # Validate system
make logs                # Check error messages
```

**Can't access Keycloak?**

1. Verify containers: `docker ps`
2. Check ports: `lsof -i :8080` (Linux/Mac)
3. Try alternative: <http://127.0.0.1:8080>

**Need help?** Check the comprehensive [README.md](README.md) guide.

---

🎯 **Next Steps**: Configure OAuth credentials, add custom realms, or explore the [full documentation](README.md)!
