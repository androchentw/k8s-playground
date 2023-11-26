# Service Discovery

Service Discovery in k8s 教學

## Purpose

1. 當 workload 變成 micro service(pod) 進到 k8s 後,在存取上會遇到什麼問題?
2. Service 如何解決這些問題?
3. 當我們需要 外界 <-> Pod 或者 Pod <-> Pod 通訊時,就需要靠 K8S 的 服務探索機制 (Service Discovery) 來達成

## Core Concept

1. k8s service definition
2. VIP(Virtual IPs) & Service Proxy
3. Service types
4. Service discovery
5. DNS
6. TLS, SSL, Certificate

## Pod and Service

Pod access

* Dynamic pod life cycle -> Dynamic IP & corresponding service

Service

1. Service: Domain name <-> Pod
   1. Service VIP
   2. Selector
2. kube-proxy in every k8s node

## Service Discovery Concepts

1. Register, 服務啟動時的註冊機制 (如前面所述)
2. Query, 查詢已註冊服務資訊的機制
3. Healthy Check, 確認服務健康狀態的機制

## Service Discovery

* Service 身為多個 pod 的服務入口,必須要有簡單的方式可以找到這些 Service
* 所謂 Service Discovery 即是透過一些機制 (例如 DNS) 來找到路由至 Pod 的方法. 只要需要對 Pod 做通訊,就需要建立 Service 資源
* 在 k8s 中提供了兩種模式來進行 service discovery,分別是環境變數 & DNS
* Pod 自己不是都有自己的 IP 嗎? 為什麼要多一個 Service?
  * 雖然每一個 Pod 本身都自帶一個 SDN 的 IP,但 Pod IP 本身是 K8S 叢集內的通訊用的 虛擬內部 IP 網段,無法直接讓外界路由進來
  * Pod 的 IP 都是隨機浮動的,因此即使是 Pod <-> Pod 通訊,程式設計師也不應該直接使用 Pod IP

## Service Types

* ClusterIP:提供 cluster 內部存取
* NodePort:供外部存取
* LoadBalancer:供外部存取 (但只限於支援此 type 的 public cloud)
* ExternalName:單純回應給 client 外部的 DNS CName record (並非由 k8s cluster 內部的 pod 服務)

## Demo

## Ref

* [Kubernetes Service Overview](https://godleon.github.io/blog/Kubernetes/k8s-Service-Overview/)
* [雲端容器化技術與資源調度](https://www.profyu.com/course/cloud-container-k8s-service.html)
* [服务发现与负载均衡](https://jimmysong.io/kubernetes-handbook/practice/service-discovery-and-loadbalancing.html)
* [微服務基礎建設 - Service Discovery](https://columns.chicken-house.net/2017/12/31/microservice9-servicediscovery/)
