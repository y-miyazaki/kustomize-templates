#/bin/bash

VERSION=${1:-1.14}

USER=$(whoami)
# document.
# https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#2-deploying-microk8s
# need to set classic mode.
sudo snap install microk8s --channel ${VERSION}/stable --classic

if [ $USER != "root" ]; then
    sudo usermod -a -G microk8s $USER
fi

# allow pod2pod and pod2internet
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

# dashboard, dns
sudo microk8s.enable dashboard dns ingress storage

# alias
sudo snap alias microk8s.kubectl kubectl

# stern
STERN_VERSION=$(curl --silent "https://api.github.com/repos/wercker/stern/releases/latest" |  grep '"tag_name":' |  sed -E 's/.*"(v?[^"]+)".*/\1/' )
sudo curl -LO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64
sudo mv stern_linux_amd64 /usr/local/bin/stern
sudo chmod +x /usr/local/bin/stern

# kube config
sudo kubectl config view --raw | sudo tee ${HOME}/.kube/config

# skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install skaffold /usr/local/bin/

echo "# ------------------------------------------------------------------------"
echo "# dashboard"
echo "# ------------------------------------------------------------------------"
echo "# get token for login"
echo "token=\$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)"
echo "microk8s.kubectl -n kube-system describe secret $token"
echo "# set proxy for access brouser"
echo "$ microk8s.kubectl proxy --accept-hosts=.* --address=0.0.0.0"
echo "# access brouser"
echo "http://{ubuntu vm public ip}:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#/login"

echo "# ------------------------------------------------------------------------"
echo "# grafana"
echo "# ------------------------------------------------------------------------"
echo "# url list"
echo "microk8s.kubectl cluster-info"
echo "# login information(username/password)"
echo "microk8s.config"
