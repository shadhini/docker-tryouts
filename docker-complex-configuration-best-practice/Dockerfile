FROM node:18-alpine AS base

# Install runtime dependencies for templating and validation
RUN apk add --no-cache \
    bash \
    gettext \
    yq \
    && npm install -g ajv-cli

WORKDIR /app

# Copy package files
COPY app/package*.json ./
RUN npm ci --production

# Copy configuration templates and schema
COPY config/ /app/config/

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy application code
COPY app/ /app/

# Create directory for final config
RUN mkdir -p /app/runtime

ENV NODE_ENV=production
ENV CONFIG_PATH=/app/runtime/config.yml

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["node", "server.js"]

# Development stage with hot-reload support
FROM base AS development
RUN npm install
ENV NODE_ENV=development
