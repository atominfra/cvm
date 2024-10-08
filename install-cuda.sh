#!/bin/bash

# Function to handle errors
error_exit() {
    echo "Error: $1"
    exit 1
}

# Function to check if jq is installed
check_jq() {
    if command -v jq > /dev/null 2>&1; then
        echo "jq is already installed."
    else
        echo "jq is not installed. Installing..."
        install_jq
    fi
}

# Function to install jq
install_jq() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Debian/Ubuntu
        if command -v apt-get > /dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y jq
        # For Red Hat/CentOS
        elif command -v yum > /dev/null 2>&1; then
            sudo yum install -y jq
        # For Arch Linux
        elif command -v pacman > /dev/null 2>&1; then
            sudo pacman -S jq
        else
            echo "Package manager not found. Please install jq manually."
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS
        if command -v brew > /dev/null 2>&1; then
            brew install jq
        else
            echo "Homebrew is not installed. Please install jq manually."
        fi
    else
        echo "Unsupported OS. Please install jq manually."
    fi
}

# Run the check
check_jq


# Add this to your .bashrc or .zshrc
function red() {
    echo -e "\e[31m$1\e[0m"
}

# Function to perform a GET request with a customizable error message
http_get() {
    local url="$1"
    local response
    local status_code

    # Make the curl request
    response=$(curl -s -w "%{http_code}" -o /tmp/curl_response "$url")

    # Extract the HTTP status code
    status_code="${response: -3}"
    # Extract the HTTP response body
    http_body=$(< /tmp/curl_response)

    # Check if the response is not in the 2xx range
    if [[ $status_code -lt 200 || $status_code -ge 300 ]]; then
        return 1  # Return non-zero for error
    fi

    echo "$http_body"
    return 0  # Return zero for success
}


# Check if CUDA version is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <cuda-version> (e.g., 12.6.1)"
    exit 1
fi

if [[ ! "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "<cuda-version> must be in format x.y.z"
fi

CUDA_VERSION=$1

# Get OS version details from /etc/os-release
source /etc/os-release

DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')$(lsb_release -rs | tr -d '.')

# x.y.z
CUDA_VERSION_TYPE_A=$CUDA_VERSION

# x-y
CUDA_VERSION_TYPE_B=$(echo $CUDA_VERSION | sed 's/\./-/;s/\..*//')

ARCH=$(uname -m)

# Set ARCH_TYPE_B based on the ARCH value
if [[ "$ARCH" == "amd64" || "$ARCH" == "x86_64" ]]; then
    ARCH_TYPE_B="amd64"
else
    ARCH_TYPE_B="arm64"  # Use "arm64" for 64-bit ARM; change to "armhf" for 32-bit ARM if needed
fi

# Get the NVIDIA driver version for the CUDA version
NVIDIA_CUDA_JSON=$(http_get "https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/version_${CUDA_VERSION}.json") 

if [ $? -ne 0 ]; then
    red "CUDA version ${CUDA_VERSION} is not available for ${DISTRO} ${ARCH}"
    exit 1
fi

NVIDIA_DRIVER_VERSION=$(echo "$NVIDIA_CUDA_JSON" | jq -r '.nvidia_driver.version')

# Download and install the necessary files
wget https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/cuda-${DISTRO}.pin || error_exit "Failed to download cuda-${DISTRO}.pin"
sudo mv cuda-${DISTRO}.pin /etc/apt/preferences.d/cuda-repository-pin-600 || error_exit "Failed to move cuda-${DISTRO}.pin"

wget https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_${ARCH_TYPE_B}.deb || error_exit "Failed to download cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_${ARCH_TYPE_B}.deb"
sudo dpkg -i cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_${ARCH_TYPE_B}.deb || error_exit "Failed to install cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local_${CUDA_VERSION_TYPE_A}-${NVIDIA_DRIVER_VERSION}-1_${ARCH_TYPE_B}.deb"

# Move the keyring
sudo cp /var/cuda-repo-${DISTRO}-${CUDA_VERSION_TYPE_B}-local/cuda-*-keyring.gpg /usr/share/keyrings/ || error_exit "Failed to move CUDA keyring to /usr/share/keyrings/"

# Update the package list and install CUDA without user input
sudo apt-get update -y || error_exit "Failed to update package list during CUDA installation"
sudo apt-get -y install "cuda-${CUDA_VERSION_TYPE_B}" || error_exit "Failed to install CUDA version ${CUDA_VERSION_TYPE_B}"

echo "CUDA ${CUDA_VERSION} installation complete!"
