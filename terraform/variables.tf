/*
variable "key_pair_name" {
  type = string
}
*/

variable "install_puppet" {
  type    = string
  default = <<-EOL
    #!/bin/bash -xe
    # Update package list
    apt-get update -y
    # Installs puppet-agent
    curl -LO https://apt.puppet.com/puppet7-release-focal.deb
    dpkg -i ./puppet7-release-focal.deb
    apt update
    apt-get install puppet-agent -y
    sudo echo -e "[main]\ncertname = $(hostname).kube\nserver = puppetmaster.kube" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
    sh -c 'echo "212.162.147.167 puppetmaster.kube puppetmaster" >> /etc/hosts'
    systemctl start puppet
    /opt/puppetlabs/bin/puppet agent --test
  EOL
}

variable "install_kube" {
  type    = string
  default = <<-EOL
    # Turn off swap
    sudo swapoff -a
    echo "Swap is off"

    # Install dependencies
    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
    echo "Dependencies installed"

    # Install docker
    echo "Installing docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
    sudo apt-get install docker-ce -y
    sudo usermod -aG docker ubuntu
    echo '{
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "100m"
      },
      "storage-driver": "overlay2"
    }' | sudo tee /etc/docker/daemon.json
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    echo "Docker installed!"

    # Install kubernetes
    echo "Installing kubernetes..."
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install kubelet kubeadm kubectl -y
    sudo apt-mark hold kubelet kubeadm kubectl
    echo "Kubernetes installed!"

    # Install cri-dockered
    echo "Installing cri-dockered..."
    sudo apt-get install golang-go -y
    cd && git clone https://github.com/Mirantis/cri-dockerd.git
    cd cri-dockerd
    sudo mkdir bin
    echo "Go is now building cri-dockered... This will take some time!"
    go build -o ../bin/cri-dockerd
    cd .. && mkdir -p /usr/local/bin
    sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
    sudo cp -a cri-dockerd/packaging/systemd/* /etc/systemd/system
    sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
    sudo systemctl daemon-reload
    sudo systemctl enable cri-docker.service
    sudo systemctl enable --now cri-docker.socket
    echo "Cri-dockered installed!"

    # install project calico
    echo "Installing project calico..."
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/tigera-operator.yaml
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/custom-resources.yaml
    echo "Project calico installed!"

    # join master
    echo "Attempting to join master..."
    sudo kubeadm join 212.162.147.167:6443 --token 3w3gkn.qcz74wgf4rb8a6ty --discovery-token-ca-cert-hash sha256:df0f39bf35987b2c157a94bd668c20cfbfde87211f966b102f046c64af27f835 --cri-socket=unix:///var/run/cri-dockerd.sock
    echo "Should have joined master now. Do kubectl get nodes on master to check"
  EOL
}
