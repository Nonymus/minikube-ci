Minikube CI container
=====================

A Docker container using KVM to start a minikube VM. Consequently, the running
host must be KVM enabled, and the container has to be run in priviliged mode,
e.g. `docker run --priviliged ...`. Intended to be used in CI pipelines as
a throw-away one-off Kubernetes-Cluster.

# Caveats
VM init will fail if the host is currently running a Virtualbox VM (and
probably also any other non-libvirt hypervised VM). Seems like different
hypervisor kernel modules can't share VT-x/AMD-V at the same time.
