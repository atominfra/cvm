# Cuda Version Manager

## Check Current Cuda Toolkit and PyTorch Cuda Versions

```sh
./check-versions.sh 
```

## Find all available PyTorch Cuda Versions

```sh
./find-torch-versions.sh
```

## Steps to Update Cuda Toolkit Version

1. Install Cuda Toolkit
```sh
./install-cuda.sh <cuda-version> (e.g., 12.4.0)
```

2. Load Cuda Toolkit

```sh
./load-cuda.sh <cuda-version> (e.g., 12.4.0)
```

Note: Run `source ~/.bashrc` for the changes to reflect in current shell

## Steps to Update PyTorch CUDA Version

```sh
./install-torch.sh <cuda-version> (e.g., 12.4.0)
```
