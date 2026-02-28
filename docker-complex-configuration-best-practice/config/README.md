# Configuration Guide

## Configuration Layers

The application uses a **4-layer configuration system**:

1. **Base config** (`base.yml`) - Defaults for all environments
2. **Environment config** (`development.yml`, `production.yml`) - Environment-specific overrides
3. **Environment variables** - Runtime values (hosts, ports, flags)
4. **Secrets** - Sensitive values from `/run/secrets` or secret manager

Layers are merged in order, with later layers overriding earlier ones.

## Environment Variables

All `${VAR_NAME}` placeholders in config files are substituted from environment variables at container startup.

### Variable Naming Convention

- Use UPPERCASE with underscores: `DB_HOST`, `REDIS_PORT`
- Group by component: `DB_*`, `REDIS_*`, `SERVER_*`
- Provide defaults where sensible: `${LOG_LEVEL:-info}`

### Required Variables

The following environment variables **must** be set:

**Database:**
- `DB_HOST` - Database hostname
- `DB_PASSWORD` - Database password (from secret)

**API:**
- `JWT_SECRET` - JWT signing secret (from secret)

**External Services (if used):**
- `STRIPE_API_KEY`, `SENDGRID_API_KEY`, etc.

## Secrets Management

**NEVER** put secrets in:
- Config files (even with placeholders)
- `.env` files committed to git
- Docker build args

**DO** use:
- Docker secrets: `/run/secrets/secret-name`
- Mounted files with restricted permissions
- External secret managers (Vault, AWS Secrets Manager)

Secrets are loaded as environment variables by `entrypoint.sh` and injected at runtime.

## Schema Validation

The `config.schema.json` file defines the expected structure and types. Validation runs automatically at container startup.

To validate manually:
```bash
yq eval -o=json config/base.yml | ajv validate -s config/config.schema.json -d -
```

## Debugging

Enable debug output:
```bash
docker-compose run -e DEBUG_CONFIG=true app
```

This prints the final configuration with secrets redacted.

## Adding New Config Values

1. Add to `base.yml` with `${VAR_NAME:-default}` syntax
2. Add environment-specific overrides to `development.yml` / `production.yml` if needed
3. Update `config.schema.json` with validation rules
4. Document in this README
5. Add to `.env.example`