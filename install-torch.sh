#!/bin/bash

source utils/http-get.sh
source utils/red.sh

# Check if CUDA version is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <cuda-version> (e.g., 12.6.1)"
    exit 1
fi

# Setup PIP

# Detect the package manager
if [ -f /etc/debian_version ]; then
    # For Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y python3-pip
elif [ -f /etc/redhat-release ]; then
    # For Red Hat/CentOS/Fedora
    sudo yum install -y python3-pip || sudo dnf install -y python3-pip
elif [ -f /etc/arch-release ]; then
    # For Arch Linux
    sudo pacman -S python-pip --noconfirm
elif [ -f /etc/alpine-release ]; then
    # For Alpine Linux
    sudo apk add --update python3 py3-pip
else
    echo "Unsupported distribution. Please install Python3-pip manually."
    exit 1
fi

# Upgrade pip
pip3 install --upgrade pip

CUDA_VERSION=$1

#xy
CUDA_VERSION_TYPE_C=$(echo $CUDA_VERSION | cut -d '.' -f1,2 | tr -d '.')
echo $CUDA_VERSION_TYPE_C

http_get "https://download.pytorch.org/whl/cu${CUDA_VERSION_TYPE_C}/torch_stable.html"

if [ $? -ne 0 ]; then
    red "CUDA version $CUDA_VERSION is not available."
    exit 1
fi

pip3 uninstall -y torch 
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu${CUDA_VERSION_TYPE_C}
