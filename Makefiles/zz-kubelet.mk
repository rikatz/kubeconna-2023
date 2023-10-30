## --------------------------------------
## Kubelet
## --------------------------------------


##@ kubelet:
.PHONY: kubelet-break
kubelet-break: ## Breaks Kubelet on workers
	@echo "!!!! WARNING  !!!!"
	@echo "You are breaking Kubelet. This means no Pod request will be scheduled even if scheduler is running!!"
	@for i in $(NODES); do \
    	docker exec -it $$i systemctl stop kubelet; \
    done

.PHONY: kubelet-check
kubelet-check: ## Checks Kubelet
	@echo "------ CHECKING Kubelet -----------"
	@for i in $(NODES); do \
		docker exec -it $$i /bin/bash -c "echo \$$(hostname) - \$$(systemctl is-active kubelet)"; \
	done

.PHONY: kubelet-fix
kubelet-fix: ## Fixes Kubelet
	@echo "Fixing kubelet"
	@for i in $(NODES); do \
    	docker exec -it $$i systemctl start kubelet; \
    done