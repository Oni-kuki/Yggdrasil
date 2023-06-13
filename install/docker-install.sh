#!/bin/bash

VERSION="2.18.1"

# Function to display errors
display_error() {
    echo "an error has occurred : $1"
    exit 1
}

echo "Docker..."
if ! command -v docker &>/dev/null; then
    # Installation docker
    echo "Docker Installation..."
    if ! curl -fsSL https://get.docker.com -o get-docker.sh; then
        display_error "Failed to download Docker."
    fi
    if ! sh get-docker.sh; then
        echo "Failed to install Docker."
        if [ -f "get-docker.sh" ]; then 
            rm "get-docker.sh"
        fi
        # If the OS is Arch linux
        echo "Specifique installation if the OS are Arch linux..."
        if ! pacman -Sy --noconfirm docker; then
            display_error "Failed to install Docker for Arch Linux."
        fi
        # Start Docker service
        if ! systemctl start docker; then
            display_error "Failed to start Docker."
        echo "Docker has been installed successfully for Arch linux."
        fi
    else
        echo "Docker has been installed successfully."
    fi
else
    echo "Docker is already installed"
        if ! systemctl start docker; then
        display_error "But Failed to start Docker."
        fi
        echo "Docker has been started"  
fi

# Installation docker-compose
echo "Docker Compose installation..."
ARCH=$(uname -m)
if ! command -v docker-compose &>/dev/null; then
    # If Docker-Compose is not already installed
    if ! curl -fsSL -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/v${VERSION}/docker-compose-linux-${ARCH} ; then
        display_error "Failed to download Docker Compose."
    fi
    if ! chmod +x /usr/local/bin/docker-compose; then
        display_error "Failed to set permissions for Docker Compose."
    fi
    echo "Docker Compose has been successfully installed."
else
    echo "Docker Compose is already installed."
fi
