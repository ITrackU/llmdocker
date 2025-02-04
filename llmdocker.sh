#!/bin/bash

# Function to start the LLM service
start_service() {
    echo "Cloning or updating the repository..."
    if [ ! -d "/opt/llmdocker" ]; then
        sudo git clone https://github.com/ITrackU/llmdocker.git /opt/llmdocker
    else
        cd /opt/llmdocker && sudo git pull
    fi

    echo "Starting LLM service with Docker Compose..."
    cd /opt/llmdocker
    sudo docker-compose up -d

    echo "Verifying running containers..."
    sudo docker ps

    echo "LLM service is up and running!"
}

# Function to stop the LLM service
stop_service() {
    echo "Stopping LLM service..."
    cd /opt/llmdocker
    sudo docker-compose down

    echo "LLM service has been stopped."
}

# Function to display usage information
usage() {
    echo "Usage: $0 --start | --stop"
    echo "  --start   Start the LLM service"
    echo "  --stop    Stop the LLM service"
    exit 1
}

# Check for command-line arguments
if [ $# -eq 0 ]; then
    usage
fi

# Parse command-line arguments
case "$1" in
    --start)
        start_service
        ;;
    --stop)
        stop_service
        ;;
    *)
        usage
        ;;
esac
