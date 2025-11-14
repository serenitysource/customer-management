#!/bin/bash

# Development mode with hot reload
echo "Starting development mode with hot reload..."
echo ""

# Start database and app
docker-compose up -d db app

echo "Starting Vite dev server for hot reload..."
docker-compose run --rm --service-ports node npm run dev
