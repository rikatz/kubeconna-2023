# Learning Kubernetes by Chaos - Breaking a Kubernetes cluster to understand the components

This repo contains a set of scripts/programs that will help you to have your own 
broken Kubernetes cluster, and then fix it.


## Getting started
* Run `make start`
* Run `make break`
* Run `make deploy-app DEPLOY_NAME=app1`
* Run `make deploy-app DEPLOY_NAME=app2`


And start fixing the cluster until the Pods start running and you can call one and other
using services.

A valid output would be, from any pod of "app1", doing:
```
curl http://app2:9000
```

And receiving a `Hello World!!!`