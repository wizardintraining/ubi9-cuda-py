# Notes
- Runtime/devel images pulled from https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
- 12.1.1 is what is currently used by most runtimes, so will be main
- openblas-devel is not availble in ubi, investigating options for availibliy for llama-cpp and instructlab runtimes



## Manual builds - 
### Runtime
podman build -f Containerfile.runtime -t quay.io/stewhite/ubi9-cuda-py:0.0.1 -t quay.io/stewhite/ubi9-cuda-py:latest
podman push quay.io/stewhite/ubi9-cuda-py:0.0.1 quay.io/stewhite/ubi9-cuda-py:latest
### Devel
podman build -f Containerfile.devel -t quay.io/stewhite/ubi9-cuda-py:0.0.1-devel -t quay.io/stewhite/ubi9-cuda-py:latest-devel
podman push quay.io/stewhite/ubi9-cuda-py:0.0.1-devel quay.io/stewhite/ubi9-cuda-py:latest-devel

### vllm runtimes
podman build -f Containerfile.llamacpp -t quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest && podman push quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest
podman build -f Containerfile.ilab -t quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest && podman push quay.io/stewhite/ubi9-cuda-py:ilab-runtime-latest
podman build -f Containerfile.vllm-0.4.3 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.4.3 
podman build -f Containerfile.vllm-0.5.0 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.5.0 -t quay.io/stewhite/ubi9-cuda-py:vllm-runtime-latest
podman push quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.4.3 quay.io/stewhite/ubi9-cuda-py:vllm-runtime-0.5.0 quay.io/stewhite/ubi9-cuda-py:vllm-runtime-latest
### llama-cpp-py runtime
podman build -f Containerfile.llamacpp -t quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest
podman push quay.io/stewhite/ubi9-cuda-py:llamacpp-runtime-latest
### instructlab runtime


