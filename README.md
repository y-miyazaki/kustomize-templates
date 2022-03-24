# kustomize-templates
Kustomizeのテンプレートを取りまとめたリポジトリです。

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
--namespace {namespace`} \
--set 'controller.service.externalIPs={192.168.1.100}'
```
