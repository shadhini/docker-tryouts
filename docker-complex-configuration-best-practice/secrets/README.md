# Secrets Directory

This directory is for **local development secrets only**.

## Setup for Development

Create these files locally (they are gitignored):

```bash
echo "dev_db_password_123" > secrets/db_password
echo "dev_jwt_secret_xyz" > secrets/jwt_secret
echo "sk_test_stripe_key" > secrets/stripe_api_key
chmod 600 secrets/*
```

## Production

**NEVER** store production secrets in files committed to git.

Use Docker secrets:
```bash
echo "prod_password" | docker secret create db_password -
docker stack deploy -c docker-compose.prod.yml myapp
```

Or mount from external secret manager.
