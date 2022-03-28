#/bin/bash
#--------------------------------------------------------------
# Install: ArgoCD for kubernetes
# https://argo-cd.readthedocs.io/en/stable/getting_started/
#--------------------------------------------------------------

#--------------------------------------------------------------
# usage function
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

# Install: ArgoCD CLI
echo ""
echo "#-----------------------------------------"
echo "# Install: ArgoCD CLI. "
echo "#-----------------------------------------"
if [ -z "$(command -v argocd)" ]; then
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
fi
# add cluster
echo ""
echo "#-----------------------------------------"
echo "# Register A Cluster To Deploy Apps To (Optional)"
echo "# This step registers a cluster's credentials to Argo CD, and is only necessary when deploying to"
echo "# an external cluster. When deploying internally (to the same cluster that Argo CD is running in),"
echo "# https://kubernetes.default.svc should be used as the application's K8s API server address."
echo "# First list all clusters contexts in your current kubeconfig:"
echo "#"
echo "#    kubectl config get-contexts -o name"
echo "#"
echo "# Choose a context name from the list and supply it to argocd cluster add CONTEXTNAME. For example, for docker-desktop context, run:"
echo "#"
echo "#    argocd cluster add docker-desktop -y"
echo "#-----------------------------------------"

echo ""
echo "#-----------------------------------------"
echo "# Login Using The CLI"
echo "# The initial password for the admin account is auto-generated and stored as clear text in the field"
echo "# password in a secret named argocd-initial-admin-secret in your Argo CD installation namespace."
echo "# You can simply retrieve this password using kubectl:"
echo "#"
echo "#    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d;"
echo "# "
echo "# Change the password using the command:"
echo "#"
echo "#    argocd account update-password"
echo "#-----------------------------------------"

echo ""
echo "#-----------------------------------------"
echo "# ArgoCD login"
echo "#"
echo "#     argocd --insecure login {your argocd server domain} --grpc-web "
echo "#     ex) argocd --insecure login argocd-server.local:8081 --grpc-web "
echo "#"
echo "# Note: Check after ArgoCD is activated."
echo "#-----------------------------------------"
