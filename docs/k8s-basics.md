# k8s basics

* [Tutorial: Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)

## Basics: Pod, Worker Node, Master Node, Cluster

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

* Cluster: 管理多個 Master, Worker Node，可以理解為多個 VM 如何變為一個「大 VM」的方式
* Master Node: 實際的 VM，K8s 會由一個 Master Node 去管理底下多個 Worker Node
* Worker Node: 實際的 VM，裡頭管理著一個一個 Pod
* Pod: Pod 裡放著容器，容器通常為一個，但也可以多個
  * 針對單一 Pod 的設定，是用來建立獨立的 Pod，但多數我們不會這樣單獨使用，主要有幾個問題:
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

Note: Service. Pod 可以透過 port-forward 的指令 host 到本機上，但只能在前景執行，而且每個 pod 都要去執行一次也不太好管理，所以 Service 這個元件就誕生了，Service 主要可以想成是 Pod 的反代理機制，用來定義 Pod 如何被連線以及存取

Ref:

* [Kubernetes 基礎教學（二）實作範例：Pod、Service、Deployment、Ingress、Deployment](https://chengweihu.com/kubernetes-tutorial-2-service-deployment-ingress/#Kubernetes-%E9%80%B2%E9%9A%8E%E4%B8%89%E5%85%83%E4%BB%B6)
* [Kubernetes (四) - Pod 進階應用 : Service、Deployment、Ingress](https://hackmd.io/@tienyulin/kubernetes-service-deployment-ingress)
* [DAY18 — 了解 K8s 中的 Pod、Service、Deployment](https://medium.com/%E9%AB%92%E6%A1%B6%E5%AD%90/day18-%E4%BA%86%E8%A7%A3-k8s-%E4%B8%AD%E7%9A%84-pod-service-deployment-92408f9244e1)
* [k8s中几个基本概念的理解，pod,service,deployment,ingress的使用场景](https://www.cnblogs.com/ricklz/p/16684420.html)

## Configuration: ConfigMap

TODO Ref

* [Managing Resources](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)
  * [Configuring Redis using a ConfigMap](https://kubernetes.io/docs/tutorials/configuration/configure-redis-using-configmap/)
* <https://humanitec.com/blog/handling-environment-variables-with-kubernetes#using-kubernetes-variables>
  * <https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/>
  * <https://www.kisphp.com/kubernetes-manifests/configmap>
  * <https://earthly.dev/blog/kubernetes-config-maps/>

## sts: StatefulSet

## pvc: PersistentVolumeClaims

## Helm

TODO Ref

* <https://github.com/superj80820/2020-ithelp-contest/tree/master/DAY20>
