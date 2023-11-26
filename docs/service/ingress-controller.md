# Ingress Controller

## Purpose

* 若要接收外部的 HTTP 請求,則需透過配置一個 Ingress Controller 來接收與處理
* Kubernetes 普遍所使用的反向代理機制為官方所推出的 ingress-nginx
* 使多個節點的集群都對應到同一個 Domain 上,即是透過 LoadBalancer 進行請求的轉發

### Core Concepts

* Reverse proxy
* Load balance
* Nginx
* TLS, SSL, Certificate

## k8s Load Balance Type

* Service:直接用 Service 提供 cluster 內部的負載均衡,並藉助 cloud provider 提供的 LB 提供外部訪問
* Ingress Controller:還是用 Service 提供 cluster 內部的負載均衡,但是通過自定義 LB 提供外部訪問
* Ingress 本身並不會自動創建負載均衡器,cluster 中需要運行一個 ingress controller 來根據 Ingress 的定義來管理負載均衡器
* 透過 Ingress 可以處理 layer 7 (HTTP) 的流量
* Service Load Balancer:把 load balancer 直接跑在容器中,實現 Bare Metal 的 Service Load Balancer
* Custom Load Balancer:自定義負載均衡,並替代 kube-proxy,一般在物理部署 Kubernetes 時使用,方便接入公司已有的外部服務

## Demo: Ingress Controller

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.28.0/deploy/static/mandatory.yaml

kubectl get pods -n ingress-nginx

kubectl get svc —n ingress-nginx
# EXTERNAL-IP, Port: 80, 443

kubectl exec -ti -n ingress-nginx PodName -- /bin/sh

cat nginx.conf
```

sample app

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: app-ingress
  namespace: test
spec:
  rules:
  - host: app.domain.com
    http:
      paths:
      - backend:
          serviceName: app
          servicePort: 8080
```

## Ref

* [為 k8s 加上 Ingress Controller 來接收外部請求](https://luthertsai.com/kubernetes-notes-ingress-controller-setup/)
* [Kubernetes 那些事 — Ingress 篇(一)](https://medium.com/andy-blog/kubernetes-那些事-ingress-篇-一-92944d4bf97d)
* [Kubernetes 那些事 — Ingress 篇(二)](https://medium.com/andy-blog/kubernetes-那些事-ingress-篇-二-559c7a41404b)
* [Kubernetes Ingress 實戰](https://tsunghsien.gitbooks.io/kubenetes/content/ingresspei-zhi.html)
* [服务发现与负载均衡](https://jimmysong.io/kubernetes-handbook/practice/service-discovery-and-loadbalancing.html)
* [Kubernetes Documentation - Services, Load Balancing, and Networking](https://kubernetes.io/docs/concepts/services-networking/): Service, Ingress, Ingress Controllers
