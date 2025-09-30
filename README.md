# AegisFlows - Dynamic IAM Management

A robust, enterprise-grade Identity and Access Management platform with **dynamic realm support**. Built for flexibility, security, and ease of use.

## 🚀 Quick Start

```bash
# Complete setup from zero
make setup

# Or step by step
make check-requirements  # Validate system
make start               # Start services  
make realm-import        # Import realm configuration

# Access the system
# - Keycloak Admin: http://localhost:8080/admin (admin/admin)
# - Auto-detected Realm: http://localhost:8080/realms/{detected-realm-name}
```

## ✨ What You Get

- **🔥 Dynamic Realm System**: Works with ANY realm configuration - no hardcoding!
- **🛡️ Keycloak 26.1.2**: Latest stable version with PostgreSQL backend
- **🔐 API-Based Security**: OAuth secrets managed via Keycloak Admin API
- **⚡ Enterprise Automation**: 40+ Makefile commands for all operations
- **🎯 Multi-Environment**: Dev/Prod profiles with health monitoring
- **📊 Professional Tooling**: Comprehensive logging, backup, and monitoring

## 🎯 Dynamic Realm Features

### **Zero Hardcoding**: 
- Auto-detects realm configuration from JSON files
- Extracts realm name dynamically from configuration
- Works with ANY realm name - `zmart`, `aegis-test`, `your-company`, etc.

### **Smart Import System**:
- `make realm-import` - Auto-detects first realm config
- `make realm-import REALM=filename.json` - Import specific realm
- `./scripts/realm-import.sh --help` - Full usage documentation

### **API-Based Security**:
- OAuth secrets injected via Keycloak Admin API (not files!)
- GitHub/Google OAuth provider configuration
- Client secrets managed securely

## 📋 System Requirements

Automatically validated with `make check-requirements`:

- Docker 20.10+ with Docker Compose
- 4GB+ RAM (recommended)
- 5GB+ available disk space  
- Internet connectivity for image pulls
- Ports 8080, 9000, 5432 available

## 🚦 Getting Started

### 1. Clone & Setup

```bash
git clone https://github.com/agustin-rios/AegisFlows.git
cd AegisFlows
make setup  # Complete zero-to-ready setup
```

### 2. Configure OAuth Providers (Optional)

Edit `.env` with your OAuth credentials:

```bash
# GitHub OAuth Configuration
GITHUB_CLIENT_ID=your-actual-github-client-id
GITHUB_CLIENT_SECRET=your-actual-github-client-secret

# Google OAuth Configuration  
GOOGLE_CLIENT_ID=your-actual-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-actual-google-client-secret
```

### 3. Environment Variables Reference

Core configuration in `.env`:

```bash
# Database Configuration
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=iam_db

# Keycloak Admin Configuration  
KC_BOOTSTRAP_ADMIN_USERNAME=admin
KC_BOOTSTRAP_ADMIN_PASSWORD=admin

# OAuth Providers (set your real values)
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret

# Application Secrets (Realm-agnostic)
FRONTEND_CLIENT_ID=your-frontend-client-id
FRONTEND_SECRET=your-secure-frontend-secret
```

⚠️ **Important**: Change default passwords in production environments.

### 4. Access Your System

After `make setup` completes:

**Keycloak Admin Console**: http://localhost:8080/admin  
**Default Credentials**: admin / admin

**Your Realm**: http://localhost:8080/realms/{detected-realm-name}  
**Account Console**: http://localhost:8080/realms/{detected-realm-name}/account

## 🛠️ Comprehensive Command Reference

Our enterprise-grade Makefile includes 40+ commands organized by category:

### 🚀 Core Operations

```bash
make help                    # Show all available commands with descriptions
make setup                   # Complete zero-to-ready setup
make start                   # Start services with environment detection
make stop                    # Stop all services gracefully  
make restart                 # Restart services with health checks
make clean                   # Stop and remove all data (⚠️ DATA LOSS!)
```

### 🔧 Environment Management

```bash
make dev                     # Switch to development environment
make prod                    # Switch to production environment
make check-requirements      # Validate system requirements
make performance             # Show performance metrics
```

### 🏰 Realm Management (Dynamic)

```bash
make realm-import                        # Auto-detect and import first realm
make realm-import REALM=filename.json    # Import specific realm config
make realm-export                        # Export current realm configuration
```

### 📊 Monitoring & Logs

```bash
make status                  # Show service status and health
make logs                    # View logs from all services
make logs-keycloak          # View Keycloak logs only
make logs-postgres          # View PostgreSQL logs only
make follow-logs            # Follow logs in real-time
```

### 💾 Database Operations

```bash
make backup                           # Create database backup
make restore BACKUP_FILE=file.sql     # Restore from backup
make psql                            # Connect to PostgreSQL shell
make shell-postgres                  # Open shell in PostgreSQL container
```

### 🔐 Security & Maintenance

```bash
make security-check         # Run security audit
make update-secrets         # Update OAuth secrets via API
make validate-config        # Validate configuration files
```

### 🐳 Direct Docker Commands (Advanced)

```bash
# View logs directly
docker compose logs -f

# Stop services  
docker compose down

# Stop and remove data
docker compose down -v

# Restart specific service
docker compose restart iam-keycloak-dev
```

## 🏗️ Architecture Overview

### **Dynamic IAM Platform**

```text
┌─────────────────────────────────────────────────────┐
│                 AegisFlows Platform                 │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────┐    ┌─────────────────────────┐ │
│  │  Keycloak 26.1.2│◄──►│   PostgreSQL 15-Alpine │ │
│  │                 │    │                         │ │
│  │  HTTP: 8080     │    │    Database: iam_db     │ │
│  │  MGMT: 9000     │    │    Port: 5432           │ │
│  └─────────────────┘    └─────────────────────────┘ │
│                                                     │
│  ┌─────────────────────────────────────────────────┐ │
│  │              Dynamic Realm System               │ │
│  │                                                 │ │
│  │  • Auto-detects realm configurations           │ │
│  │  • API-based OAuth secret management           │ │
│  │  • Multi-realm support                         │ │
│  │  • Environment-agnostic operation              │ │
│  └─────────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### **Port Configuration**

- **🌐 8080**: Keycloak HTTP (Admin Console + Realm APIs)
- **⚙️ 9000**: Keycloak Management (Health, Metrics)  
- **🗄️ 5432**: PostgreSQL Database (Optional direct access)

### **Security Model**

- **🔐 API-First**: OAuth secrets managed via Keycloak Admin API
- **🛡️ No Secrets in Files**: Clean realm templates without credentials
- **🔄 Dynamic Configuration**: Runtime secret injection
- **📋 Environment Variables**: Secure credential management

## ⚙️ Advanced Configuration

### 🚀 Production Mode

Activate production profile for optimized deployment:

```bash
make prod  # Uses production-optimized configuration
```

Production checklist:

- ✅ Configure SSL/TLS certificates and reverse proxy
- ✅ Set secure environment variables and passwords  
- ✅ Define resource limits and monitoring
- ✅ Establish database backup strategy
- ✅ Review security settings and firewall rules

### 🎨 Customization Options

**Dynamic Realm Configuration**:

- Add any `*.json` realm config to `config/realms/`
- Use `make realm-import REALM=your-config.json`
- System auto-detects realm name and configures endpoints

**OAuth Provider Setup**:

- GitHub: Configure OAuth App and set `GITHUB_CLIENT_ID/SECRET`
- Google: Configure OAuth 2.0 credentials and set `GOOGLE_CLIENT_ID/SECRET`
- Secrets are injected via API (never stored in files)

**Custom Themes**:

- Place custom themes in `themes/` directory
- Themes are automatically mounted to Keycloak container

**Database Customization**:

- Edit `scripts/init-db.sh` for custom database setup
- Use `make psql` for direct database access

## 🏥 Health Monitoring

Comprehensive health checking system:

**Automated Health Checks**:

- **PostgreSQL**: `pg_isready` connection validation
- **Keycloak**: Management endpoint `/health` on port 9000
- **System**: `make status` for complete service overview

**Monitoring Integration**:

```bash
make health              # Complete health audit
make performance         # Resource usage metrics  
make security-check      # Security vulnerability scan
```

## 🩺 Troubleshooting Guide

### ❌ Keycloak Won't Start

1. **Check Prerequisites**: `make check-requirements`
2. **Verify Database**: `make status` (PostgreSQL should be healthy)
3. **Review Logs**: `make logs-keycloak`
4. **Memory Check**: Ensure 4GB+ RAM available

### 🌐 Can't Access localhost:8080

1. **Container Status**: `docker ps` (look for iam-keycloak-dev)
2. **Port Conflicts**: `lsof -i :8080` (Linux/Mac) or `netstat -ano | findstr :8080` (Windows)
3. **Alternative URL**: Try `http://127.0.0.1:8080`
4. **Firewall**: Check local firewall settings

### 🗄️ Database Connection Issues

1. **PostgreSQL Health**: `make status` 
2. **Environment Variables**: Verify `.env` configuration
3. **Network**: `docker network ls` (look for iam-network)
4. **Restart Services**: `make restart`

### 🔐 Realm Import Failures

1. **Configuration**: `./scripts/realm-import.sh --help`
2. **JSON Validation**: Ensure realm JSON is valid
3. **OAuth Credentials**: Check `GITHUB_CLIENT_ID/SECRET` in `.env`
4. **Manual Import**: Use Keycloak admin console as fallback

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the project
2. **Create** your feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow existing code style and patterns
- Update documentation for any new features
- Test changes with `make check-requirements` and `make setup`
- Ensure dynamic realm system compatibility

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 📚 Additional Resources

- **[Keycloak Documentation](https://www.keycloak.org/documentation)** - Official Keycloak guides
- **[Keycloak Admin REST API](https://www.keycloak.org/docs-api/22.0.5/rest-api/)** - API reference for automation
- **[PostgreSQL 15 Documentation](https://www.postgresql.org/docs/15/)** - Database configuration
- **[Docker Compose Reference](https://docs.docker.com/compose/)** - Container orchestration
- **[OAuth 2.0 & OIDC](https://oauth.net/2/)** - Authentication protocols

## 👨‍💻 Contact & Support

**Agustin Rios** - [@agustin-rios](https://github.com/agustin-rios)

**Project Repository**: [https://github.com/agustin-rios/AegisFlows](https://github.com/agustin-rios/AegisFlows)

**Issues & Feature Requests**: Use GitHub Issues for bug reports and feature requests

---

⭐ **Star this repo** if you find AegisFlows useful for your IAM needs!
