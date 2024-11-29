#!/bin/bash

# Set the DEBIAN_FRONTEND to non-interactive to suppress any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker GPG key and repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Use 'yes' to automatically confirm the prompt
echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker and Docker Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-compose

# Add user to Docker group
sudo usermod -aG docker azureuser

# Clone repository and build Docker containers
git clone --branch QA https://github.com/Eshan-m/webgeeks.git
cd webgeeks

# Run Docker commands without using newgrp
# Run Docker Compose in the background without using newgrp
nohup sudo docker-compose up --build &>/dev/null &
