#!/bin/bash

# Check if CUDA version is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <cuda-version> (e.g., 12.6.1)"
  exit 1
fi

CUDA_VERSION=$(echo $1 | cut -d '.' -f 1,2)
MODULE_DIR="/usr/share/modules/modulefiles/cuda"
MODULE_FILE="$MODULE_DIR/$CUDA_VERSION"
CUDA_ROOT="/usr/local/cuda-$CUDA_VERSION"  # Dynamically generate CUDA_ROOT based on version

# Check if the requested CUDA version directory exists
if [ ! -d "$CUDA_ROOT" ]; then
  echo "Error: CUDA version $CUDA_VERSION does not exist at $CUDA_ROOT."
  exit 1
fi

# Create the module directory if it doesn't exist
if [ ! -d "$MODULE_DIR" ]; then
  echo "Creating module directory at $MODULE_DIR"
  sudo mkdir -p "$MODULE_DIR"
fi

# Check if the module file already exists
if [ ! -f "$MODULE_FILE" ]; then
  echo "Creating module file for CUDA $CUDA_VERSION"
else
  echo "Module file for CUDA $CUDA_VERSION already exists. Overriding it."
fi

# Install prerequisites for modules if they are not installed
if ! command -v module &> /dev/null; then
  echo "Installing prerequisites for environment modules..."

  # For Debian/Ubuntu
  if [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y environment-modules
  # For CentOS/RHEL
  elif [ -f /etc/redhat-release ]; then
    sudo yum install -y environment-modules
  else
    echo "Unsupported operating system. Please install environment modules manually."
    exit 1
  fi
else
  echo "Environment modules are already installed."
fi

# Write the module file contents
sudo bash -c "cat > $MODULE_FILE" <<EOL
#%Module1.0
##
## cuda $CUDA_VERSION modulefile
##

proc ModulesHelp { } {
    global version
    puts stderr "\tSets up environment for CUDA \$version\n"
}

module-whatis "Sets up environment for CUDA $CUDA_VERSION"

# Unload any currently loaded CUDA version
if { [ is-loaded cuda ] } {
  module unload cuda
}

set version $CUDA_VERSION
set root /usr/local/cuda-\$version
setenv CUDA_HOME \$root

prepend-path PATH \$root/bin
prepend-path LD_LIBRARY_PATH \$root/extras/CUPTI/lib64
prepend-path LD_LIBRARY_PATH \$root/lib64
conflict cuda
EOL

echo "Module file for CUDA $CUDA_VERSION created successfully."

# Unload any currently loaded CUDA version before loading the new one
if module list 2>&1 | grep -q cuda; then
  echo "Unloading currently loaded CUDA module..."
  module unload cuda
fi

# Load the newly created CUDA module
echo "Loading CUDA $CUDA_VERSION module..."
module load cuda/$CUDA_VERSION

# Persist the CUDA module load in .bashrc
if ! grep -q "module load cuda" ~/.bashrc; then
  echo "Adding 'module load cuda/$CUDA_VERSION' to your .bashrc to persist across sessions."
  echo "module load cuda/$CUDA_VERSION" >> ~/.bashrc
else
  echo "Updating .bashrc with the new CUDA version."
  sed -i "/module load cuda/c\module load cuda/$CUDA_VERSION" ~/.bashrc
fi

# Source .bashrc to apply the changes in the current shell
echo "Please run 'source ~/.bashrc' for the changes to take effect."
