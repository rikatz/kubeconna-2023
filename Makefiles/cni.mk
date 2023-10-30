## --------------------------------------
## CNI
## --------------------------------------

##@ cni:
.PHONY: cni-break
cni-break: ## Breaks the CNI
	@echo "Breaking the CNI"
	@kubectl patch daemonset -n kube-system \
	--type='json' \
	-p='[{"op": "replace", "path": "/spec/template/spec/nodeSelector/kubernetes.io~1os", "value": "notlinux"}]' \
	kindnet
	@for i in $(NODES); do \
    	docker exec -it $$i /bin/bash -c "ip route del 10.244.1.0/24; ip route del 10.244.2.0/24; exit 0"; \
    done

.PHONY: cni-check
cni-check: ## Checks the CNI and show the output
	@echo "------ CHECKING CNI -----------"
	kubectl get daemonset -n kube-system kindnet
	@echo ""
	@echo "Getting worker nodes routes"
	@for i in $(NODES); do \
    	docker exec -it $$i /bin/bash -c "echo \$$(hostname); ip route"; \
		echo ""; \
    done

.PHONY: cni-fix
cni-fix: ## Fixes the CNI
	@echo "Fixing the CNI"
	@kubectl patch daemonset -n kube-system \
		--type='json' \
		-p='[{"op": "replace", "path": "/spec/template/spec/nodeSelector/kubernetes.io~1os", "value": "linux"}]' \
		kindnet
