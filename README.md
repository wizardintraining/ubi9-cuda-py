# UBI 9 based python images with CUDA runtime support
Enabling python s2i for codebases that require CUDA library support for GPU acceleration

includes support for nvtx cudart nccl cuDNN cublas

## Notes
- Runtime/devel images pulled from https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
- cuda 12.4.1 runtimes -- currently used by torch and most other libraries
- 12.6 compat package included
- instructlab install pulled from https://github.com/instructlab/instructlab/blob/main/containers/cuda/Containerfile


## Manual builds - 

 `export REPO="quay.io/stewhite/ubi9-cuda-py"` 
### Runtime
```sh
podman build -f Containerfile --target runtime -t ubi9-cuda-py
podman tag ubi9-cuda-py "$REPO":0.1.1 "$REPO":latest
podman push "$REPO":0.1.1
podman push "$REPO":latest
```
### Devel
```sh
podman build -f Containerfile --target builder -t ubi9-cuda-py:devel
podman tag ubi9-cuda-py:devel $REPO:0.1.1-devel $REPO:latest-devel
podman push $REPO:0.1.1-devel
podman push $REPO:latest-devel
```
### vllm runtimes
```sh
podman build -f Containerfile.vllm-0.5.5 -t $REPO:vllm-runtime-0.5.5
podman tag $REPO:vllm-runtime-0.5.5 $REPO:vllm-runtime-v0.5

podman build -f Containerfile.vllm-0.6.3 -t $REPO:vllm-runtime-0.6.3
podman build -f Containerfile.vllm-0.6.6.post1 -t $REPO:vllm-runtime-0.6.6
podman tag $REPO:vllm-runtime-0.6.6 $REPO:vllm-runtime-v0.6

podman build -f Containerfile.vllm-0.7.3 -t $REPO:vllm-runtime-0.7.3
podman tag $REPO:vllm-runtime-0.7.3 $REPO:vllm-runtime-v0.7
podman tag $REPO:vllm-runtime-0.7.3 $REPO:vllm-runtime-latest

for i in vllm-runtime-0.5.5 vllm-runtime-v0.5 vllm-runtime-0.6.3 vllm-runtime-0.6.6 vllm-runtime-v0.6 vllm-runtime-0.7.3 vllm-runtime-v0.7 vllm-runtime-latest; do
    podman push $REPO:${i}
done
```
### extra runtimes
```sh
podman build -f Containerfile.llamacpp -t $REPO:llamacpp-runtime-latest && \
 podman push $REPO:llamacpp-runtime-latest
```
~~ ```sh
 requires nvidia-container-tools
podman build --device nvidia.com/gpu=all -f Containerfile.ilab -t $REPO:ilab-runtime-latest && \
 podman push $REPO:ilab-runtime-latest
``` ~~
```sh
podman build -f Containerfile.nm-vllm -t $REPO:nm-vllm-runtime && \
 podman push $REPO:nm-vllm-runtime
```
```sh
podman build -f Containerfile.simple-vllm -t $REPO:runtime-simple-vllm && \
 podman push $REPO:runtime-simple-vllm
```
```sh
podman build -f Containerfile.vllm-native -t $REPO:vllm-passthough && \
 podman push $REPO:vllm-passthough
```
