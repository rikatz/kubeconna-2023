# Learning Kubernetes by Chaos - Breaking a Kubernetes cluster to understand the components

This repo contains a set of scripts/programs that will help you to have your own 
broken Kubernetes cluster, and then fix it.

**WORK IN PROGRESS** - This repo is a Work in Progress and we plan to document all the items we 
covered during the presentation + some additional docs!!

## Pre requisites
* [Kubectl](https://www.downloadkubernetes.com/)
* [Docker](https://docs.docker.com/engine/install/)
* [KinD](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

## Getting started
* Clone this repo: `git clone https://github.com/rikatz/kubeconna-2023.git`
* Run `make start`
After this you will have a kind clusters and you should expect a functional kind cluster.

* Run `make break`
With this make break everything should be broken (duh).

* Run `make help` if you want to explore other possible make targets. 


* Run `make deploy-app DEPLOY_NAME=app1`
* Run `make deploy-app DEPLOY_NAME=app2`


And start fixing the cluster until the Pods start running and you can call one and other
using services.

A valid output would be, from any pod of "app1", doing:
```
curl http://app2:9000
```

And receiving a `Hello World!!!`
