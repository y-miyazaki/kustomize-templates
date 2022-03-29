# Memo

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
--namespace {namespace`} \
--set 'controller.service.externalIPs={192.168.1.100}'
```

- Check dig from pod
```
kubectl run --image=centos:6 --restart=Never --rm -i testpod -- dig base-redis-master-headless.base-app.svc.cluster.local
kubectl run --image=centos:6 --restart=Never --rm -i testpod -- dig base-redis-slave-headless.base-app.svc.cluster.local
```
