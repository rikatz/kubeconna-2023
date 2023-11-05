## --------------------------------------
## ETCD
## --------------------------------------

ETCD = "etcd"

##@ etcd:
.PHONY: etcd-break
etcd-break: ## Breaks ETCD
	@echo "!!!! WARNING  !!!!"
	@echo "You are breaking ETCD. This means that no APIServer request will work even if APIServer is online!!"
	@docker exec -it $(CLUSTER)-control-plane /bin/bash -c "mkdir -p /kubemanifests && mv /etc/kubernetes/manifests/$(ETCD).yaml /kubemanifests"; exit 0"

.PHONY: etcd-check
etcd-check: ## Checks ETCD
	@echo "------ CHECKING $(ETCD) -----------"
	-kubectl get pods -n kube-system -l component=$(ETCD)
	@echo ""

.PHONY: etcd-fix
etcd-fix: ## Fixes the Kubernetes Scheduler
	@echo "Fixing $(ETCD)"
	-@docker exec -it $(CLUSTER)-control-plane cp /kubemanifests/$(ETCD).yaml /etc/kubernetes/manifests
