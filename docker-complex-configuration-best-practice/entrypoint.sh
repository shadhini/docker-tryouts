#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
ENVIRONMENT=${ENVIRONMENT:-development}
CONFIG_DIR=/app/config
RUNTIME_DIR=/app/runtime
FINAL_CONFIG=${CONFIG_PATH:-${RUNTIME_DIR}/config.yml}
DEBUG_CONFIG=${DEBUG_CONFIG:-false}
VALIDATE_CONFIG=${VALIDATE_CONFIG:-true}

log_info "Starting configuration initialization for environment: ${ENVIRONMENT}"

# Create runtime directory
mkdir -p ${RUNTIME_DIR}

# Step 1: Start with base configuration
log_info "Layer 1: Loading base configuration"
if [ ! -f "${CONFIG_DIR}/base.yml" ]; then
    log_error "Base configuration not found at ${CONFIG_DIR}/base.yml"
    exit 1
fi
cp "${CONFIG_DIR}/base.yml" "${FINAL_CONFIG}"

# Step 2: Merge environment-specific configuration
log_info "Layer 2: Merging ${ENVIRONMENT} configuration"
ENV_CONFIG="${CONFIG_DIR}/${ENVIRONMENT}.yml"
if [ -f "${ENV_CONFIG}" ]; then
    # Merge using yq (layer 2 overrides layer 1)
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
        "${FINAL_CONFIG}" "${ENV_CONFIG}" > "${RUNTIME_DIR}/temp.yml"
    mv "${RUNTIME_DIR}/temp.yml" "${FINAL_CONFIG}"
else
    log_warn "No environment-specific config found at ${ENV_CONFIG}, using base only"
fi

# Step 3: Load secrets into environment (never write to config file)
log_info "Layer 3: Loading secrets from /run/secrets"
if [ -d "/run/secrets" ]; then
    for secret_file in /run/secrets/*; do
        if [ -f "$secret_file" ]; then
            secret_name=$(basename "$secret_file")
            secret_value=$(cat "$secret_file")
            # Convert to uppercase ENV var name
            env_var_name=$(echo "$secret_name" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
            export "$env_var_name"="$secret_value"
            log_info "Loaded secret: $secret_name -> \$${env_var_name}"
        fi
    done
fi

# Step 4: Apply environment variable substitution
log_info "Layer 4: Applying environment variable substitution"
# Create a temp file with substituted values
envsubst < "${FINAL_CONFIG}" > "${RUNTIME_DIR}/temp.yml"
mv "${RUNTIME_DIR}/temp.yml" "${FINAL_CONFIG}"

# Step 5: Validate configuration
if [ "${VALIDATE_CONFIG}" = "true" ]; then
    log_info "Validating configuration syntax and schema"

    # Validate YAML syntax
    if ! yq eval "${FINAL_CONFIG}" > /dev/null 2>&1; then
        log_error "Invalid YAML syntax in final configuration"
        cat "${FINAL_CONFIG}"
        exit 1
    fi

    # Validate against JSON schema if available
    if [ -f "${CONFIG_DIR}/config.schema.json" ]; then
        # Convert YAML to JSON for schema validation
        yq eval -o=json "${FINAL_CONFIG}" > "${RUNTIME_DIR}/config.json"

        if ! ajv validate -s "${CONFIG_DIR}/config.schema.json" -d "${RUNTIME_DIR}/config.json" --strict=false 2>&1; then
            log_error "Configuration failed schema validation"
            exit 1
        fi
        log_info "Schema validation passed"
    else
        log_warn "No schema file found, skipping schema validation"
    fi
fi

# Step 6: Debug output (with secrets redacted)
if [ "${DEBUG_CONFIG}" = "true" ]; then
    log_info "=== Final Configuration (secrets redacted) ==="
    yq eval '
        .database.password = "***REDACTED***" |
        .redis.password = "***REDACTED***" |
        .api.secret_key = "***REDACTED***" |
        .external.api_keys = "***REDACTED***"
    ' "${FINAL_CONFIG}"
    echo ""
fi

# Step 7: Validate required environment variables
log_info "Checking required environment variables"
REQUIRED_VARS=()

# Check if any required vars are missing (add your required vars here)
# Example: REQUIRED_VARS=("DB_HOST" "REDIS_HOST" "API_PORT")
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        log_error "Required environment variable is not set: $var"
        exit 1
    fi
done

log_info "Configuration initialization complete"
log_info "Final config location: ${FINAL_CONFIG}"
echo ""

# Execute the main application command
log_info "Starting application: $*"
exec "$@"
