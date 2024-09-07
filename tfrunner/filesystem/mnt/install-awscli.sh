#!/bin/bash

echo "Updating package lists and installing AWS CLI using apt..."

apt update

apt install python3-pip -y

# Install AWS CLI
pip install awscli --break-system-packages

# Check AWS CLI version
aws --version
