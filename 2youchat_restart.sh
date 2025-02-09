#!/bin/bash

# Check if Docker is installed
if ! docker --version > /dev/null 2>&1; then
    echo "Please install docker first! Press any key to exit..."
    pause
    exit 1
fi

# If docker-compose fails, try docker compose plugin
if docker compose --version > /dev/null 2>&1; then
    echo "Using docker compose plugin..."
    docker compose restart youchat_proxy
    echo "Restart complete! Press any key to exit..."
    exit 0
fi

# Try docker-compose first
if docker-compose --version > /dev/null 2>&1; then
    echo "Using docker-compose..."
    docker-compose  restart youchat_proxy
    echo "Restart complete! Press any key to exit..."
    exit 0
fi

# If both fail, show error message
echo "Please install docker-compose or docker compose plugin! Press any key to exit..."
pause
exit 1