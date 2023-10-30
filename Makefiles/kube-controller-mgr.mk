## --------------------------------------
## Controller Manager
## --------------------------------------

CONTROLLER = "kube-controller-manager"

##@ kube-controller-manager:
.PHONY: controllermgr-break
controllermgr-break: ## Breaks the Kubernetes Controller Manager
	@echo "Breaking $(CONTROLLER)"
	@docker exec -it $(CLUSTER)-control-plane /bin/bash -c "mkdir -p /kubemanifests && mv /etc/kubernetes/manifests/$(CONTROLLER).yaml /kubemanifests; exit 0"

.PHONY: controllermgr-check
controllermgr-check: ## Checks the Kubernetes Controller Manager Pods status
	@echo "------ CHECKING $(CONTROLLER) -----------"
	kubectl get pods -n kube-system -l component=$(CONTROLLER)
	@echo ""

.PHONY: controllermgr-fix
controllermgr-fix: ## Fixes the Kubernetes Controller Manager
	@echo "Fixing $(CONTROLLER)"
	-@docker exec -it $(CLUSTER)-control-plane cp /kubemanifests/$(CONTROLLER).yaml /etc/kubernetes/manifests
