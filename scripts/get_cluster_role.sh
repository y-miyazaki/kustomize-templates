#!/bin/bash
name=$1

kubectl -n kube-system create serviceaccount ${name}-cluster-admin
kubectl -n kube-system create serviceaccount ${name}-admin
kubectl -n kube-system create serviceaccount ${name}-edit
kubectl -n kube-system create serviceaccount ${name}-view

kubectl delete ${name}-cluster-admin
kubectl delete ${name}-admin
kubectl delete ${name}-edit
kubectl delete ${name}-view

kubectl create clusterrolebinding ${name}-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:${name}-cluster-admin-admin
kubectl create clusterrolebinding ${name}-admin --clusterrole=admin --serviceaccount=kube-system:${name}-admin
kubectl create clusterrolebinding ${name}-edit --clusterrole=edit --serviceaccount=kube-system:${name}-edit
kubectl create clusterrolebinding ${name}-view --clusterrole=view --serviceaccount=kube-system:${name}-view

TOKENNAME_CLUSTER_ADMIN=`kubectl -n kube-system get serviceaccount/${name}-cluster-admin -o jsonpath='{.secrets[0].name}'`
TOKENNAME_ADMIN=`kubectl -n kube-system get serviceaccount/${name}-admin -o jsonpath='{.secrets[0].name}'`
TOKENNAME_EDIT=`kubectl -n kube-system get serviceaccount/${name}-edit -o jsonpath='{.secrets[0].name}'`
TOKENNAME_VIEW=`kubectl -n kube-system get serviceaccount/${name}-view -o jsonpath='{.secrets[0].name}'`

TOKENNAME_CLUSTER_ADMIN=`kubectl -n kube-system get secret $TOKENNAME_CLUSTER_ADMIN -o jsonpath='{.data.token}'| base64 --decode`
TOKEN_ADMIN=`kubectl -n kube-system get secret $TOKENNAME_ADMIN -o jsonpath='{.data.token}'| base64 --decode`
TOKEN_EDIT=`kubectl -n kube-system get secret $TOKENNAME_EDIT -o jsonpath='{.data.token}'| base64 --decode`
TOKEN_VIEW=`kubectl -n kube-system get secret $TOKENNAME_VIEW -o jsonpath='{.data.token}'| base64 --decode`

echo $TOKENNAME_CLUSTER_ADMIN
echo $TOKEN_ADMIN
echo $TOKEN_EDIT
echo $TOKEN_VIEW

kubectl config set-credentials ${name}-cluster-admin --token=$TOKENNAME_CLUSTER_ADMIN
kubectl config set-credentials ${name}-admin --token=$TOKEN_ADMIN
kubectl config set-credentials ${name}-edit --token=$TOKEN_EDIT
kubectl config set-credentials ${name}-view --token=$TOKEN_VIEW
