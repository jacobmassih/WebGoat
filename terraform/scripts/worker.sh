# #!/bin/bash

# sudo hostnamectl set-hostname worker

# sudo apt-get update

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
