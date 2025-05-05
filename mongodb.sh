#!/bin/bash

# Update package index
sudo apt update

# Import MongoDB public GPG key
echo "Importing MongoDB public GPG key..."
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo tee /etc/apt/trusted.gpg.d/mongodb-server-6.0.asc > /dev/null

# Create a MongoDB source list file
echo "Creating MongoDB source list file..."
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update package index to add the MongoDB repository
echo "Updating package index..."
sudo apt update

# Install MongoDB packages
echo "Installing MongoDB..."
sudo apt install -y mongodb-org

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod

# Enable MongoDB service to start on boot
echo "Enabling MongoDB to start on boot..."
sudo systemctl enable mongod

# Check MongoDB service status
echo "Checking MongoDB service status..."
sudo systemctl status mongod

echo "MongoDB installation and setup complete!"
