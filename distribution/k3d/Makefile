#--------------------------------------------------------------
# k3d
# https://github.com/k3d-io/k3d
#--------------------------------------------------------------

#--------------------------------------------------------------
# Variable
#--------------------------------------------------------------
# k3d
CLUSTER_NAME=local-cluster
VOLUME=$(HOME)/k3d/data
LOCAL_REGISTRY=registry.localhost

# dashboard
# https://github.com/kubernetes/dashboard
VERSION_KUBE_DASHBOARD=v2.5.1

# for k3d cluster
.PHONY: create
create:
	mkdir -p $(VOLUME)
	k3d cluster create $(CLUSTER_NAME) --config config/k3d-config.yaml
	kubectl cluster-info
	kubectl get nodes
	kubectl get pods -A -o wide

# .PHONY: switch-context
# switch-context:
# 	k3d kubeconfig merge $(CLUSTER_NAME) --switch-context

.PHONY: dashboard
dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/$(VERSION_KUBE_DASHBOARD)/aio/deploy/recommended.yaml
	kubectl apply -f config/dashboard-admin-user.yaml -f config/dashboard-admin-user-role.yaml
	@echo "#--------------------------------------------------------------"
	@echo "# Dashboard"
	@echo "#--------------------------------------------------------------"
	@echo http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
	@echo ""
	@echo "#--------------------------------------------------------------"
	@echo "# Token"
	@echo "#--------------------------------------------------------------"
	@kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token
	@echo ""
	@kubectl proxy

.PHONY: delete-dashboard
delete-dashboard:
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/$(VERSION_KUBE_DASHBOARD)/aio/deploy/recommended.yaml
	kubectl delete clusterRoleBinding kubernetes-dashboard

.PHONY: start
start:
	k3d cluster start $(CLUSTER_NAME)

.PHONY: stop
stop:
	k3d cluster stop $(CLUSTER_NAME)

.PHONY: delete
delete:
	k3d cluster delete $(CLUSTER_NAME)
	k3d registry delete $(LOCAL_REGISTRY)
