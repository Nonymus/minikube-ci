#!/bin/bash

# tini will clean this up
# start libvirt
/etc/init.d/libvirt-bin start
/etc/init.d/virtlogd start
/etc/init.d/qemu-kvm start

#start minikube vm
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir $HOME/.kube || true
touch $HOME/.kube/config

minikube start --vm-driver kvm2 $MINIKUBE_START_FLAGS

exec "$@"
