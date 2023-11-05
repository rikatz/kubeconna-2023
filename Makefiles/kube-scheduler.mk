## --------------------------------------
## Scheduler
## --------------------------------------

SCHEDULER = "kube-scheduler"

##@ kube-scheduler:
.PHONY: scheduler-break
scheduler-break: ## Breaks the Kubernetes Scheduler
	@echo "Breaking $(SCHEDULER)"
	@docker exec -it $(CLUSTER)-control-plane /bin/bash -c "mkdir -p /kubemanifests && mv /etc/kubernetes/manifests/$(SCHEDULER).yaml /kubemanifests; exit 0"

.PHONY: scheduler-check
scheduler-check: ## Checks the Kubernetes Scheduler Pods status
	@echo "------ CHECKING $(SCHEDULER) -----------"
	-kubectl get pods -n kube-system -l component=$(SCHEDULER)
	@echo ""

.PHONY: scheduler-fix
scheduler-fix: ## Fixes the Kubernetes Scheduler
	@echo "Fixing $(SCHEDULER)"
	-@docker exec -it $(CLUSTER)-control-plane cp /kubemanifests/$(SCHEDULER).yaml /etc/kubernetes/manifests
