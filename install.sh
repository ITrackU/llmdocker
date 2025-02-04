#!/bin/bash

# Check if script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this installation script with sudo"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_PATH="/usr/local/bin/llmdocker"

# Create the executable script
echo "Creating llmdocker command..."
cat > "$BIN_PATH" << 'EOF'
#!/bin/bash

# Function to start the LLM service
start_service() {
    echo "Starting LLM service..."
    cd "$(dirname "$(readlink -f "$0")")/../../opt/llmdocker"
    
    # Start the services
    sudo docker-compose up -d
    
    echo "Verifying running containers..."
    sudo docker ps
    
    echo "LLM service is up and running!"
    echo "Open WebUI is available at http://localhost:8080"
}

# Function to stop the LLM service
stop_service() {
    echo "Stopping LLM service..."
    cd "$(dirname "$(readlink -f "$0")")/../../opt/llmdocker"
    sudo docker-compose down
    echo "LLM service has been stopped."
}

# Function to display usage information
usage() {
    echo "Usage: $0 --start | --stop"
    echo "  --start    Start the LLM service"
    echo "  --stop     Stop the LLM service"
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
EOF

# Make the script executable
chmod +x "$BIN_PATH"

# Verify the installation
if [ -f "$BIN_PATH" ]; then
    echo "Installation successful!"
    echo "The command 'llmdocker' is now available with the following options:"
    echo "  llmdocker --start   # Start the LLM service"
    echo "  llmdocker --stop    # Stop the LLM service"
else
    echo "Installation failed. Please check the error messages above."
fi
