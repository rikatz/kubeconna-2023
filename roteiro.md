
# Parte 1 - Fixing control plane

## Api Server 

```
kubectl version
export CLUSTER=kubeconna2023
docker exec -it ${CLUSTER}-control-plane /bin/bash
crictl ps
cp /kubemanifests/kube-apiserver.yaml /etc/kubernetes/manifests
kubectl version
kubectl get ns
```

## Controller-Manager

```
make deploy-app DEPLOY_NAME=app1
kubectl get pods 
kubectl get deploy
kubectl get replicaset
docker exec -it ${CLUSTER}-control-plane /bin/bash
cp /kubemanifests/kube-controller-manager.yaml /etc/kubernetes/manifests
crictl ps
kubectl get replicaset -w
kubectl get deploy
```

## Scheduler

```
kubectl get pods 
kubectl describe pod $app1
kubectl get nodes
docker exec -it ${CLUSTER}-control-plane /bin/bash
cp /kubemanifests/kube-scheduler.yaml /etc/kubernetes/manifests
kubectl get pods 
kubectl get pods -o wide
```


# Parte 2 - Redes 


## CNI
```
kubectl exec -it $app1 -- /bin/bash
curl 127.0.0.1:9000
curl $app1-2:9000
explicar do cni
kubectl get daemonset -n kube-system kindnet 
olha a cagada:
kubernetes.io/os=notlinux
kubectl edit daemonset -n kube-system kindnet
kubectl get pods -n kube-system
make cni-check
kubectl get pods -o wide 
kubectl exec -it $app1 -- /bin/bash
curl $app1-2:9000
```

## Kubeproxy

```
make deploy-app DEPLOY_NAME=app2
kubectl get svc 
kubectl get pods -o wide
kubectl exec -it $app1 -- /bin/bash 
curl ip-svc2:9000
make proxy-check
kubectl edit daemonset -n kube-system kube-proxy
kubectl get pods -n kube-system -o wide 
kubectl get svc 
kubectl get pods 
kubectl exec -it $app1 -- curl 10.96.172.91:9000
```

## CoreDNS 
```
kubectl exec -it $app1 -- curl app2.default.svc.cluster.local:9000
kubectl exec -it $app1 -- curl google.com
kubectl get deploy -n kube-system
kubectl edit deploy coredns -n kube-system 
kubectl get deploy -n kube-system 
kubectl get pods -n kube-system
kubectl exec -it $app1 -- curl google.com
kubectl exec -it $app1 -- curl app2.default.svc.cluster.local:9000
```

# bonus

## kubelet 

```
make kubelet-break 
make deploy-app DEPLOY_NAME=app3
kubectl get pods -o wide 
make kubelet-fix 
kubectl get pods 
```

## netpol
```
vim manifests/netpol.yaml
kubectl apply -f manifests/netpol.yaml
kubectl get pods -o wide 
kubectl exec -it $app2 -- curl 10.244.3.2:9000
kubectl exec -it $app3 -- curl 10.244.3.2:9000
make netpol-setup
kubectl get pods -n kube-system
kubectl exec -it $app2 -- curl 10.244.3.2:9000
kubectl exec -it $app3 -- curl 10.244.3.2:9000
```




