#!/bin/bash

# Check if CUDA version is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <cuda-version> (e.g., 12.6.1)"
    exit 1
fi

CUDA_VERSION=$1

# Get OS version details from /etc/os-release
source /etc/os-release

DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')$(lsb_release -rs | tr -d '.')

# x.y.z
CUDA_VERSION_TYPE_A=$CUDA_VERSION
echo $CUDA_VERSION_TYPE_A

# x-y
CUDA_VERSION_TYPE_B=$(echo $CUDA_VERSION | sed 's/\./-/;s/\..*//')
echo $CUDA_VERSION_TYPE_B

ARCH=$(uname -m)

# Get the NVIDIA driver version for the CUDA version
NVIDIA_DRIVER_VERSION=$(curl -s https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/version_${CUDA_VERSION}.json | jq -r '.nvidia_driver.version')

# Download and install the necessary files
wget https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/cuda-${DISTRO}.pin
sudo mv cuda-${DISTRO}.pin /etc/apt/preferences.d/cuda-repository-pin-600

wget https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_amd64.deb
sudo dpkg -i cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_amd64.deb

# Move the keyring
sudo cp /var/cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local/cuda-*-keyring.gpg /usr/share/keyrings/

# Update the package list and install CUDA without user input
sudo apt-get update -y
sudo apt-get -y install "cuda-${CUDA_VERSION_TYPE_B}"

echo "CUDA ${CUDA_VERSION} installation complete!"
