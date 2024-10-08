# Cuda Version Manager

## Check Current Versions

```sh
./check-versions.sh 
```

## Steps to Update Cuda Version for Development

### 1. Install Cuda

```sh
./install-cuda.sh <cuda-version> (e.g., 12.4.0)
```

### 2. Load Cuda

```sh
./load-cuda.sh <cuda-version> (e.g., 12.4.0)
```

Note: Run `source ~/.bashrc` for the changes to reflect in current shell

### 3. Install Torch

```sh
./install-torch.sh <cuda-version> (e.g., 12.4.0)
```
