# Load Balancing

## Purpose

## Core Concept

* LB (Load Balancing)
* L4 vs. L7 Load Balancing
* HA (High Availability)
* Nginx

## What is LB (Load Balancing)

## L4 vs. L7 Load Balancing

L4: TCP, IP:port
L7: HTTP, URL

* 4 层负载均衡本质是转发，而 7 层负载本质是内容交换和代理
* 四层通过虚拟 IP + 端口接收请求，然后再分配到真实的服务器；
* 七层通过虚拟的 URL 或主机名接收请求，然后再分配到真实的服务器。
* 还有基于 MAC 地址的二层负载均衡和基于 IP 地址的三层负载均衡。

* L4负载均衡：在传输层进行负载均衡的主要优势是速度快、效率高。L4负载均衡器基于传输层协议（如TCP、UDP）的信息，根据IP地址和端口号等进行负载均衡。这种方式适用于大规模的负载均衡需求，并且对于处理大量连接和数据包的场景非常有效。
* L7负载均衡：与L4负载均衡不同，L7负载均衡器在应用层面上操作。它能够识别和解析应用层协议（如HTTP、HTTPS），并根据更详细的请求信息（如URL、Header、Cookie等）来进行负载均衡。这种方式更加智能和灵活，可以实现针对应用层特定需求的负载均衡策略。

## k8s Load Balancing

### k8s `LoadBalancer`

* "Service" Object of type "LoadBalancer" that allows a service to be attached to a LoadBalancer
* "Load Balancer Controller" that creates Load Balancers based on rules defined in the Service Object

`LoadBalancer` type service is a **L4(TCP) load balancer**. You would use it to expose single app or service to outside world. It would balance the load based on destination IP address and port.

A kubernetes LoadBalancer service is a service that points to external load balancers that are NOT in your kubernetes cluster, but exist elsewhere. They can work with your pods, assuming that your pods are externally routable. Google and AWS provide this capability natively. In terms of Amazon, this maps directly with ELB and kubernetes when running in AWS can automatically provision and configure an ELB instance for each LoadBalancer service deployed.

You would use Loadbalancer type service if you would have a **single app**, say `myapp.com` that you want to be mapped to **an IP address**.

### k8s `Ingress`

* "Ingress" Object that does little on its own, but defines L7 Load Balancing rules
* "Ingress Controller" that watches state of Ingress Objects to create L7 LB configuration based on rules defined in the Ingress Objects

`Ingress` type resource would create a **L7(HTTP/S) load balancer**. You would use this to expose several services at the same time, as L7 LB is application aware, so it can determine where to send traffic depending on the application state.

An ingress is really just a set of rules to pass to a controller that is listening for them. You can deploy a bunch of ingress rules, but nothing will happen unless you have a controller that can process them. A LoadBalancer service could listen for ingress rules, if it is configured to do so.

You would use ingress resource if you would have several apps, say `myapp1.com, myapp1.com/mypath, myapp2.com, .., myappn.com` to be mapped to **one IP address**.

Ref:

* [Kubernetes NodePort vs LoadBalancer vs Ingress? When should I use what?](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
* [Ingress vs Load Balancer](https://stackoverflow.com/questions/45079988/ingress-vs-load-balancer)
* [What's the difference between exposing nginx as load balancer vs Ingress controller?](https://stackoverflow.com/questions/50966300/whats-the-difference-between-exposing-nginx-as-load-balancer-vs-ingress-control/50967732#50967732)

## Demo

## Ref

* [負載平衡和高度可用性](https://hackmd.io/@jiazheng/rJ-B1-QHd)
17/layer-4-layer-7-load-balancing/)
* [L4 vs L7 load balancing](https://tingyuchang.github.io/2021-09-27-L4-vs-L7-load-balancing/)
* [四层、七层负载均衡的区别](https://jaminzhang.github.io/lb/L4-L7-Load-Balancer-Difference/)
* [Nginx - What Is Load Balancing?](https://www.nginx.com/resources/glossary/load-balancing/)
  * [What Is Layer 7 Load Balancing?](https://www.nginx.com/resources/glossary/layer-7-load-balancing/)
