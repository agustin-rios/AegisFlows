# Dynamic Realm Configuration

This directory contains clean realm templates for AegisFlows IAM platform.

## Files

- `*.json` - Clean realm templates without secrets (safe for git)

## Usage

Import realm configuration (auto-detects first JSON file):
```bash
make realm-import
```

Import specific realm configuration:
```bash
make realm-import REALM=zmart.json
./scripts/realm-import.sh zmart.json
```

## Import Process

The dynamic import system:
1. **Auto-detects** realm configuration from JSON files
2. **Extracts** realm name from the JSON configuration
3. **Imports** the clean template without secrets
4. **Updates** OAuth provider secrets via Keycloak Admin API
5. **Configures** client secrets through API calls

## Environment Variables

All secrets are sourced from environment variables in `.env` file:
- `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET` - GitHub OAuth
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` - Google OAuth  
- `FRONTEND_CLIENT_ID`, `FRONTEND_SECRET` - Application clients

The system supports any realm name and configuration!
