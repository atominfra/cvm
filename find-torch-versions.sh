#!/bin/bash

# Step 1: Fetch the HTML content from the PyTorch wheel directory
URL="https://download.pytorch.org/whl/torch/"
HTML=$(curl -s "$URL")

# Step 2: Extract CUDA versions using a refined pattern to match `+cuXYZ` in the .whl filenames
CUDA_VERSIONS=$(echo "$HTML" | grep -oP '\+cu\K\d{2,3}' | sort -u)

# Step 3: Function to convert CUDA versions from `xy` or `xyz` format to `x.y` format
format_version() {
    local version=$1
    if [[ ${#version} -eq 2 ]]; then  # If it's like '90', convert to '9.0'
        echo "${version:0:1}.${version:1}"
    elif [[ ${#version} -eq 3 ]]; then  # If it's like '100', convert to '10.0'
        echo "${version:0:2}.${version:2}"
    fi
}

# Step 4: Store formatted versions for sorting
formatted_versions=()
for version in $CUDA_VERSIONS; do
    formatted_version=$(format_version "$version")
    formatted_versions+=("$formatted_version")
done

# Step 5: Sort the versions numerically
sorted_versions=$(printf '%s\n' "${formatted_versions[@]}" | sort -V)

# Step 6: Display the CUDA versions
echo "Available Cuda Versions: "
echo "$sorted_versions"
