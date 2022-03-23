#/bin/bash
set -e
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
STERN_VERSION=1.11.0

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


#--------------------------------------------------------------
# kubectl
# https://kubernetes.io/docs/tasks/tools/
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Install: kubectl"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
elif [ "${OS}" == "Mac" ]; then
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl.sha256"
    echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    sudo chown root: /usr/local/bin/kubectl
    rm -rf kubectl.sha256
else
    exit 1
fi

#--------------------------------------------------------------
# skaffold 
# https://skaffold.dev/docs/install/
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Install: skaffold"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    sudo install skaffold /usr/local/bin/
elif [ "${OS}" == "Mac" ]; then
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/${SKAFFOLD_VERSION}/skaffold-darwin-amd64 && chmod +x skaffold && sudo mv skaffold /usr/local/bin
else
    exit 1
fi

#--------------------------------------------------------------
# container-structure-test 
# https://github.com/GoogleContainerTools/container-structure-test#installation
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Install: container-structure-test"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    curl -LO https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64 && chmod +x container-structure-test-linux-amd64 && sudo mv container-structure-test-linux-amd64 /usr/local/bin/container-structure-test
elif [ "${OS}" == "Mac" ]; then
    curl -LO https://storage.googleapis.com/container-structure-test/${CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test-darwin-amd64 && chmod +x container-structure-test-darwin-amd64 && sudo mv container-structure-test-darwin-amd64 /usr/local/bin/container-structure-test
else
    exit 1
fi

#--------------------------------------------------------------
# helm
# https://helm.sh/docs/intro/install/
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Install: helm"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && chmod +x linux-amd64/helm && sudo mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64 && rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz
elif [ "${OS}" == "Mac" ]; then
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-darwin-amd64.tar.gz && tar -zxvf helm-${HELM_VERSION}-darwin-amd64.tar.gz && chmod +x darwin-amd64/helm && sudo mv darwin-amd64/helm /usr/local/bin/helm && rm -rf darwin-amd64 && rm -rf helm-${HELM_VERSION}-darwin-amd64.tar.gz
else
    exit 1
fi

#--------------------------------------------------------------
# stern 
# https://github.com/wercker/stern
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Install: stern"
echo  "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    STERN_VERSION=$(curl --silent "https://api.github.com/repos/wercker/stern/releases/latest" |  grep '"tag_name":' |  sed -E 's/.*"(v?[^"]+)".*/\1/' )
    sudo curl -LO https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64
    sudo mv stern_linux_amd64 /usr/local/bin/stern
    sudo chmod +x /usr/local/bin/stern
elif [ "${OS}" == "Mac" ]; then
    brew install stern
else
    exit 1
fi


#--------------------------------------------------------------
# Version
#--------------------------------------------------------------
echo  "#-----------------------------------------"
echo  "# Version: kubectl "
echo  "#-----------------------------------------"
kubectl version --client
echo  "#-----------------------------------------"
echo  "# Version: skaffold "
echo  "#-----------------------------------------"
skaffold version
echo  "#-----------------------------------------"
echo  "# Version: container-structure-test "
echo  "#-----------------------------------------"
container-structure-test version
echo  "#-----------------------------------------"
echo  "# Version: helm "
echo  "#-----------------------------------------"
helm version
echo  "#-----------------------------------------"
echo  "# Version: stern "
echo  "#-----------------------------------------"
stern --version
