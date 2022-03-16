#/bin/bash

VERSION=${1:-1.14}

USER=$(whoami)

# kubectl for mac
# https://kubernetes.io/docs/tasks/tools/
brew install kubectl
kubectl version --client

# minikube for mac
# https://minikube.sigs.k8s.io/docs/start/
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube

# skaffold for mac
# https://skaffold.dev/docs/install/
brew install skaffold

# container-structure-test for mac
# https://github.com/GoogleContainerTools/container-structure-test#installation
curl -LO https://storage.googleapis.com/container-structure-test/latest/container-structure-test-darwin-amd64 && chmod +x container-structure-test-darwin-amd64 && sudo mv container-structure-test-darwin-amd64 /usr/local/bin/container-structure-test

# helm for mac
# https://helm.sh/docs/intro/install/
brew install helm

# stern for mac
# https://github.com/wercker/stern
brew install stern
