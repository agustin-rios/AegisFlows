# AegisFlows IAM Service Makefile
# Provides convenient commands for development and production operations

.PHONY: help dev prod stop clean logs validate backup restore monitoring

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED    := \033[31m
GREEN  := \033[32m
YELLOW := \033[33m
BLUE   := \033[34m
RESET  := \033[0m

help: ## Show this help message
	@echo "$(BLUE)AegisFlows IAM Service$(RESET)"
	@echo "======================"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  $(YELLOW)make dev$(RESET)       - Start development environment"
	@echo "  $(YELLOW)make prod$(RESET)      - Start production environment"
	@echo "  $(YELLOW)make logs$(RESET)      - Show service logs"
	@echo "  $(YELLOW)make validate$(RESET)  - Validate configuration"

dev: ## Start development environment
	@echo "$(BLUE)Starting development environment...$(RESET)"
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)Creating .env from .env.example...$(RESET)"; \
		cp .env.example .env; \
	fi
	docker compose up -d
	@echo "$(GREEN)Development environment started!$(RESET)"
	@echo "Keycloak: http://localhost:8080"
	@echo "Credentials: admin/admin"

prod: ## Start production environment
	@echo "$(BLUE)Starting production environment...$(RESET)"
	@if [ ! -f .env.prod ]; then \
		echo "$(RED)Error: .env.prod file is required for production!$(RESET)"; \
		echo "Copy .env.prod.example to .env.prod and configure it."; \
		exit 1; \
	fi
	docker compose --profile prod -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo "$(GREEN)Production environment started!$(RESET)"

monitoring: ## Start with monitoring stack
	@echo "$(BLUE)Starting environment with monitoring...$(RESET)"
	docker compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
	@echo "$(GREEN)Environment with monitoring started!$(RESET)"
	@echo "Keycloak: http://localhost:8080"
	@echo "Prometheus: http://localhost:9090"
	@echo "Grafana: http://localhost:3000 (admin/admin)"

stop: ## Stop all services
	@echo "$(YELLOW)Stopping all services...$(RESET)"
	docker compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.monitoring.yml down
	@echo "$(GREEN)All services stopped!$(RESET)"

clean: ## Stop services and remove volumes (DATA LOSS!)
	@echo "$(RED)WARNING: This will delete all data!$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.monitoring.yml down -v --remove-orphans; \
		docker system prune -f; \
		echo "$(GREEN)Cleanup completed!$(RESET)"; \
	else \
		echo "$(YELLOW)Cleanup cancelled.$(RESET)"; \
	fi

logs: ## Show service logs
	@echo "$(BLUE)Showing service logs (press Ctrl+C to exit)...$(RESET)"
	docker compose logs -f

logs-keycloak: ## Show Keycloak logs only
	@echo "$(BLUE)Showing Keycloak logs (press Ctrl+C to exit)...$(RESET)"
	docker compose logs -f keycloak

logs-postgres: ## Show PostgreSQL logs only
	@echo "$(BLUE)Showing PostgreSQL logs (press Ctrl+C to exit)...$(RESET)"
	docker compose logs -f postgres

validate: ## Validate configuration and security
	@echo "$(BLUE)Validating configuration...$(RESET)"
	@./scripts/validate-config.sh

status: ## Show service status
	@echo "$(BLUE)Service Status:$(RESET)"
	@docker compose ps
	@echo ""
	@echo "$(BLUE)Resource Usage:$(RESET)"
	@docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"

health: ## Check service health
	@echo "$(BLUE)Checking service health...$(RESET)"
	@echo -n "PostgreSQL: "
	@if docker compose exec -T postgres pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB >/dev/null 2>&1; then \
		echo "$(GREEN)Healthy$(RESET)"; \
	else \
		echo "$(RED)Unhealthy$(RESET)"; \
	fi
	@echo -n "Keycloak: "
	@if curl -sf http://localhost:9000/health/ready >/dev/null 2>&1; then \
		echo "$(GREEN)Healthy$(RESET)"; \
	else \
		echo "$(RED)Unhealthy$(RESET)"; \
	fi

backup: ## Create database backup
	@echo "$(BLUE)Creating database backup...$(RESET)"
	@mkdir -p backups
	@BACKUP_FILE="backups/keycloak_backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker compose exec -T postgres pg_dump -U $$POSTGRES_USER $$POSTGRES_DB > $$BACKUP_FILE; \
	echo "$(GREEN)Backup created: $$BACKUP_FILE$(RESET)"

restore: ## Restore database from backup (requires BACKUP_FILE variable)
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "$(RED)Error: BACKUP_FILE variable is required$(RESET)"; \
		echo "Usage: make restore BACKUP_FILE=backups/keycloak_backup_20231201_120000.sql"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring database from $(BACKUP_FILE)...$(RESET)"
	@echo "$(RED)WARNING: This will overwrite the current database!$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose exec -T postgres psql -U $$POSTGRES_USER -d $$POSTGRES_DB < $(BACKUP_FILE); \
		echo "$(GREEN)Database restored successfully!$(RESET)"; \
	else \
		echo "$(YELLOW)Restore cancelled.$(RESET)"; \
	fi

rebuild: ## Rebuild Docker images
	@echo "$(BLUE)Rebuilding Docker images...$(RESET)"
	docker compose build --no-cache
	@echo "$(GREEN)Images rebuilt successfully!$(RESET)"

update: ## Update to latest images
	@echo "$(BLUE)Updating Docker images...$(RESET)"
	docker compose pull
	@echo "$(GREEN)Images updated successfully!$(RESET)"

install: ## Initial setup and installation
	@echo "$(BLUE)Setting up AegisFlows IAM Service...$(RESET)"
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)Creating .env from .env.example...$(RESET)"; \
		cp .env.example .env; \
		echo "$(YELLOW)Please review and modify .env file before starting services.$(RESET)"; \
	fi
	@echo "$(GREEN)Installation completed!$(RESET)"
	@echo "Next steps:"
	@echo "1. Review and modify .env file"
	@echo "2. Run 'make dev' to start development environment"
	@echo "3. Access Keycloak at http://localhost:8080"

uninstall: ## Remove all containers, images, and volumes
	@echo "$(RED)WARNING: This will completely remove AegisFlows and all data!$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.monitoring.yml down -v --remove-orphans; \
		docker images | grep -E "(keycloak|postgres)" | awk '{print $$3}' | xargs -r docker rmi -f; \
		echo "$(GREEN)AegisFlows completely removed!$(RESET)"; \
	else \
		echo "$(YELLOW)Uninstall cancelled.$(RESET)"; \
	fi

shell-keycloak: ## Open shell in Keycloak container
	@docker compose exec keycloak /bin/bash

shell-postgres: ## Open shell in PostgreSQL container
	@docker compose exec postgres /bin/bash

psql: ## Connect to PostgreSQL database
	@docker compose exec postgres psql -U $$POSTGRES_USER -d $$POSTGRES_DB