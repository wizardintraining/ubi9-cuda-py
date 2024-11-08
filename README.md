# UBI 9 based python images with CUDA runtime support
Enabling python s2i for codebases that require CUDA library support for GPU acceleration

includes support for nvtx cudart nccl cuDNN and *some* support for cublas
  - openblas-devel not availble in ubi, so only runtime libs are avalible; dev image does not have required libs to build against it

## Notes
- Runtime/devel images pulled from https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
- cuda 12.4.1 runtimes -- currently used by torch and most other libraries
- 12.6 compat package included
- still investigating options for availibliy openblas-devel for ubi; llama-cpp and instructlab runtimes certainly affected by this



## Manual builds - 
### Runtime
podman build -f Containerfile.runtime -t quay.io/stewhite/ubi9-cuda-py:0.1.0 -t quay.io/stewhite/ubi9-cuda-py:latest
podman push quay.io/stewhite/ubi9-cuda-py:0.1.0 quay.io/stewhite/ubi9-cuda-py:latest
### Devel
podman build -f Containerfile.devel -t quay.io/stewhite/ubi9-cuda-py:0.1.0-devel -t quay.io/stewhite/ubi9-cuda-py:latest-devel
podman push quay.io/stewhite/ubi9-cuda-py:0.1.0-devel quay.io/stewhite/ubi9-cuda-py:latest-devel

### vllm runtimes
podman build -f Containerfile.vllm-0.5.5 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.5.5 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.5
podman build -f Containerfile.vllm-0.6.3 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.6.3 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.6 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-latest
podman push quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.5.5 \
    quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.5 \
    quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.6.3 \
    quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.6 \
    quay.io/stewhite/ubi9-cuda-py:vllm-runtime-latest
### extra runtimes
podman build -f Containerfile.llamacpp -t quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest && \
 podman push quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest
podman build -f Containerfile.ilab -t quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest && \
 podman push quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest
