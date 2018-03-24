Minikube CI container
=====================

A Docker container using KVM to start a minikube VM. Consequently, the running host must be KVM enabled, and the container has to be run in priviliged mode, e.g. `docker run --priviliged ...`.

Intention is to use this in CI pipelines as a throw-away one-off Kubernetes-Cluster.
