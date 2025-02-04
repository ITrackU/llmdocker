#!/bin/bash

# Check if script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this installation script with sudo"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_PATH="/usr/local/bin/llmdocker"

# Copy the llmdocker script to /usr/local/bin
echo "Installing llmdocker command..."
cat "$SCRIPT_DIR/llmdocker" > "$BIN_PATH"

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
