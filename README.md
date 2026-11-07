# Containerization-Demo

## Deployment Instructions
- Load up Docker Desktop
- Open a Bash terminal
- install packages via npm install

### Spin up container
- docker compose up -d

### Check running instances, assigned ports, and health status
- docker compose ps
- keep note of port

### Check non-root status
- docker exec lightweight-web-stack-web-1 whoami

### Verify final image is lean and correctly tagged
- docker images

### Check main page
- curl localhost:<port>

### Check health endpoint
- curl localhost:<port>/healthz

### Display dynamic information
- curl localhost:<port>/info

### Test Self healing
- curl localhost:<port>/crash
- docker compose ps

### Replicate 2 other containers
docker compose up  --scale web=3 -d

## AI Prompts
Prompt: I used a modified sample prompt
- Act as a senior DevOps and cloud infrastructure architect. I need to containerize and orchestrate a lightweight web application Node.js.

The deliverable must include:

A production-ready Dockerfile:
   - Uses a lightweight base image (e.g., Alpine or Distroless).

   - Implements a multi-stage build to keep the final image minimal.

   - Follows security best practices (e.g., runs as a non-root user, minimal layers, no cached package manager files).

   - Exposes a health check endpoint (/healthz).

An Orchestration Manifest:
   (Docker Compose): Multi-replica web service with CPU/memory limits, health checks, restart policies, and an environment file (.env).

Minimal Application Code:
   - A basic web server with a landing page, a health-check endpoint (/healthz), and an endpoint displaying server runtime metadata (e.g., hostname/container ID and uptime).

 

Provide the Dockerfile, the orchestration YAML files, the application code, and clear terminal commands to build, run, and scale the system.


## AI Analysis

Again, the AI did a pretty good job on the first attempt. I did not see any severe security issues or non-optimal shortcuts. I did require quite a bit of prompting to get a solution for the self-healing test.

Docker (and linux containers) is very finicky around causing a deliberate crash. It can either act like killing the container is deliberate and not regenerate a new one or will prevent the crash altogether. The correct solution was building an endpoint that would crash the container that accessed it.