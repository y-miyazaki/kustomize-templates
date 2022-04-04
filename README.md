# kustomize-templates
Kustomize templates are compiled here.

# Index

- Kustomize templates
  - [MinIO for local](#minio-for-local)
  - [MySQL for local](#mysql-for-local)
  - [Postgres for local](#postgres-for-local)
  - [Redis for local](#redis-for-local)
  - [ArgoCD for local](#argocd-for-local)
- Kustomize distribution
  - [k3d](#k3d)
    - [Install k3d command](#install-k3d-command)
    - [Config Cluster](#config-cluster)
    - [Create cluster](#create-cluster)
    - [Stop cluster](#stop-cluster)
    - [Start cluster](#start-cluster)
    - [Delete cluster](#delete-cluster)

## MinIO for local
MinIO offers high-performance, S3 compatible object storage. It is created as a local environment.  

https://min.io/

- base  
[kustomize/base/local/aws/s3](kustomize/base/local/aws/s3)
- overlays  
[kustomize/overlays/local/aws/s3](kustomize/overlays/local/aws/s3)
- access  
  - s3-api  
  http://localhost:30100
  - s3-dashboard  
  http://localhost:30101 minioroot/minioroot

## MySQL for local
MySQL is created as a local environment.

- base  
[kustomize/base/local/db/mysql](kustomize/base/local/db/mysql)
- overlays  
[kustomize/overlays/local/db/mysql](kustomize/overlays/local/db/mysql)
- access  
localhost:30306 root/rootpass

## Postgres for local
Postgres is created as a local environment.
- base  
[kustomize/base/local/db/postgres](kustomize/base/local/db/postgres)
- overlays  
[kustomize/overlays/local/db/postgres](kustomize/overlays/local/db/postgres)
- access  
localhost:30432 admin/rootpass

## Redis for local
Redis is configured as a Master/Slave Cluster. It is created as a local environment.  

https://redis.io/

- base  
[kustomize/base/local/redis](kustomize/base/local/redis)
- overlays  
[kustomize/overlays/local/redis](kustomize/overlays/local/redis)
- access  
  - master  
    ```
    $ redis-cli -h localhost -p 30379 ping
    PONG
    ```
  - slave  
    ```
    $ redis-cli -h localhost -p 30380 ping
    PONG
    ```

## ArgoCD for local
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. The following example is set up for local use.
It is designed to be accessed via Ingress from the traefik LoadBalancer included with K3d.  

https://argo-cd.readthedocs.io/

- base  
[kustomize/base/argocd](kustomize/base/argocd)
- overlays  
[kustomize/overlays/argocd](kustomize/overlays/argocd)  
[kustomize/overlays/traefik-argocd](kustomize/overlays/traefik-argocd)
- access  
  http://argocd-server.local:8081/ admin/*****

  The initial password can be obtained with the following command
  ```
  $ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;
  ```
  Since argocd-server.local is the hostname for the distribution in Ingress, it must be added to /etc/hosts.
  ```
  $ echo 127.0.0.1 argocd-server.local >> /etc/hosts
  ```

# Kubernetes distribution

# k3d
k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.  
  
k3d makes it very easy to create single- and multi-node k3s clusters in docker, e.g. for local development on Kubernetes.  
  
Note: k3d is a community-driven project, that is supported by Rancher (SUSE) and it’s not an official Rancher (SUSE) product.

https://k3d.io/

## Install k3d command

```
$ ./scripts/install_k3d.sh
#-----------------------------------------
# Install: k3d
#-----------------------------------------
#-----------------------------------------
# Version: k3d 
#-----------------------------------------
k3d version v5.0.0
k3s version v1.21.5-k3s1 (default)
```

## Config cluster
The config for creating a K3d cluster is the following file. If you want to modify it depending on your environment, please modify the following file. Document is [here](https://k3d.io/v5.0.0/usage/configfile/
).

[distribution/k3d/config/k3d-config.yaml](distribution/k3d/config/k3d-config.yaml)


## Create cluster
```
$ cd distribution/k3d
$ make create

mkdir -p /Users/yourname/k3d/data
k3d cluster create local-cluster --config config/k3d-config.yaml
INFO[0000] Using config file config/k3d-config.yaml (k3d.io/v1alpha3#simple) 
INFO[0000] portmapping '8081:80' targets the loadbalancer: defaulting to [servers:*:proxy agents:*:proxy] 
INFO[0000] Prep: Network                                
INFO[0000] Created network 'k3d-local-cluster'          
INFO[0000] Created volume 'k3d-local-cluster-images'    
INFO[0000] Creating node 'registry.localhost'           
INFO[0000] Successfully created registry 'registry.localhost' 
INFO[0000] Starting new tools node...                   
INFO[0000] Starting Node 'k3d-local-cluster-tools'      
INFO[0001] Creating node 'k3d-local-cluster-server-0'   
INFO[0001] Creating node 'k3d-local-cluster-agent-0'    
INFO[0001] Creating LoadBalancer 'k3d-local-cluster-serverlb' 
INFO[0001] Using the k3d-tools node to gather environment information 
INFO[0002] Starting cluster 'local-cluster'             
INFO[0002] Starting servers...                          
INFO[0002] Deleted k3d-local-cluster-tools              
INFO[0003] Starting Node 'k3d-local-cluster-server-0'   
INFO[0009] Starting agents...                           
INFO[0010] Starting Node 'k3d-local-cluster-agent-0'    
INFO[0022] Starting helpers...                          
INFO[0022] Starting Node 'registry.localhost'           
INFO[0022] Starting Node 'k3d-local-cluster-serverlb'   
INFO[0053] Injecting record '192.168.65.2 host.k3d.internal'... 
INFO[0061] Cluster 'local-cluster' created successfully! 
INFO[0061] --kubeconfig-update-default=false --> sets --kubeconfig-switch-context=false 
INFO[0061] You can now use it like this:                
kubectl config use-context k3d-local-cluster
kubectl cluster-info
kubectl cluster-info
Kubernetes control plane is running at https://0.0.0.0:6445
CoreDNS is running at https://0.0.0.0:6445/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://0.0.0.0:6445/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
kubectl get nodes
NAME                         STATUS   ROLES                  AGE   VERSION
k3d-local-cluster-server-0   Ready    control-plane,master   50s   v1.20.15+k3s1
k3d-local-cluster-agent-0    Ready    <none>                 40s   v1.20.15+k3s1
kubectl get pods -A -o wide
NAMESPACE     NAME                                      READY   STATUS              RESTARTS   AGE   IP          NODE                         NOMINATED NODE   READINESS GATES
kube-system   metrics-server-86cbb8457f-fggl4           1/1     Running             0          37s   10.42.1.2   k3d-local-cluster-agent-0    <none>           <none>
kube-system   local-path-provisioner-5ff76fc89d-ls8qb   1/1     Running             0          37s   10.42.1.3   k3d-local-cluster-agent-0    <none>           <none>
kube-system   coredns-6488c6fcc6-xmjjc                  1/1     Running             0          37s   10.42.0.2   k3d-local-cluster-server-0   <none>           <none>
kube-system   traefik-799bbc5bd6-9l4mk                  0/1     ContainerCreating   0          4s    <none>      k3d-local-cluster-agent-0    <none>           <none>
kube-system   svclb-traefik-vh5sf                       0/2     ContainerCreating   0          4s    <none>      k3d-local-cluster-agent-0    <none>           <none>
kube-system   svclb-traefik-cn5df                       0/2     ContainerCreating   0          4s    <none>      k3d-local-cluster-server-0   <none>           <none>
kube-system   helm-install-traefik-nkp4b                0/1     Completed           0          38s   10.42.0.3   k3d-local-cluster-server-0   <none>           <none>
```

## Stop cluster
```
$ cd distribution/k3d
$ make stop

k3d cluster stop local-cluster
INFO[0000] Stopping cluster 'local-cluster'             
INFO[0026] Stopped cluster 'local-cluster'              
```

## Start cluster
```
$ cd distribution/k3d
$ make start

k3d cluster start local-cluster
INFO[0000] Using the k3d-tools node to gather environment information 
INFO[0000] Starting new tools node...                   
INFO[0000] Starting Node 'k3d-local-cluster-tools'      
INFO[0000] Starting cluster 'local-cluster'             
INFO[0000] Starting servers...                          
INFO[0000] Deleted k3d-local-cluster-tools              
INFO[0001] Starting Node 'k3d-local-cluster-server-0'   
INFO[0005] Starting agents...                           
INFO[0006] Starting Node 'k3d-local-cluster-agent-0'    
INFO[0013] Starting helpers...                          
INFO[0013] Starting Node 'registry.localhost'           
INFO[0013] Starting Node 'k3d-local-cluster-serverlb'   
INFO[0041] Injecting record '192.168.65.2 host.k3d.internal'... 
```

### Delete cluster
```
$ cd distribution/k3d
$ make delete

k3d cluster delete local-cluster
INFO[0000] Deleting cluster 'local-cluster'             
INFO[0021] Deleted k3d-local-cluster-serverlb           
INFO[0022] Deleted k3d-local-cluster-agent-0            
INFO[0022] Deleted k3d-local-cluster-server-0           
INFO[0023] Deleted registry.localhost                   
INFO[0023] Deleting cluster network 'k3d-local-cluster' 
INFO[0023] Deleting image volume 'k3d-local-cluster-images' 
INFO[0023] Removing cluster details from default kubeconfig... 
INFO[0023] Removing standalone kubeconfig file (if there is one)... 
INFO[0023] Successfully deleted cluster local-cluster!  
```
