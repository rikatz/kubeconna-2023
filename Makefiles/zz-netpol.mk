## --------------------------------------
## Network Policy Provider
## --------------------------------------


##@ Network Policy:
.PHONY: netpol-setup
netpol-setup: ## Setups a Network Policy Provider
	@echo "!!!! WARNING  !!!!"
	@echo "Kubernetes doesn't come with a default Network Policy Provider"
	@echo "For this exercise we are installing 'kube-router' modified just to behave as a NetPol provider"
	kubectl apply -f manifests/kube-router-fwonly.yaml

.PHONY: netpol-teardown
netpol-teardown: ## Removes Network Policy Provider
	kubectl delete -f manifests/kube-router-fwonly.yaml

.PHONY: netpol-check
netpol-check: ## Fixes the Kubernetes Scheduler
	@echo "------ CHECKING Kube router -----------"
	kubectl get daemonset -n kube-system kube-router
	@echo ""

