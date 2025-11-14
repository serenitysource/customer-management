#!/bin/bash

# Quick Start Scripts - Run everything in Docker

# Start all services
echo "Starting all services..."
docker-compose up -d

echo ""
echo "Services started!"
echo "Application: http://localhost:8000"
echo ""
echo "To view logs: docker-compose logs -f"
