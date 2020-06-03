FROM envoyproxy/envoy-build-ubuntu:eb5d41a2a135b1db6757495a103450d4a9aecb66

ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
    xz-utils \
    wget \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# LLVM support
ENV LLVM_VERSION=9.0.0
ENV LLVM_DIRECTORY=/usr/lib/llvm
ENV LANG=C.UTF-8

RUN set -eux; \
    \
    case "${TARGETARCH}" in \
        amd64) LLVM_RELEASE=clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04;; \
        arm64) LLVM_RELEASE=clang+llvm-${LLVM_VERSION}-aarch64-linux-gnu;; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac; \
    \
    wget https://releases.llvm.org/${LLVM_VERSION}/${LLVM_RELEASE}.tar.xz; \
    tar -xJf ${LLVM_RELEASE}.tar.xz -C /tmp; \
    mkdir -p ${LLVM_DIRECTORY}; \
    mv /tmp/${LLVM_RELEASE}/* ${LLVM_DIRECTORY}/;

ENV PATH=${LLVM_DIRECTORY}/bin:$PATH

# Go support
RUN set -eux; \
    \
    GOLANG_VERSION=1.14.4; \
    wget -O go.tgz https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/local/go/bin:${PATH}
WORKDIR ${GOPATH}/src
