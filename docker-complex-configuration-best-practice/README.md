# Complete Production-Ready Configuration System

a full working example 

## Key Features

✅ **Multi-layer config** - base → environment → env vars → secrets  
✅ **Validation** - YAML syntax + JSON schema validation  
✅ **Secrets management** - Never in config files, loaded at runtime  
✅ **Debug mode** - Print final config with secrets redacted  
✅ **Hot reload** - Mount config in dev for live changes  
✅ **Type safety** - Schema validation catches config errors early  
✅ **Production-ready** - External secrets, health checks, metrics  
✅ **Documentation** - Inline comments + README files  
✅ **Make targets** - One-command setup and deployment

with dev/prod environments

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── docker-compose.prod.yml
├── Makefile
├── .env.example
├── .gitignore
├── entrypoint.sh
├── config/
│   ├── base.yml
│   ├── development.yml
│   ├── production.yml
│   ├── config.schema.json
│   └── README.md
├── secrets/
│   ├── .gitkeep
│   └── README.md
└── app/
    ├── server.js
    ├── config-loader.js
    └── package.json
```

## About Makefile

Provides convenient commands for managing a Docker-based application with complex configuration
- Environment Setup (setup, secrets)
- Development Workflow (dev, dev-daemon, debug)
- Production Deployment (prod, build-prod, push-prod)
- Container Management (stop, clean, logs)
- Development Tools (shell, db-shell, redis-cli, test)
- Configuration Validation (validate)
- Help System (help)

## Usage Guide

### Development Setup

```bash
# 1. Clone and setup
git clone <repo>
cd myapp
make setup

# 2. Start development environment
make dev

# 3. Access services
# App: http://localhost:3000
# Metrics: http://localhost:9090/metrics
# Health: http://localhost:8080/health
# Jaeger UI: http://localhost:16686
```

### Production Deployment

```bash
# 1. Create external secrets (Docker Swarm example)
echo "prod_password" | docker secret create db_password -
echo "prod_jwt_secret" | docker secret create jwt_secret -
echo "sk_live_stripe_key" | docker secret create stripe_api_key -

# 2. Create .env.production (not in repo)
cat > .env.production <<EOF
ENVIRONMENT=production
DB_HOST=prod-db.example.com
REDIS_HOSTS=redis-1:6379,redis-2:6379,redis-3:6379
LOG_LEVEL=info
RATE_LIMIT_ENABLED=true
EOF

# 3. Deploy
docker stack deploy -c docker-compose.prod.yml myapp
```

### Direct Docker Run (without Compose)

```bash
# Build
docker build -t myapp:1.0.0 .

# Run with env file and secrets
docker run -d \
  --name myapp \
  --env-file .env \
  -e ENVIRONMENT=production \
  -v /path/to/secrets/db_password:/run/secrets/db_password:ro \
  -v /path/to/secrets/jwt_secret:/run/secrets/jwt_secret:ro \
  -p 3000:3000 \
  myapp:1.0.0
```

### Useful Commands

```bash
make help          # Show all available commands
make validate      # Validate config files
make debug         # Start with config debug output
make shell         # Open shell in container
make logs          # Tail application logs
make secrets       # Generate new dev secrets
```
