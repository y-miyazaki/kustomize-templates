#/bin/bash
#--------------------------------------------------------------
# Install: base for kubernetes
#--------------------------------------------------------------
#--------------------------------------------------------------
# Variable
#--------------------------------------------------------------
KUBECTL_VERSION=v1.21.2
SKAFFOLD_VERSION=v1.18.0
CONTAINER_STRUCTURE_TEST_VERSION=v1.11.0
HELM_VERSION=v3.6.2

#--------------------------------------------------------------
# kubectl for mac
# https://kubernetes.io/docs/tasks/tools/
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: kubectl\n"
echo -e -n "#-----------------------------------------\n"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl.sha256"
echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
rm -rf kubectl.sha256

#--------------------------------------------------------------
# skaffold for mac
# https://skaffold.dev/docs/install/
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: skaffold\n"
echo -e -n "#-----------------------------------------\n"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/${SKAFFOLD_VERSION}/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin

#--------------------------------------------------------------
# container-structure-test for mac
# https://github.com/GoogleContainerTools/container-structure-test#installation
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: container-structure-test\n"
echo -e -n "#-----------------------------------------\n"
curl -LO https://storage.googleapis.com/container-structure-test/${CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test-darwin-amd64 && chmod +x container-structure-test-darwin-amd64 && sudo mv container-structure-test-darwin-amd64 /usr/local/bin/container-structure-test

#--------------------------------------------------------------
# helm for mac
# https://helm.sh/docs/intro/install/
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: helm\n"
echo -e -n "#-----------------------------------------\n"
curl -LO https://get.helm.sh/helm-${HELM_VERSION}-darwin-amd64.tar.gz && tar -zxvf helm-${HELM_VERSION}-darwin-amd64.tar.gz && chmod +x darwin-amd64/helm && sudo mv darwin-amd64/helm /usr/local/bin/helm && rm -rf darwin-amd64 && rm -rf helm-${HELM_VERSION}-darwin-amd64.tar.gz

#--------------------------------------------------------------
# stern for mac
# https://github.com/wercker/stern
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Install: stern\n"
echo -e -n "#-----------------------------------------\n"
brew reinstall stern

#--------------------------------------------------------------
# Version
#--------------------------------------------------------------
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: kubectl \n"
echo -e -n "#-----------------------------------------\n"
kubectl version --client
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: skaffold \n"
echo -e -n "#-----------------------------------------\n"
skaffold version
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: container-structure-test \n"
echo -e -n "#-----------------------------------------\n"
container-structure-test version
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: helm \n"
echo -e -n "#-----------------------------------------\n"
helm version
echo -e -n "#-----------------------------------------\n"
echo -e -n "# Version: stern \n"
echo -e -n "#-----------------------------------------\n"
stern --version
