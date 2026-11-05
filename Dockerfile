# -----------------------------------
# Stage 1: Build & Dependencies
# -----------------------------------
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Copy only package manifests first to leverage Docker layer caching
COPY package*.json ./

# Install production dependencies only using clean install
# npm ci is strict, requires package-lock.json, and is faster for CI/CD
RUN npm ci --only=production && npm cache clean --force

# Copy application source code
COPY server.js ./

# -----------------------------------
# Stage 2: Production Runtime
# -----------------------------------
FROM node:20-alpine

# Set Node to production mode to optimize framework performance (e.g., Express caching)
ENV NODE_ENV=production

WORKDIR /usr/src/app

# Copy only the necessary artifacts from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/server.js ./
COPY --from=builder /usr/src/app/package.json ./

# Bind to the non-root 'node' user provided by the base image
USER node

# Expose the application port
EXPOSE 3000

# Docker-level health check bridging to our application endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/healthz || exit 1

# Execute the application
CMD ["node", "server.js"]