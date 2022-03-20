#/bin/bash
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
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: minikube\n"
echo -e -n "#-----------------------------------------\n"
curl -LO https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm -rf minikube-darwin-amd64

#--------------------------------------------------------------
# Version
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: minikube \n"
echo -e -n "#-----------------------------------------\n"
minikube version