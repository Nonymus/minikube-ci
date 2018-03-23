FROM ubuntu:xenial
ENV DEBIAN_FRONTEND=noninteractive

# Add Tini
ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN apt-get update && \
  apt-get -y install --no-install-recommends libvirt-bin qemu-kvm curl ca-certificates sudo && \
  rm -rf /var/lib/apt/lists/*

ADD https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 /usr/bin/docker-machine-driver-kvm2
RUN chmod +x /usr/bin/docker-machine-driver-kvm2

ADD https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 /usr/bin/minikube
RUN chmod +x /usr/bin/minikube

# We are google and don't release our binaries on github yada yada yada
RUN curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x /usr/bin/kubectl

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

## Hacky setup to pre-fetch image and binaries
# The start will fail, but will download the minikube VM image
RUN minikube start --vm-driver kvm2 || echo "Hopefully downloaded VM-Image" && \
  minikube delete || echo "Nothing to clean up"

# This will also fail, but will download the localkube binary
RUN ln -s /bin/true /usr/bin/docker
RUN minikube start --vm-driver none || echo "Hopefully downloaded localkube" && \
  minikube delete || echo "Nothing to clean up"
RUN rm /usr/bin/docker

ENTRYPOINT [ "/tini", "--", "/docker-entrypoint.sh" ]
CMD [ "/bin/bash" ]

