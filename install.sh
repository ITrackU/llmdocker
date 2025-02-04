#!/bin/bash

# Check if script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this installation script with sudo"
    exit 1
fi

# Define paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_PATH="/usr/local/bin/llmdocker"
INSTALL_DIR="/opt/llmdocker"

# Create installation directory if it doesn't exist
echo "Creating installation directory..."
mkdir -p "$INSTALL_DIR"

# Copy docker-compose.yml to installation directory
echo "Installing docker-compose.yml..."
cp "$SCRIPT_DIR/docker-compose.yml" "$INSTALL_DIR/"

# Copy the llmdocker script to /usr/local/bin
echo "Installing llmdocker command..."
cat "$SCRIPT_DIR/llmdocker" > "$BIN_PATH"

# Make the script executable
chmod +x "$BIN_PATH"

# Set proper permissions for the installation directory
chown -R root:root "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"

# Verify the installation
if [ -f "$BIN_PATH" ] && [ -f "$INSTALL_DIR/docker-compose.yml" ]; then
    echo "Installation successful!"
    echo "The command 'llmdocker' is now available with the following options:"
    echo "  llmdocker --start   # Start the LLM service"
    echo "  llmdocker --stop    # Stop the LLM service"
    echo ""
    echo "Docker Compose file installed in: $INSTALL_DIR"
else
    echo "Installation failed. Please check the error messages above."
fi
