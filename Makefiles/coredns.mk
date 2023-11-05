## --------------------------------------
## CoreDNS 
## --------------------------------------
COREDNS = "coredns"

##@ coredns:
.PHONY: coredns-break
coredns-break: ## Breaks CoreDNS
	@echo "Breaking $(COREDNS)"
	@kubectl scale deploy -n kube-system  $(COREDNS) --replicas=0

.PHONY: coredns-check
coredns-check: ## Checks COREDNS
	@echo "------ CHECKING $(APISERVER) -----------"
	-kubectl get deploy -n kube-system  $(COREDNS)
	@echo ""

.PHONY: coredns-fix
coredns-fix: ## Fixes CoreDNS
	@echo "Fixing CoreDNS"
	@kubectl scale deploy -n kube-system $(COREDNS) --replicas=1
