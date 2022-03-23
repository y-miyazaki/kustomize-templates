#/bin/bash
set -e
#--------------------------------------------------------------
# Minikube
# https://minikube.sigs.k8s.io/
#--------------------------------------------------------------

#--------------------------------------------------------------
# Variable
#--------------------------------------------------------------
MINIKUBE_VERSION=v1.18.1

#--------------------------------------------------------------
# minikube for mac
# https://minikube.sigs.k8s.io/docs/start/
#--------------------------------------------------------------
#--------------------------------------------------------------
# check command
#--------------------------------------------------------------
if [ -z "$(command -v curl)" ]; then
    usage "This command need to install \"curl\"."
fi
#--------------------------------------------------------------
# Check OS
#--------------------------------------------------------------
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then                                                                                           
  OS='Cygwin'
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

echo  "#-----------------------------------------"
echo  "# Install: minikube"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm -rf minikube-darwin-amd64
elif [ "${OS}" == "Mac" ]; then
    curl -LO https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-darwin-amd64
    sudo install minikube-darwin-amd64 /usr/local/bin/minikube
    rm -rf minikube-darwin-amd64
else
  exit 1
fi

#--------------------------------------------------------------
# Version
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Version: minikube "
echo  "#-----------------------------------------"
minikube version
