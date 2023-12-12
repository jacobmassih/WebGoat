#!/bin/bash

sudo hostnamectl set-hostname master

sudo apt-get update

# # Install and start docker
# sudo apt-get install docker.io -y
# sudo systemctl start docker
# sudo systemctl enable docker

# # Install Kubeadm
# sudo apt-get install apt-transport-https curl -y
# wget https://packages.cloud.google.com/apt/doc/apt-key.gpg
# sudo apt-key add apt-key.gpg
# sudo swapoff -a
# sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
# sudo apt-get install kubeadm -y


# # #Initialize the Kubernetes
# export PRIVATE_IP=$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)
# sudo kubeadm init --apiserver-advertise-address=$PRIVATE_IP --pod-network-cidr=10.244.0.0/16

# # #Set Up Kubeconfig
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# # kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml