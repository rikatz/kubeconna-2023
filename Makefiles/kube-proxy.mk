## --------------------------------------
## Kube Proxy
## --------------------------------------

PROXY = "kube-proxy"

##@ kube-proxy:
.PHONY: proxy-break
proxy-break: ## Breaks kube-proxy on all nodes
	@echo "Breaking $(PROXY)"
	@kubectl patch daemonset -n kube-system \
		--type='json' \
		-p='[{"op": "replace", "path": "/spec/template/spec/nodeSelector/kubernetes.io~1os", "value": "notlinux"}]' \
		$(PROXY)

.PHONY: proxy-check
proxy-check: ## Checks the kube-proxy resources status
	@echo "------ CHECKING $(PROXY) -----------"
	kubectl get daemonset -n kube-system $(PROXY)
	@echo ""

.PHONY: proxy-fix
proxy-fix: ## Fixes kube-proxy
	@echo "Fixing $(PROXY)"
	@kubectl patch daemonset -n kube-system \
	--type='json' \
	-p='[{"op": "replace", "path": "/spec/template/spec/nodeSelector/kubernetes.io~1os", "value": "linux"}]' \
	$(PROXY)
