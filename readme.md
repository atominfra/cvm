
# CUDA Version Manager

### 1. Check Current CUDA Toolkit and PyTorch CUDA Versions

To check the versions currently installed:

```bash
./check-versions.sh
```

---

### 2. Find All Available PyTorch CUDA Versions

To list all the available PyTorch versions compatible with CUDA:

```bash
./find-torch-versions.sh
```

---

### 3. Steps to Update CUDA Toolkit Version

#### 3.1 Install CUDA Toolkit

```bash
./install-cuda.sh <cuda-version> 
# Example:
./install-cuda.sh 12.4.0
```

#### 3.2 Load CUDA Toolkit

```bash
./load-cuda.sh <cuda-version> 
# Example:
./load-cuda.sh 12.4.0
```

**Note:** After loading the CUDA toolkit, run the following command to apply the changes in the current shell:

```bash
source ~/.bashrc
```

---

### 4. Steps to Update PyTorch CUDA Version

To update PyTorch with a specific CUDA version:

```bash
./install-torch.sh <cuda-version>
# Example:
./install-torch.sh 12.4.0
```
