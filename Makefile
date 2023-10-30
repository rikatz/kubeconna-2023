# Kubernetes breaker Makefile
include Makefiles/*.mk

reverse = $(if $(1),$(call reverse,$(wordlist 2,$(words $(1)),$(1)))) $(firstword $(1))

CLUSTER ?= kubeconna2023
DEPLOY_NAME ?= kubeconapp
IMAGE ?= broken.cluster.tld/kubecon/http:latest
REPLICAS ?= 2

NODES := $(shell docker ps -f label=io.x-k8s.kind.cluster=$(CLUSTER) -f label=io.x-k8s.kind.role=worker -q)


COMPONENTS = cni \
	coredns \
	proxy \
	scheduler \
	controllermgr \
	apiserver

EXECUTABLES = kubectl kind docker

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Prereqs
.PHONY: prereqs
prereqs: ## Check the prereqs
	@echo Checking for $(EXECUTABLES)
	@for i in $(EXECUTABLES); do \
		LOCATION=$$(command -v $$i); \
		if [ $$? -ne 0 ]; then \
			echo "$$i is not installed"; \
			exit 1; \
		fi; \
	done
	@echo "All required binaries are installed"

.PHONY: docker-image
docker-image: ## Builds the HTTP server docker image
	@docker build -t $(IMAGE) .

##@ Kind 
.PHONY: start
start: prereqs docker-image ## Starts the kind cluster (without breaking it)
	kind create cluster --config=manifests/kind.yaml --name=$(CLUSTER)
	kind load docker-image $(IMAGE) --name=$(CLUSTER)

.PHONY: teardown
teardown: ## Removes the kind cluster
	kind delete cluster --name=$(CLUSTER)

##@ Exercise

.PHONY: break
break: $(addsuffix -break,$(COMPONENTS)) ## Breaks all the components

.PHONY: fix
fix: etcd-fix $(addsuffix -fix, $(call reverse, $(COMPONENTS))) kubelet-fix ## Fixes all the components

.PHONY: check
check: $(addsuffix -check, $(call reverse, $(COMPONENTS))) etcd-check ## Check components health

.PHONY: deploy-app
deploy-app: ## Deploys a new application instance to be tested
	@kubectl create deploy $(DEPLOY_NAME) --replicas=$(REPLICAS) --image=$(IMAGE)
	@kubectl patch deploy $(DEPLOY_NAME) --type='json' \
	-p='[{"op": "replace", "path": "/spec/template/spec/containers/0/imagePullPolicy", "value": "IfNotPresent"}]'
	@kubectl expose deploy $(DEPLOY_NAME) --port=9000

.PHONY: remove-app
remove-app: ## Removes the previously deployed app
	@kubectl delete deploy $(DEPLOY_NAME)