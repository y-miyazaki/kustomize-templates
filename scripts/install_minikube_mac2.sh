#/bin/bash
set -e

KUBECTL_VERSION=v1.21.2
MINIKUBE_VERSION=v1.18.1
SKAFFOLD_VERSION=v1.18.0
CONTAINER_STRUCTURE_TEST_VERSION=v1.9.0
HELM_VERSION=v3.6.2

# kubectl for mac
# https://kubernetes.io/docs/tasks/tools/
echo  "#-----------------------------------------"
echo  "# Install: kubectl"
echo  "#-----------------------------------------"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
rm -rf kubectl.sha256

# minikube for mac
# https://minikube.sigs.k8s.io/docs/start/
echo  "#-----------------------------------------"
echo  "# Install: minikube"
echo  "#-----------------------------------------"
curl -LO https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm -rf minikube-darwin-amd64

# skaffold for mac
# https://skaffold.dev/docs/install/
echo  "#-----------------------------------------"
echo  "# Install: skaffold"
echo  "#-----------------------------------------"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/${SKAFFOLD_VERSION}/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin

# container-structure-test for mac
# https://github.com/GoogleContainerTools/container-structure-test#installation
echo  "#-----------------------------------------"
echo  "# Install: container-structure-test"
echo  "#-----------------------------------------"
curl -LO https://storage.googleapis.com/container-structure-test/${CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test-darwin-amd64 && mv container-structure-test-darwin-amd64 container-structure-test && chmod +x container-structure-test && sudo mv container-structure-test /usr/local/bin/

# helm for mac
# https://helm.sh/docs/intro/install/
echo  "#-----------------------------------------"
echo  "# Install: helm"
echo  "#-----------------------------------------"
curl -LO https://get.helm.sh/helm-${HELM_VERSION}-darwin-amd64.tar.gz && tar -zxvf helm-${HELM_VERSION}-darwin-amd64.tar.gz && chmod +x darwin-amd64/helm && sudo mv darwin-amd64/helm /usr/local/bin/helm && rm -rf darwin-amd64 && rm -rf helm-${HELM_VERSION}-darwin-amd64.tar.gz

# stern for mac
# https://github.com/wercker/stern
echo  "#-----------------------------------------"
echo  "# Install: stern"
echo  "#-----------------------------------------"
brew reinstall stern

echo  "#-----------------------------------------"
echo  "# Version: kubectl "
echo  "#-----------------------------------------"
kubectl version --client
echo  "#-----------------------------------------"
echo  "# Version: minikube "
echo  "#-----------------------------------------"
minikube version
echo  "#-----------------------------------------"
echo  "# Version: skaffold "
echo  "#-----------------------------------------"
skaffold version
echo  "#-----------------------------------------"
echo  "# Version: helm "
echo  "#-----------------------------------------"
helm version
echo  "#-----------------------------------------"
echo  "# Version: stern "
echo  "#-----------------------------------------"
stern --version
