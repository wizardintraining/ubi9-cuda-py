FROM registry.access.redhat.com/ubi9/python-311 as runtime

###################################################################################################
# CUDA 12.4 Layer, from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.4.1 #
###################################################################################################

# Base
USER 0

ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=12.4 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526 brand=tesla,driver>=535,driver<536 brand=unknown,driver>=535,driver<536 brand=nvidia,driver>=535,driver<536 brand=nvidiartx,driver>=535,driver<536 brand=geforce,driver>=535,driver<536 brand=geforcertx,driver>=535,driver<536 brand=quadro,driver>=535,driver<536 brand=quadrortx,driver>=535,driver<536 brand=titan,driver>=535,driver<536 brand=titanrtx,driver>=535,driver<536"
ENV NV_CUDA_CUDART_VERSION 12.4.127-1
ENV NV_CUDNN_VERSION 9.1.0.70-1
ENV NV_CUDNN_PACKAGE libcudnn9-cuda-12-${NV_CUDNN_VERSION}
ENV NV_CUDA_LIB_VERSION 12.4.1-1
ENV NV_NVTX_VERSION 12.4.127-1
ENV NV_LIBNPP_VERSION 12.2.5.30-1
ENV NV_LIBNPP_PACKAGE libnpp-12-4-${NV_LIBNPP_VERSION}
ENV NV_LIBCUBLAS_VERSION 12.4.5.8-1
ENV NV_LIBNCCL_PACKAGE_NAME libnccl
ENV NV_LIBNCCL_PACKAGE_VERSION 2.21.5-1
ENV NV_LIBNCCL_VERSION 2.21.5
ENV NCCL_VERSION 2.21.5
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}-${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.4
ENV NVIDIA_PRODUCT_NAME CUDA

COPY cuda.repo-x86_64 /etc/yum.repos.d/cuda.repo

RUN NVIDIA_GPGKEY_SUM=d0664fbbdb8c32356d45de36c5984617217b2d0bef41b93ccecd326ba3b80c87 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel9/${NVARCH}/D42D0685.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

ENV CUDA_VERSION 12.4.1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN dnf upgrade --security --best --nodocs --setopt=install_weak_deps=False -y \
    && dnf install -y --nodocs --setopt=install_weak_deps=False \
    openblas \
    openblas-serial \
    cuda-cudart-12-4-${NV_CUDA_CUDART_VERSION} \
    cuda-compat-12-4 \
    ${NV_CUDNN_PACKAGE} \
    cuda-libraries-12-4-${NV_CUDA_LIB_VERSION} \
    cuda-nvtx-12-4-${NV_NVTX_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    libcublas-12-4-${NV_LIBCUBLAS_VERSION} \
    ${NV_LIBNCCL_PACKAGE} \
    cuda-compat-12-6 \
    && ln -s cuda-12.4 /usr/local/cuda \
    && dnf -y clean all --enablerepo='*' && \
    rm -rf /var/cache/yum/* && \
    find /var/log -type f -name "*.log" -exec rm -f {} \;

# nvidia-docker 1.0
RUN echo "/usr/local/cuda/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs

COPY NGC-DL-CONTAINER-LICENSE /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Runtime

# Upgrade setuptools and fix file permissions
RUN python3 -m venv --upgrade-deps ${APP_ROOT} \
    && chmod -R g+w "${APP_ROOT}"/lib{,64}/python3.$(python3 --version | cut -d '.' -f2)/site-packages \
    && /usr/bin/fix-permissions /opt/app-root -P
WORKDIR /opt/app-root/src
USER 1001


# CUDA Devel image
FROM runtime as builder

USER 0

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

ENV NV_NVPROF_VERSION 12.4.127-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-12-4-${NV_NVPROF_VERSION}
ENV NV_CUDA_CUDART_DEV_VERSION 12.4.127-1
ENV NV_NVML_DEV_VERSION 12.4.127-1
ENV NV_LIBCUBLAS_DEV_VERSION 12.4.5.8-1
ENV NV_LIBNPP_DEV_VERSION 12.2.5.30-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-devel-12-4-${NV_LIBNPP_DEV_VERSION}
ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-devel
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.21.5-1
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}-${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda12.4
ENV NV_CUDA_NSIGHT_COMPUTE_VERSION 12.4.1-1
ENV NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE cuda-nsight-compute-12-4-${NV_CUDA_NSIGHT_COMPUTE_VERSION}

RUN dnf install -y --best --nodocs --setopt=install_weak_deps=False \
    make \
    openblas-devel \
    cuda-command-line-tools-12-4-${NV_CUDA_LIB_VERSION} \
    cuda-libraries-devel-12-4-${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-12-4-${NV_CUDA_LIB_VERSION} \
    cuda-cudart-devel-12-4-${NV_CUDA_CUDART_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    cuda-nvml-devel-12-4-${NV_NVML_DEV_VERSION} \
    libcublas-devel-12-4-${NV_LIBCUBLAS_DEV_VERSION} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    ${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE} \
    && dnf clean all \
    && rm -rf /var/cache/yum/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

#############################################
# End of CUDA 12.4 dev Layer                    #
#############################################

USER 1001
