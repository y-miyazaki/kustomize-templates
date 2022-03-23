#/bin/bash
#--------------------------------------------------------------
# Install: ArgoCD for kubernetes
# https://argo-cd.readthedocs.io/en/stable/getting_started/
#--------------------------------------------------------------

#--------------------------------------------------------------
# usage function
#--------------------------------------------------------------
function usage () {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    if [ -n "${1}" ]; then
        printf "%b%s%b" "${RED}" "${1}" "${NC}"
    fi
    cat <<EOF

Script for initial setting of ArgoCD.

Usage:
    $(basename "${0}") [<options>]
    $(basename "${0}") -c your-cluster-name

Options:
    -c {cluter name}               Specify the name of the kubernetes cluster.
EOF
    exit 1
}

while getopts c:h opt
do
    case $opt in
        c ) CLUSTER_NAME=$OPTARG ;;
        h ) usage ;;
        \? ) usage ;;
    esac
done

#--------------------------------------------------------------
# check command
#--------------------------------------------------------------
if [ -z "$(command -v kubectl)" ]; then
    usage "This command need to install \"kubectl\"."
fi
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

# Install: ArgoCD for kubernetes
echo "#-----------------------------------------"
echo "# Install: ArgoCD. "
echo "#-----------------------------------------"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Install: ArgoCD CLI
echo "#-----------------------------------------"
echo "# Install: ArgoCD CLI. "
echo "#-----------------------------------------"
if [ "${OS}" == "Linux" ]; then
    # https://argo-cd.readthedocs.io/en/stable/cli_installation/
    curl -SL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x /usr/local/bin/argocd
elif [ "${OS}" == "Mac" ]; then
    VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -SL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-amd64
    chmod +x /usr/local/bin/argocd
else
    exit 1
fi

# add cluster
echo "#-----------------------------------------"
echo "# Cluster add to ArgoCD. "
echo "#-----------------------------------------"
argocd cluster add ${CLUSTER_NAME} -y

# get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "#-----------------------------------------"
echo "# If you want to change the admin password using the command. "
echo "#-----------------------------------------"
echo "argocd account update-password"
