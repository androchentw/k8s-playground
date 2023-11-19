# Observability

* Grafana/Odigos + Prometheus + Loki + Jaeger/Tempo
* Helm chart
  * prometheus-operator/kube-prometheus-stack
  * grafana/loki
  * grafana/promtail
  * grafana/tempo
  * bitnami/kubernetes-event-exporter

Ref

* [k8s-cluster-bootstrapPublic](https://github.com/LeoVS09/k8s-cluster-bootstrap)
* [Service Mesh for Developers, Part 1: Exploring the Power of Observability and OpenTelemetry](https://www.solo.io/blog/service-mesh-for-developers-exploring-the-power-of-observability-and-opentelemetry/)

## Endpoints Summary

```sh
# Prometheus: http://localhost:9090
kubectl port-forward service/kube-prometheus-stack-prometheus 9090:9090 -n prometheus

# Grafana: http://localhost:3000, admin/prom-operator
# if conflict with odigos, change to 3001
kubectl port-forward service/kube-prometheus-stack-grafana 3000:80 -n prometheus

# Alert Manager: http://localhost:9093
kubectl port-forward service/kube-prometheus-stack-alertmanager 9093:9093 -n prometheus

# Loki: http://localhost:3100
kubectl port-forward service/loki 3100:3100 -n loki

# Jaeger: http://localhost:16686
kubectl port-forward -n tracing svc/jaeger 16686:16686

# Odigos: http://localhost:3000
odigos ui
```

## Visualization: Grafana + Metrics: Prometheus

<img style="width:60%;" src="https://picluster.ricsanfre.com/assets/img/prometheus-stack-architecture.png">
<p align="center"><sub><sup>
  <a href="https://picluster.ricsanfre.com/docs/prometheus/" target="_blank" rel="noreferrer noopenner">Prometheus Operator Architecture</a>
</sup></sub></p>

* [Kube-Prometheus-Stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n prometheus --create-namespace
# NAME: kube-prometheus-stack
# LAST DEPLOYED: Sun Nov 19 17:08:05 2023
# NAMESPACE: prometheus
# STATUS: deployed
# REVISION: 1
# NOTES:
# kube-prometheus-stack has been installed. Check its status by running:
#   kubectl --namespace prometheus get pods -l "release=kube-prometheus-stack"

# Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

# check status or k8s dashboard
kubectl get all -n prometheus
# NAME                                                            READY   STATUS    RESTARTS   AGE
# pod/alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   0          3m21s
# pod/kube-prometheus-stack-grafana-c66f48bbd-nrlxv               3/3     Running   0          3m50s
# pod/kube-prometheus-stack-kube-state-metrics-7ccc7bb9c9-rf225   1/1     Running   0          3m50s
# pod/kube-prometheus-stack-operator-5cffdd6b96-fxwh9             1/1     Running   0          3m50s
# pod/kube-prometheus-stack-prometheus-node-exporter-4s9hw        1/1     Running   0          3m50s
# pod/prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   0          3m21s

# NAME                                                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
# service/alertmanager-operated                            ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   3m22s
# service/kube-prometheus-stack-alertmanager               ClusterIP   10.102.13.150   <none>        9093/TCP,8080/TCP            3m50s
# service/kube-prometheus-stack-grafana                    ClusterIP   10.98.123.147   <none>        80/TCP                       3m50s
# service/kube-prometheus-stack-kube-state-metrics         ClusterIP   10.110.201.13   <none>        8080/TCP                     3m50s
# service/kube-prometheus-stack-operator                   ClusterIP   10.101.13.210   <none>        443/TCP                      3m50s
# service/kube-prometheus-stack-prometheus                 ClusterIP   10.98.148.130   <none>        9090/TCP,8080/TCP            3m50s
# service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   10.111.35.212   <none>        9100/TCP                     3m50s
# service/prometheus-operated                              ClusterIP   None            <none>        9090/TCP                     3m21s

# NAME                                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
# daemonset.apps/kube-prometheus-stack-prometheus-node-exporter   1         1         1       1            1           kubernetes.io/os=linux   3m50s

# NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/kube-prometheus-stack-grafana              1/1     1            1           3m50s
# deployment.apps/kube-prometheus-stack-kube-state-metrics   1/1     1            1           3m50s
# deployment.apps/kube-prometheus-stack-operator             1/1     1            1           3m50s

# NAME                                                                  DESIRED   CURRENT   READY   AGE
# replicaset.apps/kube-prometheus-stack-grafana-c66f48bbd               1         1         1       3m50s
# replicaset.apps/kube-prometheus-stack-kube-state-metrics-7ccc7bb9c9   1         1         1       3m50s
# replicaset.apps/kube-prometheus-stack-operator-5cffdd6b96             1         1         1       3m50s

# NAME                                                               READY   AGE
# statefulset.apps/alertmanager-kube-prometheus-stack-alertmanager   1/1     3m22s
# statefulset.apps/prometheus-kube-prometheus-stack-prometheus       1/1     3m21s

# Prometheus: http://localhost:9090
kubectl port-forward service/kube-prometheus-stack-prometheus 9090:9090 -n prometheus

# Grafana: http://localhost:3000, admin/prom-operator
kubectl port-forward service/kube-prometheus-stack-grafana 3000:80 -n prometheus

# Alert Manager: http://localhost:9093
kubectl port-forward service/kube-prometheus-stack-alertmanager 9093:9093 -n prometheus
```

Ref:

* [Monitoring (Prometheus)](https://picluster.ricsanfre.com/docs/prometheus/)
* [可觀測性宇宙的第十二天 - Prometheus 全家桶介紹](https://ithelp.ithome.com.tw/articles/10329207)
  * [可觀測性宇宙的第十三天 - Kube-Prometheus-Stack 實戰（一）](https://ithelp.ithome.com.tw/articles/10329845)
* [Learn O11y from Grafana ecosystem](https://www.slideshare.net/hongweiqiu/learn-o11y-from-grafana-ecosystem)

## Logs: Loki

TODO: not working yet

<img style="width:60%;" src="https://grafana.com/docs/loki/latest/get-started/loki_architecture_components.svg">
<p align="center"><sub><sup>
  <a href="https://grafana.com/docs/loki/latest/get-started/components/" target="_blank" rel="noreferrer noopenner">Grafana Loki Components</a>
</sup></sub></p>

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki -n loki --create-namespace
# NAME: loki
# LAST DEPLOYED: Sun Nov 19 17:40:59 2023
# NAMESPACE: loki
# STATUS: deployed
# REVISION: 1
# NOTES:
# ***********************************************************************
#  Welcome to Grafana Loki
#  Chart version: 5.36.3
#  Loki version: 2.9.2
# ***********************************************************************

# Installed components:
# * grafana-agent-operator
# * loki

kubectl get all -n loki
# NAME                                              READY   STATUS    RESTARTS   AGE
# pod/loki-0                                        1/1     Running   0          3m29s
# pod/loki-canary-hsb4l                             1/1     Running   0          3m30s
# pod/loki-gateway-77dbc88549-scf6q                 1/1     Running   0          3m30s
# pod/loki-grafana-agent-operator-9fd6fc77c-schdf   1/1     Running   0          3m30s
# pod/loki-logs-lcr5w                               2/2     Running   0          3m12s

# NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
# service/loki              ClusterIP   10.104.79.112    <none>        3100/TCP,9095/TCP   3m30s
# service/loki-canary       ClusterIP   10.107.39.211    <none>        3500/TCP            3m30s
# service/loki-gateway      ClusterIP   10.103.142.173   <none>        80/TCP              3m30s
# service/loki-headless     ClusterIP   None             <none>        3100/TCP            3m30s
# service/loki-memberlist   ClusterIP   None             <none>        7946/TCP            3m30s

# NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
# daemonset.apps/loki-canary   1         1         1       1            1           <none>          3m30s
# daemonset.apps/loki-logs     1         1         1       1            1           <none>          3m12s

# NAME                                          READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/loki-gateway                  1/1     1            1           3m30s
# deployment.apps/loki-grafana-agent-operator   1/1     1            1           3m30s

# NAME                                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/loki-gateway-77dbc88549                 1         1         1       3m30s
# replicaset.apps/loki-grafana-agent-operator-9fd6fc77c   1         1         1       3m30s

# NAME                    READY   AGE
# statefulset.apps/loki   1/1     3m30s

# Loki: http://localhost:3100 
kubectl port-forward service/loki 3100:3100 -n loki
# Configure grafana http://localhost:3000
# Connections > Data sources > Add data source: Loki, URL: http://localhost:3100 
```

```sh
helm upgrade --install loki grafana/loki-distributed -n logging --create-namespace
# Release "loki" does not exist. Installing it now.
# NAME: loki
# LAST DEPLOYED: Sun Nov 19 18:10:59 2023
# NAMESPACE: logging
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:
# ***********************************************************************
#  Welcome to Grafana Loki
#  Chart version: 0.76.1
#  Loki version: 2.9.2
# ***********************************************************************

# Installed components:
# * gateway
# * ingester
# * distributor
# * querier
# * query-frontend

helm upgrade --install promtail grafana/promtail -n logging
# Release "promtail" does not exist. Installing it now.
# NAME: promtail
# LAST DEPLOYED: Sun Nov 19 18:11:37 2023
# NAMESPACE: logging
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:
# ***********************************************************************
#  Welcome to Grafana Promtail
#  Chart version: 6.15.3
#  Promtail version: 2.9.2
# ***********************************************************************

# Verify the application is working by running these commands:
# * kubectl --namespace logging port-forward daemonset/promtail 3101
# * curl http://127.0.0.1:3101/metrics
```

* [Install Grafana Loki with Helm](https://grafana.com/docs/loki/latest/setup/install/helm/)
  * [Loki deployment modes](https://grafana.com/docs/loki/latest/get-started/deployment-modes/): Simple Scalable, Monolithic, Microservices
  * [Configure storage](https://grafana.com/docs/loki/latest/setup/install/helm/configure-storage/): The scalable installation requires a managed object store such as AWS S3 or Google Cloud Storage or a self-hosted store such as Minio. The single binary installation can only use the filesystem for storage.
* [Log Aggregation (Loki)](https://picluster.ricsanfre.com/docs/loki/)
* [可觀測性宇宙的第二十三天 - Grafana Loki 實戰](https://ithelp.ithome.com.tw/articles/10336360)

## Traces: Jaeger/Tempo

## Visualization: Odigos

* [Odigos - Quickstart](https://docs.odigos.io/intro)

### Installation

```sh
brew install keyval-dev/homebrew-odigos-cli/odigos
odigos install

# Odigos: http://localhost:3000
odigos ui
```

### Introduction

```sh
minikube start

# Deploying the target application
kubectl apply -f https://raw.githubusercontent.com/keyval-dev/microservices-demo/master/release/kubernetes-manifests.yaml
# default > select all

# Deploying Jaeger
# jaeger > tracing, jaeger.tracing:4317
kubectl create ns tracing
kubectl apply -f https://raw.githubusercontent.com/keyval-dev/opentelemetry-go-instrumentation/master/docs/getting-started/jaeger.yaml -n tracing

# helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
# helm install jaeger jaegertracing/jaeger

# Jaeger: http://localhost:16686
kubectl port-forward -n tracing svc/jaeger 16686:16686
```

Ref

* [可觀測性宇宙的第三十一天 - Grafana Tempo 搭配 Odigos 實現 NoCode Observability](https://ithelp.ithome.com.tw/articles/10340539)
* [Odigos: 一款助你在 Kubernetes 上快速构建端到端无侵入的可观测解决方案](https://blog.csdn.net/easylife206/article/details/130652425)
