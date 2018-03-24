FROM ubuntu:xenial
ARG MINIKUBE_VERSION=v0.25.2
ARG KUBERNETES_VERSION=v1.9.4

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && \
  apt-get -q -y install --no-install-recommends libvirt-bin qemu-kvm curl ca-certificates sudo && \
  apt-get -q clean && \
  rm -rf /var/lib/apt/lists/*

# Add Tini
# Needed to not leave libvirt zombies behind
ARG TINI_VERSION=v0.17.0
RUN curl -fsSLo /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini
RUN chmod +x /tini

# Download kubectl, minikube, kvm2-driver
RUN curl -fsSLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl
RUN curl -fsSLo /usr/local/bin/docker-machine-driver-kvm2 https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/docker-machine-driver-kvm2 && \
    chmod +x /usr/local/bin/docker-machine-driver-kvm2
RUN curl -fsSLo /usr/local/bin/minikube https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-linux-amd64 && \
    chmod +x /usr/local/bin/minikube

# Get localkube binary and VM iso image. ISO image version isn't necessarily the same as the localkube-version, so we grep the URL from the help instead
RUN mkdir -p ~/.minikube/cache/iso && \
    mkdir -p ~/.minikube/cache/localkube && \
    curl -fsSLo ~/.minikube/cache/localkube/localkube-${KUBERNETES_VERSION} https://storage.googleapis.com/minikube/k8sReleases/${KUBERNETES_VERSION}/localkube-linux-amd64 && \
    curl -fsSLo ~/.minikube/cache/localkube/localkube-${KUBERNETES_VERSION}.sha256 https://storage.googleapis.com/minikube/k8sReleases/${KUBERNETES_VERSION}/localkube-linux-amd64.sha256 && \
    cd ~/.minikube/cache/iso && curl -sSLO $(minikube start --help | grep -E 'https://[^" ]+.iso' -o)

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/tini", "--", "/docker-entrypoint.sh" ]
CMD [ "/bin/bash" ]

