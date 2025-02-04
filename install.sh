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
SERVICE_PATH="/etc/systemd/system/llmdocker.service"

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

# Create systemd service file
echo "Creating systemd service..."
cp "$SCRIPT_DIR/llmdocker.service" "$SERVICE_PATH"

# Set proper permissions for all files
chown -R root:root "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"
chmod 644 "$SERVICE_PATH"

# Reload systemd daemon and enable service
echo "Configuring systemd service..."
systemctl daemon-reload
systemctl enable llmdocker.service

# Verify the installation
if [ -f "$BIN_PATH" ] && [ -f "$INSTALL_DIR/docker-compose.yml" ] && [ -f "$SERVICE_PATH" ]; then
    echo "Installation successful!"
    echo "The command 'llmdocker' is now available with the following options:"
    echo "  llmdocker --start   # Start the LLM service"
    echo "  llmdocker --stop    # Stop the LLM service"
    echo ""
    echo "Docker Compose file installed in: $INSTALL_DIR"
    echo ""
    echo "Systemd service installed and enabled. You can use:"
    echo "  sudo systemctl start llmdocker   # Start the service"
    echo "  sudo systemctl stop llmdocker    # Stop the service"
    echo "  sudo systemctl status llmdocker  # Check service status"
    echo ""
    echo "The service will automatically start on system boot."
else
    echo "Installation failed. Please check the error messages above."
fi
