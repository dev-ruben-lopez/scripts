#!/bin/bash

set -e

# Update package database
echo "Updating package database..."
sudo apt update

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker
if command_exists docker; then
    echo "Docker is already installed. Skipping Docker installation."
else
    echo "Installing Docker..."

    # Install required packages
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the Docker repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the package database again
    sudo apt update

    # Install Docker
    sudo apt install -y docker-ce

    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add user to the docker group
    sudo usermod -aG docker $USER
fi

# Install K3s
if command_exists k3s; then
    echo "K3s is already installed. Skipping K3s installation."
else
    echo "Installing K3s..."

    # Download and install K3s
    curl -sfL https://get.k3s.io | sh -

    # Verify K3s installation
    sudo systemctl status k3s || { echo "K3s installation failed"; exit 1; }
fi

# Verify Docker installation
docker --version || { echo "Docker installation failed"; exit 1; }

# Verify K3s installation
sudo k3s kubectl get nodes || { echo "K3s installation verification failed"; exit 1; }

# Configure kubectl alias
if ! grep -q 'alias kubectl="sudo k3s kubectl"' ~/.bashrc; then
    echo 'alias kubectl="sudo k3s kubectl"' >> ~/.bashrc
    source ~/.bashrc
fi

echo "Docker and K3s installation completed successfully. Please log out and log back in to apply Docker group changes."
