#!/bin/bash

# Function to get CUDA Toolkit version
get_cuda_version() {
    nvcc --version | grep "release" | awk '{print $6}' | sed 's/,//'
}

# Function to get PyTorch version
get_torch_version() {
    python -c "import torch; print(torch.__version__)"
}

# Function to get PyTorch CUDA version
get_torch_cuda_version() {
    python -c "import torch; print(torch.version.cuda)"
}

# Print versions
echo "CUDA Toolkit Version: $(get_cuda_version)"
echo "PyTorch Version: $(get_torch_version)"
echo "PyTorch CUDA Version: $(get_torch_cuda_version)"
