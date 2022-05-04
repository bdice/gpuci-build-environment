ARG FROM_IMAGE=gpuci/miniforge-cuda
ARG CUDA_VER=11.0
ARG LINUX_VER=centos7
FROM ${FROM_IMAGE}:${CUDA_VER}-devel-${LINUX_VER}

# Required arguments
ARG RAPIDS_VER=0.15
ARG PYTHON_VER=3.7

# Optional arguments
ARG GCC9_URL=https://gpuci.s3.us-east-2.amazonaws.com/builds/gcc9.tgz
ARG BINUTILS_DIR=/usr/local/binutils

# Capture argument used for FROM
ARG CUDA_VER

# Update environment for gcc/g++ builds
ENV GCC9_DIR=/usr/local/gcc9
ENV CC=${GCC9_DIR}/bin/gcc
ENV CXX=${GCC9_DIR}/bin/g++
ENV CUDAHOSTCXX=${GCC9_DIR}/bin/g++
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=${GCC9_DIR}/lib64:$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
ENV PATH=${GCC9_DIR}/bin:${BINUTILS_DIR}/bin:/usr/lib64/openmpi/bin:$PATH
ENV NVCC=/usr/local/cuda/bin/nvcc
ENV CUDAToolkit_ROOT=/usr/local/cuda
ENV CUDACXX=/usr/local/cuda/bin/nvcc

# Add sccache variables
ENV CMAKE_CUDA_COMPILER_LAUNCHER=sccache
ENV CMAKE_CXX_COMPILER_LAUNCHER=sccache
ENV CMAKE_C_COMPILER_LAUNCHER=sccache

# Set variable for mambarc
ENV CONDARC=/opt/conda/.condarc

# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]

# Install gcc9 from prebuilt tarball
RUN wget --quiet ${GCC9_URL} -O /gcc9.tgz \
    && tar xzvf /gcc9.tgz \
    && rm -f /gcc9.tgz

ARG BINUTILS_VER=2.37
# Build binutils
RUN mkdir -p /usr/local/src/binutils/build ${BINUTILS_DIR} \
 && wget -q -O- https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.gz \
  | tar -C /usr/local/src/binutils --strip-components=1 -xzf - \
 && cd /usr/local/src/binutils/build \
 && ../configure --prefix=${BINUTILS_DIR} \
 && make -j$(nproc --ignore 2) \
 && make -j$(nproc --ignore 2) install \
 && cd / && rm -rf /usr/local/src/binutils

# Add a condarc for channels and override settings
COPY .condarc /opt/conda/.condarc

# Update and add pkgs for gpuci builds
RUN yum install -y epel-release \
    && yum install -y --setopt=install_weak_deps=False \
      chrpath \
      clang \
      file \
      openmpi-devel \
      screen \
      vim \
    && yum clean all

ARG JQPATH=/usr/local/bin/jq
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O ${JQPATH} \
    && chmod +x $JQPATH

# Install latest awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf ./aws ./awscliv2.zip

# Add core tools to base env
RUN conda install -y gpuci-tools \
    || conda install -y gpuci-tools
RUN gpuci_conda_retry install -y \
      anaconda-client \
      codecov \
      mamba

# Create `rapids` conda env and make default
RUN gpuci_conda_retry create --no-default-packages --override-channels -n rapids \
      -c nvidia \
      -c conda-forge \
      -c gpuci \
      cudatoolkit=${CUDA_VER} \
      git \
      git-lfs \
      gpuci-tools \
      python=${PYTHON_VER} \
      'python_abi=*=*cp*' \
      "setuptools>50" \
    && sed -i 's/conda activate base/conda activate rapids/g' ~/.bashrc

# Install SCCACHE
ARG SCCACHE_VERSION=0.2.15
ARG SCCACHE_ARCH=x86_64
ARG SCCACHE_URL="https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-${SCCACHE_ARCH}-unknown-linux-musl.tar.gz"
RUN curl -L ${SCCACHE_URL} | tar -C /usr/bin -zf - --wildcards --strip-components=1 -x */sccache && chmod +x /usr/bin/sccache

# Install build/doc/notebook env meta-pkgs
#
# Once installed remove the meta-pkg so dependencies can be freely updated &
# the meta-pkg can be installed again with updates
RUN gpuci_conda_retry install -y -n rapids --freeze-installed \
      rapids-build-env=${RAPIDS_VER} \
      rapids-doc-env=${RAPIDS_VER} \
      rapids-notebook-env=${RAPIDS_VER} \
    && gpuci_conda_retry remove -y -n rapids --force-remove \
      rapids-build-env=${RAPIDS_VER} \
      rapids-doc-env=${RAPIDS_VER} \
      rapids-notebook-env=${RAPIDS_VER}

# Clean up pkgs to reduce image size and chmod for all users
RUN chmod -R ugo+w /opt/conda \
    && conda clean -tipy \
    && chmod -R ugo+w /opt/conda

ENTRYPOINT [ "/opt/conda/bin/tini", "--" ]
CMD [ "/bin/bash" ]
