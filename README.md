# LLM Docker

A streamlined setup for running a local Large Language Model (LLM) server using Ollama with Open WebUI. This project provides an easy-to-use systemd service that manages the Docker containers and offers a web interface for interacting with various LLM models.

## Architecture

The project consists of two dockers main services:

1. **Ollama**: A lightweight LLM server that runs models
   - Supports GPU acceleration
   - Runs in an isolated container
   - Data persistence through Docker volumes
   - Internal network access only

2. **Open WebUI**: A user-friendly web interface for Ollama
   - Modern, responsive interface
   - Access to all Ollama features
   - Exposed on port 8080
   - Automatic reconnection to Ollama

## Prerequisites

- Linux system with systemd
- Docker and Docker Compose installed
- Git (for cloning the repository)
- Sudo privileges
- (Optional) NVIDIA GPU with appropriate drivers for acceleration

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ITrackU/llmdocker.git
cd llmdocker
```

2. Run the installation script:
```bash
chmod +x ./install.sh
sudo ./install.sh
```

The installation script will:
- Create the `/opt/llmdocker` directory
- Install the `llmdocker` command in `/usr/local/bin`
- Set up the systemd service
- Configure Docker volumes and networks

## Usage

### Service Management

The LLM service is managed through systemd:

```bash
# Start the service
sudo systemctl start llmdocker

# Stop the service
sudo systemctl stop llmdocker

# Check service status
sudo systemctl status llmdocker

# Enable auto-start on boot
sudo systemctl enable llmdocker

# Disable auto-start on boot
sudo systemctl disable llmdocker
```

### Command Line Interface

The `llmdocker` command is available for manual control (service has to be stopped for proper use):

```bash
# Start the services
llmdocker --start

# Stop the services
llmdocker --stop
```

### Accessing the Interface

Once running, access the Open WebUI at:
```
http://localhost:8080
```

## File Structure

```
/opt/llmdocker/
├── docker-compose.yml   # Docker services configuration
└── volumes/            # Docker volumes (created automatically)
    ├── ollama/        # Ollama model storage
    └── webui/         # WebUI data and settings
```

## Configuration

### Docker Compose

The `docker-compose.yml` file defines two services:

1. Ollama service:
   - Uses official Ollama image
   - GPU access enabled
   - Internal network only
   - Persistent volume for models

2. Open WebUI service:
   - Uses latest Open WebUI image
   - Connected to Ollama via internal network
   - Exposed on port 8080
   - Persistent volume for settings

### Network Security

- Ollama server is not exposed externally
- Only the WebUI is accessible on port 8080
- Services communicate via internal Docker network

### Volume Management

Two named volumes are created:
- `llm_ollama_data`: Stores downloaded models
- `llm_webui_data`: Stores WebUI configuration

## Troubleshooting

1. **Service won't start**
   - Check Docker daemon status: `systemctl status docker`
   - Verify port 8080 is available: `netstat -tuln | grep 8080`
   - Check logs: `journalctl -u llmdocker`

2. **Cannot access WebUI**
   - Ensure service is running: `systemctl status llmdocker`
   - Check container status: `docker ps`
   - Verify network connectivity: `curl localhost:8080`

3. **GPU not detected**
   - Verify NVIDIA drivers: `nvidia-smi`
   - Check Docker GPU support: `docker run --gpus all nvidia/cuda:11.0-base nvidia-smi`

## Uninstallation

To remove the installation:

```bash
# Stop and disable the service
sudo systemctl stop llmdocker
sudo systemctl disable llmdocker

# Remove files
sudo rm /usr/local/bin/llmdocker
sudo rm /etc/systemd/system/llmdocker.service
sudo rm -rf /opt/llmdocker

# Remove Docker volumes (optional)
docker volume rm llm_ollama_data llm_webui_data
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
