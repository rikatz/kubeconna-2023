## --------------------------------------
## Kubernetes API Server
## --------------------------------------

APISERVER = "kube-apiserver"

##@ kube-apiserver:
.PHONY: apiserver-break
apiserver-break: ## Breaks the Kubernetes API Server
	@echo "Sleeping for 5s"
	@sleep 5
	@echo "Breaking $(APISERVER)"
	@docker exec -it $(CLUSTER)-control-plane /bin/bash -c "mkdir -p /kubemanifests && mv /etc/kubernetes/manifests/$(APISERVER).yaml /kubemanifests; exit 0"

.PHONY: apiserver-check
apiserver-check: ## Checks the Kubernetes API Server
	@echo "------ CHECKING $(APISERVER) -----------"
	-kubectl get pods -n kube-system -l component=$(APISERVER)

.PHONY: apiserver-fix
apiserver-fix: ## Fixes the Kubernetes API Server
	@echo "Fixing $(APISERVER)"
	-@docker exec -it $(CLUSTER)-control-plane cp /kubemanifests/$(APISERVER).yaml /etc/kubernetes/manifests
	@echo "Sleeping for 10s"
	@sleep 10
