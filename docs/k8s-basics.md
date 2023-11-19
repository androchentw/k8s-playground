# k8s basics

* [Tutorial: Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
* Check [minikube/README.md](minikube/README.md) for more information about setup and sample code.

## Basics: Cluster, Master Node, Worker Node, Pod

<img style="width:50%;" src="https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg">
<p align="center"><sub><sup>
  <a href="https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/" target="_blank" rel="noreferrer noopenner">k8s tutorial - Node Overivew</a>
</sup></sub></p>

<img style="width:50%;" src="https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg">
<p align="center"><sub><sup>
  <a href="https://kubernetes.io/docs/tutorials/kubernetes-basics/explore/explore-intro/" target="_blank" rel="noreferrer noopenner">k8s tutorial - Pods Overivew</a>
</sup></sub></p>

<img style="width:60%;" src="https://4.bp.blogspot.com/-EwaeByngT_s/VreBpWmU5bI/AAAAAAAABrU/TOd81z-L1rY/s1600/archi.jpg">
<p align="center"><sub><sup>
  <a href="https://nishadikirielle.blogspot.com/2016/02/kubernetes-at-first-glance.html" target="_blank" rel="noreferrer noopenner">Kubernetes, At A First Glance - k8s Architecture</a>
</sup></sub></p>

### Cluster

* Kubernetes 中多個 Node 與 Master 的集合，管理多個 Master, Worker Node，。基本上可以想成在同一個環境裡所有 Node 集合在一起的單位。

### Master Node

* Kubernetes 運作的指揮中心，可以簡化看成一個特化的 Node 負責管理所有其他 Node。
* 包含 kube-apiserver、etcd、kube-scheduler、kube-controller-manager。

### Worker Node

* Kubernetes 運作的最小硬體單位，一個 Worker Node（簡稱 Node）對應到一台機器，可以是實體機如你的筆電、或是虛擬機如 AWS 上的一台 EC2 或 GCP 上的一台 Computer Engine。
* 包含 kubelet、kube-proxy、Container Runtime

### Pod

* Kubernetes 運作的最小單位，一個 Pod 對應到一個應用服務（Application），舉例來說一個 Pod 可能會對應到一個 API Server。
* 一個 Pod 裡面可以有一個或是多個 Container，但一般情況一個 Pod 最好只有一個 Container
* 同一個 Pod 中的 Containers 共享相同資源及網路，彼此透過 local port number 溝通
* `pod.yaml` 是針對單一 Pod 的設定，用來建立獨立的 Pod，但多數我們不會這樣單獨使用，主要有幾個問題:
  * 獨立的 pod 若是發生問題時(例如: node failure)，k8s 不會協助恢復其正常的狀態
  * 若 pod 所在的 worker node 因為資源不足或是進入維護狀態時，pod 不會被自動移到其他正常的 node 並重新啟動

[`deployment.yaml` spec](https://github.com/superj80820/2020-ithelp-contest/blob/master/DAY18/server-service.yaml)

* spec.replicas: 此 Pod 會在 K8s 有幾個橫向擴展(Horizontal Pod Autoscaler)，目前設定一個
* spec.strategy: 可以設定狀態變化對應機制的策略，例如 image 降版要要維持幾個 Pod 之類，這邊使用預設值
* spec.template.spec.containers: 設置容器
* spec.template.spec.containers.command: 容器的啟動 command
* spec.template.spec.containers.image: 容器使用的 image
* spec.template.spec.containers.ports: 容器使用的 port
* spec.template.spec.containers.restartPolicy: 容器是否無預期關閉後要重新啟動

[`service.yaml` spec](https://github.com/superj80820/2020-ithelp-contest/blob/master/DAY18/server-deployment.yaml)

* spec.ports.ports: 說明對外可連入的 port 為何
* spec.ports.targetPort: 說明對外連入的 port 對應到 Pod 的哪個 port
* spec.ports.selector: 此規則要套用到哪個 label 上

Ref:

* [Kubernetes 基礎教學（一）原理介紹](https://chengweihu.com/kubernetes-tutorial-1-pod-node/#Kubernetes-%E5%9B%9B%E5%85%83%E4%BB%B6)
* [Kubernetes 初戰(一) 基本單元 Pod、Node、Service、Deployment](https://bingdoal.github.io/deploy/2021/02/kubernetes-beginning/)

## Advanced: Service, Deployment, Ingress

<img style="width:60%;" src="https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg">
<p align="center"><sub><sup>
  <a href="https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/" target="_blank" rel="noreferrer noopenner">k8s tutorial - Using a Service to Expose Your App</a>
</sup></sub></p>

### Service

* Expose your pods for outside to reach
  * ClusterIP, NodePort, LoadBalancer, ExternalName
* 定義「一群 Pod 要如何被連線及存取」的元件
* Pod 可以透過 `kubectl port-forward` 的指令 host 到本機上，但只能在前景執行，而且每個 pod 都要去執行一次也不太好管理，所以 Service 這個元件就誕生了，Service 主要可以想成是 Pod 的反代理機制，用來定義 Pod 如何被連線以及存取
* [Kubernetes Service Overview](https://godleon.github.io/blog/Kubernetes/k8s-Service-Overview/)

### Deployment

<img style="width:60%;" src="https://storage.googleapis.com/cdn.thenewstack.io/media/2017/11/07751442-deployment.png">
<p align="center"><sub><sup>
  <a href="https://thenewstack.io/kubernetes-deployments-work" target="_blank" rel="noreferrer noopenner">ReplicaSet</a>
</sup></sub></p>

* scale out pods
* `spec.replicas`

### Ingress

<img style="width:60%;" src="https://chengweihu.com/static/0020e6bdf72babb7d4e153139d3f568f/2bef9/image-3.png">
<p align="center"><sub><sup>
  <a href="https://chengweihu.com/kubernetes-tutorial-2-service-deployment-ingress" target="_blank" rel="noreferrer noopenner">Kubernetes 基礎教學（二）實作範例：Pod、Service、Deployment、Ingress | Cheng-Wei Hu</a>
</sup></sub></p>

* Ingress controller + reverse proxy
  * [What is the difference between an Ingress and a reverse proxy?](https://stackoverflow.com/questions/59709514/what-is-the-difference-between-an-ingress-and-a-reverse-proxy)

Ref:

* [Kubernetes 基礎教學（二）實作範例：Pod、Service、Deployment、Ingress、Deployment](https://chengweihu.com/kubernetes-tutorial-2-service-deployment-ingress/#Kubernetes-%E9%80%B2%E9%9A%8E%E4%B8%89%E5%85%83%E4%BB%B6)
* [Kubernetes (四) - Pod 進階應用 : Service、Deployment、Ingress](https://hackmd.io/@tienyulin/kubernetes-service-deployment-ingress)
* [DAY18 — 了解 K8s 中的 Pod、Service、Deployment](https://medium.com/%E9%AB%92%E6%A1%B6%E5%AD%90/day18-%E4%BA%86%E8%A7%A3-k8s-%E4%B8%AD%E7%9A%84-pod-service-deployment-92408f9244e1)
* [k8s中几个基本概念的理解，pod,service,deployment,ingress的使用场景](https://www.cnblogs.com/ricklz/p/16684420.html)

## Labels & Selectors

<img style="width:50%;" src="https://assets-global.website-files.com/61c02e339c11997e6926e3d9/61c093a693fd42c2d52eb62a_602c569e5e6e7537bc35799a_TYU0FzP808wO7i21lCVLrwNQHDid7p-DEEKPX7y61O4Yqe17MWvMU4gVS6ZcSWYEz0jbwQ6LSCRv4rw5zsKH-6CBYn95EDvZ5Sh4BprrkBx821ylBC85xb710oIBfirSbxtjzFs.png">
<p align="center"><sub><sup>
  <a href="https://www.datree.io/resources/a-kubernetes-guide-for-labels-and-selectors" target="_blank" rel="noreferrer noopenner">Labels & Selectors</a>
</sup></sub></p>

With labels, Kubernetes is able to glue resources together when one resource needs to relate or manage another resource. For example: a Deployment that needs to know how many Pods to spin-up or a Service that needs to expose some Pods.

* Labels: Labels are nothing more than custom key-value pairs that are attached to objects and are used to describe and manage different Kubernetes resources.
* Selectors: A label selector is just a fancy name of the mechanism that enables the client/user to target (select) a set of objects by their labels.

## Configuration: ConfigMap

<img style="width:50%;" src="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt7118bc80b8cd018a/62f50128d3b8a57004568c03/ConfigMap_Diagram.jpg">
<p align="center"><sub><sup>
  <a href="https://www.weave.works/blog/kubernetes-configmap" target="_blank" rel="noreferrer noopenner">ConfigMap</a>
</sup></sub></p>

TODO Ref

* [Managing Resources](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)
  * [Configuring Redis using a ConfigMap](https://kubernetes.io/docs/tutorials/configuration/configure-redis-using-configmap/)
* <https://humanitec.com/blog/handling-environment-variables-with-kubernetes#using-kubernetes-variables>
  * <https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/>
  * <https://www.kisphp.com/kubernetes-manifests/configmap>
  * <https://earthly.dev/blog/kubernetes-config-maps/>

## sts: StatefulSet

<img style="width:60%;" src="https://loft.sh/images/blog/posts/stateful-set-bp-2.png?nf_resize=fit&w=1040">
<p align="center"><sub><sup>
  <a href="https://loft.sh/blog/kubernetes-statefulset-examples-and-best-practices/" target="_blank" rel="noreferrer noopenner">Kubernetes StatefulSet - Examples & Best Practices</a>
</sup></sub></p>

## pvc: PersistentVolumeClaims

## DaemonSet

<img style="width:60%;" src="https://www.bluematador.com/hs-fs/hubfs/blog/new/An%20Introduction%20to%20Kubernetes%20DaemonSets/DaemonSets.png?width=1540&name=DaemonSets.png">
<p align="center"><sub><sup>
  <a href="https://www.bluematador.com/blog/an-introduction-to-kubernetes-daemonsets" target="_blank" rel="noreferrer noopenner">An introduction to Kubernetes DaemonSets</a>
</sup></sub></p>

A Kubernetes DaemonSet is a container tool that ensures that all nodes (or a specific subset of them) are running exactly one copy of a pod.

When using Kubernetes, most of the time you don't care where your pods are running, but sometimes you want to run a single pod on all your nodes. For example, you might want to run fluentd on all your nodes to collect logs. In this case, using a DaemonSet tells Kubernetes to make sure there is one instance of the pod on nodes in your cluster.

## Others

* [A Practical Guide to Setting Kubernetes Requests and Limits](https://blog.kubecost.com/blog/requests-and-limits/)
* [Kubernetes : Pod scheduling/eviction relationship with requests/limits](https://stackoverflow.com/questions/60790213/kubernetes-pod-scheduling-eviction-relationship-with-requests-limits)
* [Understanding Kubernetes Evicted Pods](https://sysdig.com/blog/kubernetes-pod-evicted/)
* [Health Check & Self Healing - K8s Probes - Liveness, Readiness, Startup Examples | Devops Junction](https://www.middlewareinventory.com/blog/k8s-probes-liveness-readiness-startup-examples-devops-junction/)

## Helm Chart

* package managment

### Install

* [Helm Quickstart Guide](https://helm.sh/docs/intro/quickstart/)

```sh
brew install kubernetes-helm
```

### Introduction

`helm create helm-demo`

```text
.
├── Chart.yaml    # Metadata
├── charts        # SubCharts
├── templates     # Components
│   ├── deployment.yaml
│   ├── ingress.yaml
│   └── service.yaml
└── values.yaml   # environment values
```

### Helm Chart Template Guide

* [Helm Chart Template Guide](https://helm.sh/docs/chart_template_guide/getting_started/)
* [Helm - Templating variables in values.yaml](https://stackoverflow.com/questions/55958507/helm-templating-variables-in-values-yaml)

[https://humalect.com/blog/kustomize-vs-helm#when-to-use-helm-vs-kustomize](https://humalect.com/blog/kustomize-vs-helm#when-to-use-helm-vs-kustomize)

### [Combine Helm and Kustomize Deployments](https://humalect.com/blog/kustomize-vs-helm#when-to-use-helm-vs-kustomize)

* kustomize
  * Customizing Manifests
  * Multi-Environment Management
* helm
  * Packaging Complex Applications
  * Managing Releases
  * Centralized Configuration

Ref

* [Kubernetes 基礎教學（三）Helm 介紹與建立 Chart](https://chengweihu.com/kubernetes-tutorial-3-helm/)
* [DAY20 — 利用 Helm 把 K8s 元件都包裝起來吧！](https://github.com/superj80820/2020-ithelp-contest/tree/master/DAY20)
