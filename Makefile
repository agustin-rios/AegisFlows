# AegisFlows - Dynamic IAM Management
# Optimized, robust automation scripts for identity management

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help dev prod start stop restart status logs clean setup test backup restore realm-import realm-export health check-requirements build rebuild validate security-check

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

# Environment detection
ENV ?= dev
COMPOSE_PROFILE := $(ENV)
COMPOSE_CMD := docker compose --profile $(COMPOSE_PROFILE)

## Help and Information
help: ## Show this comprehensive help message
	@echo -e "$(CYAN)AegisFlows - Dynamic IAM Management$(NC)"
	@echo -e "$(CYAN)======================================$(NC)"
	@echo ""
	@echo -e "$(YELLOW)Available Commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}' | \
		sort

check-requirements: ## Check system requirements and dependencies
	@echo -e "$(BLUE)🔍 Checking system requirements...$(NC)"
	@./scripts/check-requirements.sh

## Environment Management
dev: ## Switch to development environment and start services
	@echo -e "$(BLUE)� Starting development environment...$(NC)"
	@ENV=dev $(MAKE) start

prod: ## Switch to production environment and start services  
	@echo -e "$(BLUE)🚀 Starting production environment...$(NC)"
	@ENV=prod $(MAKE) start

## Core Service Management
start: check-requirements ## Start all services with environment detection
	@echo -e "$(GREEN)🚀 Starting AegisFlows IAM ($(ENV) mode)...$(NC)"
	@$(COMPOSE_CMD) up -d
	@echo -e "$(GREEN)✅ Services started successfully!$(NC)"
	@./scripts/post-startup.sh $(ENV)

stop: ## Stop all services gracefully
	@echo -e "$(YELLOW)🛑 Stopping services gracefully...$(NC)"
	@$(COMPOSE_CMD) down
	@echo -e "$(GREEN)✅ Services stopped!$(NC)"

restart: ## Restart all services with health checks
	@echo -e "$(YELLOW)🔄 Restarting services...$(NC)"
	@$(MAKE) stop
	@sleep 3
	@$(MAKE) start

## Monitoring and Diagnostics
status: ## Show detailed service status and health
	@echo -e "$(BLUE)📊 Service Status ($(ENV) environment):$(NC)"
	@$(COMPOSE_CMD) ps
	@echo ""
	@./scripts/health-check.sh

health: ## Comprehensive health check with detailed output
	@echo -e "$(BLUE)🏥 Running comprehensive health checks...$(NC)"
	@./scripts/health-check.sh --detailed

logs: ## Show aggregated service logs
	@echo -e "$(BLUE)📋 Showing service logs (Ctrl+C to exit):$(NC)"
	@$(COMPOSE_CMD) logs -f

logs-keycloak: ## Show Keycloak logs only
	@echo -e "$(BLUE)🔑 Keycloak logs ($(ENV) mode):$(NC)"
	@$(COMPOSE_CMD) logs -f keycloak-$(ENV)

logs-postgres: ## Show PostgreSQL logs only  
	@echo -e "$(BLUE)🐘 PostgreSQL logs:$(NC)"
	@$(COMPOSE_CMD) logs -f postgres

## Build and Deployment
build: ## Build Docker images
	@echo -e "$(BLUE)🔨 Building Docker images...$(NC)"
	@$(COMPOSE_CMD) build

rebuild: ## Force rebuild Docker images without cache
	@echo -e "$(BLUE)🔨 Force rebuilding Docker images...$(NC)"
	@$(COMPOSE_CMD) build --no-cache

## Data Management
backup: ## Create full backup of database and configuration
	@echo -e "$(BLUE)💾 Creating backup...$(NC)"
	@./scripts/backup.sh

restore: ## Restore from backup (requires BACKUP_FILE parameter)
	@echo -e "$(BLUE)📥 Restoring from backup...$(NC)"
	@./scripts/restore.sh $(BACKUP_FILE)

## Keycloak Realm Management
realm-import: ## Import realm configuration (auto-detects or specify: make realm-import REALM=filename.json)
	@echo -e "$(BLUE)📥 Importing realm configuration...$(NC)"
	@./scripts/realm-import.sh $(REALM)

realm-export: ## Export current realm configuration
	@echo -e "$(BLUE)📤 Exporting realm configuration...$(NC)"
	@./scripts/realm-export.sh

## Setup and Initialization
setup: ## Complete initial setup with realm import
	@echo -e "$(PURPLE)🏪 Setting up AegisFlows IAM platform...$(NC)"
	@$(MAKE) start
	@./scripts/wait-for-services.sh
	@$(MAKE) realm-import
	@echo -e "$(GREEN)✅ AegisFlows IAM is ready!$(NC)"
	@./scripts/display-info.sh $(ENV)

## Testing and Validation
test: ## Run comprehensive test suite
	@echo -e "$(BLUE)🧪 Running test suite...$(NC)"
	@./scripts/test-suite.sh

validate: ## Validate configuration and security settings
	@echo -e "$(BLUE)✅ Validating configuration...$(NC)"
	@./scripts/validate-config.sh

security-check: ## Run security audit and checks
	@echo -e "$(BLUE)🔒 Running security audit...$(NC)"
	@./scripts/security-check.sh

## Maintenance and Cleanup
clean: ## Remove containers, volumes, and perform cleanup
	@echo -e "$(YELLOW)🧹 Cleaning up resources...$(NC)"
	@$(COMPOSE_CMD) down -v --remove-orphans
	@docker system prune -f --volumes
	@echo -e "$(GREEN)✅ Cleanup complete!$(NC)"

clean-all: ## Deep clean including images and build cache
	@echo -e "$(RED)🗑️  DANGER: Deep cleaning all Docker resources...$(NC)"
	@read -p "Are you sure? This will remove ALL Docker images and build cache [y/N]: " confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			$(COMPOSE_CMD) down -v --rmi all --remove-orphans; \
			docker system prune -af --volumes; \
			echo -e "$(GREEN)✅ Deep cleanup complete!$(NC)"; \
		else \
			echo -e "$(YELLOW)❌ Deep cleanup cancelled$(NC)"; \
		fi

## Development Utilities
shell-keycloak: ## Open shell in Keycloak container
	@echo -e "$(BLUE)🐚 Opening shell in Keycloak container...$(NC)"
	@$(COMPOSE_CMD) exec keycloak-$(ENV) /bin/bash

shell-postgres: ## Open shell in PostgreSQL container  
	@echo -e "$(BLUE)🐚 Opening shell in PostgreSQL container...$(NC)"
	@$(COMPOSE_CMD) exec postgres /bin/bash

psql: ## Connect to PostgreSQL database
	@echo -e "$(BLUE)🐘 Connecting to PostgreSQL...$(NC)"
	@$(COMPOSE_CMD) exec postgres psql -U postgres -d iam_db

## Information and Documentation
info: ## Display service information and access URLs
	@./scripts/display-info.sh $(ENV)

version: ## Show component versions
	@echo -e "$(BLUE)📋 Component Versions:$(NC)"
	@echo "Keycloak: $(shell docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' quay.io/keycloak/keycloak:26.1.2 2>/dev/null || echo '26.1.2')"
	@echo "PostgreSQL: $(shell docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' postgres:15-alpine 2>/dev/null || echo '15-alpine')"
	@echo "Docker: $(shell docker --version | cut -d' ' -f3 | sed 's/,//')"
	@echo "Docker Compose: $(shell docker compose version --short 2>/dev/null || echo 'Unknown')"

## Advanced Operations
performance: ## Show performance metrics and resource usage
	@echo -e "$(BLUE)📈 Performance Metrics:$(NC)"
	@./scripts/performance-monitor.sh

monitor: ## Start monitoring dashboard (if available)
	@echo -e "$(BLUE)📊 Starting monitoring...$(NC)"
	@./scripts/start-monitoring.sh

update: ## Update to latest container images
	@echo -e "$(BLUE)⬆️  Updating container images...$(NC)"
	@$(COMPOSE_CMD) pull
	@$(MAKE) restart