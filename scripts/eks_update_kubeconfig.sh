#/bin/bash
KUBECTL_VERSION=v1.22.0

#--------------------------------------------------------------
# Set kubeconfig
#--------------------------------------------------------------
REGION=$1
CLUSTER=$2

if [ -n "${AWS_ACCESS_KEY_ID}" ] && [ -n "${AWS_SECRET_ACCESS_KEY}" ] && [ -n "${AWS_DEFAULT_REGION}" ]; then
    aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}" --profile default
    aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}" --profile default
    aws configure set region "${AWS_DEFAULT_REGION}" --profile default
fi
aws eks --region "${REGION}" update-kubeconfig --name "${CLUSTER}"
