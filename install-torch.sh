#!/bin/bash

# Setup PIP

sudo apt-get install python3-pip
pip3 install --upgrade pip

# Check if CUDA version is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <cuda-version> (e.g., 12.6.1)"
    exit 1
fi

CUDA_VERSION=$1

#xy
CUDA_VERSION_TYPE_C=$(echo $CUDA_VERSION | cut -d '.' -f1,2 | tr -d '.')
echo $CUDA_VERSION_TYPE_C

pip3 uninstall -y torch 
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu${CUDA_VERSION_TYPE_C}
