
# CUDA Version Manager

### 1. Check Current CUDA Toolkit and PyTorch CUDA Versions

```bash
./check-versions.sh
```

---

### 2. Find All Available PyTorch CUDA Versions

```bash
./find-torch-versions.sh
```

---

### 3. Steps to Update CUDA Toolkit Version

#### 3.1 Install CUDA Toolkit

```bash
./install-cuda.sh <cuda-version>
```

**Example:**

```bash
./install-cuda.sh 12.4.0
```

#### 3.2 Load CUDA Toolkit

```bash
./load-cuda.sh <cuda-version>
```

**Example:**

```bash
./load-cuda.sh 12.4.0
```

**Note:** After loading the CUDA toolkit, run:

```bash
source ~/.bashrc
```
to apply the changes in the current shell.

---

### 4. Steps to Update PyTorch CUDA Version

```bash
./install-torch.sh <cuda-version>
```

**Example:**

```bash
./install-torch.sh 12.4.0
```
