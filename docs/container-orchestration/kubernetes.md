---
icon: chart-network
---

# Kubernetes

* Kubernetes CLI (`kubectl`) allows **deploying and scaling** thousands of application instances with a single command.&#x20;

```bash
kubectl run --replicas=1000 my-web-server

kubectl scale --replicas=2000 my-web-server
```

* It can also be configured for **automatic scaling** based on user load.&#x20;
  * POD AutoScalers
  * Cluster AutoScalers



Kubernetes supports

* **rolling upgrades**

```bash
kubectl rolling-update my-web-server --image=web-server:2
```

* **rollbacks**&#x20;

```bash
kubectl rolling-update my-web-server --rollback
```

* **A/B testing**: can test new features of the application by only upgrading a percentage of instances through AB testing methods



* Its **open architecture** accommodates&#x20;
  * various **network and storage plugins**,&#x20;
  * supports multiple **authentication and authorization methods**, and &#x20;
  * natively supported by major **cloud provider**



## Kubernetes & Docker

{% hint style="success" %}
**Kubernetes uses Docker host to host applications in the form of Docker containers**.&#x20;
{% endhint %}

* Kubernetes also supports alternatives to Dockers such as `Rkt (Rocket)` and `CRI-O`.&#x20;



## Kubernetes Architecture

`nodes`: physical or virtual machine which has Kubernetes software and set of tools installed

* worker machine
* where containers will be launched by Kubernetes

`cluster`: set of nodes grouped together

* cluster makes sure that the application is accessible form another node, even if one node fails,

`master`: a node where the Kubernetes control plane component is installed

* **manages the cluster**: watches over the nodes in the cluster and is responsible for the actual orchestration of containers on the worker nodes
  * stores information about the members of the cluster&#x20;
  * monitor nodes (whether they fail)
  * handles moving the workload of the failed node to another worker node



### Components

* an `API server`: **front end** for Kubernetes&#x20;
  * all interactions with the Kubernetes cluster, including those from users, management devices, and command-line interfaces, go through the API server
* an `etcd server`: a **distributed** reliable **key value store** used by Kubernetes to store all data used to manage the cluster
  * stores cluster information (multiple nodes - multiple masters) across all nodes in a distributed manner and ensures no conflicts between masters by implementing locks
* a `scheduler service` : responsible for **distributing work** or containers across multiple nodes
  * looks for newly created containers and assigns them to nodes and makes decisions to bring up new containers in such cases
* a `container runtime`: the **underlying software** that is used **to run containers**
  * an engine like Docker&#x20;
* a bunch of `controllers`: brain behind **orchestration**
  * responsible for noticing and responding when nodes, containers, or endpoints goes down
* a `kubelet`: the **agent** that **runs on each node** in the cluster
  * responsible for making sure that the containers are running on the nodes as expected



## Kubernetes CLI: `kubectl`

Deploy an application on the cluster

```bash
kubectl run hello-minikube
```

View information about the cluster

```bash
kubectl cluster-info
```

List all the nodes of the cluster

```bash
kubectl get nodes
```

Running multiple instances of an appplication

```bash
kubectl run --replicas=1000 my-web-server
```
