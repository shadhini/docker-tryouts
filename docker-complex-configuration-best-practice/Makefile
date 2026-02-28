.PHONY: help setup dev prod clean logs validate secrets

# Colors
GREEN  := \033[0;32m
YELLOW := \033[1;33m
NC     := \033[0m

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${GREEN}%-15s${NC} %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Initial setup for development
	@echo "${GREEN}Setting up development environment...${NC}"
	@mkdir -p secrets
	@if [ ! -f .env ]; then cp .env.example .env; echo "${YELLOW}Created .env from .env.example${NC}"; fi
	@if [ ! -f secrets/db_password ]; then echo "dev_db_password_$$(openssl rand -hex 8)" > secrets/db_password; fi
	@if [ ! -f secrets/jwt_secret ]; then echo "dev_jwt_secret_$$(openssl rand -hex 16)" > secrets/jwt_secret; fi
	@if [ ! -f secrets/stripe_api_key ]; then echo "sk_test_dev_key" > secrets/stripe_api_key; fi
	@chmod 600 secrets/*
	@echo "${GREEN}Setup complete!${NC}"
	@echo "Generated secrets in ./secrets/ (local dev only)"

dev: setup ## Start development environment
	docker-compose up --build

dev-daemon: setup ## Start development environment in background
	docker-compose up --build -d

prod: ## Start production environment (requires external secrets)
	docker-compose -f docker-compose.prod.yml up --build

stop: ## Stop all containers
	docker-compose down

clean: ## Remove all containers, volumes, and generated files
	docker-compose down -v
	rm -rf runtime/
	@echo "${YELLOW}Kept secrets/ directory - remove manually if needed${NC}"

logs: ## Tail application logs
	docker-compose logs -f app

logs-all: ## Tail all service logs
	docker-compose logs -f

validate: ## Validate configuration files
	@echo "${GREEN}Validating base configuration...${NC}"
	@yq eval config/base.yml > /dev/null && echo "✓ base.yml syntax OK" || echo "✗ base.yml has errors"
	@yq eval config/development.yml > /dev/null && echo "✓ development.yml syntax OK" || echo "✗ development.yml has errors"
	@yq eval config/production.yml > /dev/null && echo "✓ production.yml syntax OK" || echo "✗ production.yml has errors"
	@echo "${GREEN}Validating against schema...${NC}"
	@docker run --rm -v $$(pwd)/config:/config node:18-alpine sh -c "npm install -g ajv-cli && yq eval -o=json /config/base.yml | ajv validate -s /config/config.schema.json -d -"

secrets: ## Generate new development secrets
	@echo "${GREEN}Generating new development secrets...${NC}"
	@mkdir -p secrets
	@echo "dev_db_password_$$(openssl rand -hex 8)" > secrets/db_password
	@echo "dev_jwt_secret_$$(openssl rand -hex 16)" > secrets/jwt_secret
	@echo "sk_test_$$(openssl rand -hex 12)" > secrets/stripe_api_key
	@chmod 600 secrets/*
	@echo "${GREEN}Secrets generated in ./secrets/${NC}"

debug: setup ## Start with debug configuration output
	DEBUG_CONFIG=true docker-compose up --build

shell: ## Open shell in running app container
	docker-compose exec app /bin/bash

db-shell: ## Open PostgreSQL shell
	docker-compose exec postgres psql -U postgres -d myapp

redis-cli: ## Open Redis CLI
	docker-compose exec redis redis-cli

test: ## Run tests
	docker-compose run --rm app npm test

build-prod: ## Build production image
	docker build --target base -t myapp:$$(cat VERSION 2>/dev/null || echo "latest") .

push-prod: build-prod ## Build and push production image
	docker push myapp:$$(cat VERSION 2>/dev/null || echo "latest")
