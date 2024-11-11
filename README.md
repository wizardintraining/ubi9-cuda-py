# UBI 9 based python images with CUDA runtime support
Enabling python s2i for codebases that require CUDA library support for GPU acceleration

includes support for nvtx cudart nccl cuDNN cublas

## Notes
- Runtime/devel images pulled from https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
- cuda 12.4.1 runtimes -- currently used by torch and most other libraries
- 12.6 compat package included
- instructlab install pulled from https://github.com/instructlab/instructlab/blob/main/containers/cuda/Containerfile


## Manual builds - 
### Runtime
```sh
podman build -f Containerfile.runtime -t quay.io/stewhite/ubi9-cuda-py:0.1.0 -t quay.io/stewhite/ubi9-cuda-py:latest
podman push quay.io/stewhite/ubi9-cuda-py:0.1.0
podman push quay.io/stewhite/ubi9-cuda-py:latest
```
### Devel
```sh
podman build -f Containerfile.devel -t quay.io/stewhite/ubi9-cuda-py:0.1.0-devel -t quay.io/stewhite/ubi9-cuda-py:latest-devel
podman push quay.io/stewhite/ubi9-cuda-py:0.1.0-devel
podman push quay.io/stewhite/ubi9-cuda-py:latest-devel
```
### vllm runtimes
```sh
podman build -f Containerfile.vllm-0.5.5 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.5.5 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.5
podman build -f Containerfile.vllm-0.6.3 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.6.3 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-v0.6 \
    -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-latest
for i in vllm-runtime-0.5.5 vllm-runtime-v0.5 vllm-runtime-0.6.3 vllm-runtime-v0.6 vllm-runtime-latest; do
    podman push quay.io/stewhite/ubi9-cuda-py:${i}
done
```
### extra runtimes
```sh
podman build -f Containerfile.llamacpp -t quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest && \
 podman push quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest
```
```sh
podman build -f Containerfile.ilab -t quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest && \
 podman push quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest
```
