# Observability

* Grafana/Odigos + Prometheus + Loki + Jaeger/Tempo

Ref

* [k8s-cluster-bootstrapPublic](https://github.com/LeoVS09/k8s-cluster-bootstrap)
* [Service Mesh for Developers, Part 1: Exploring the Power of Observability and OpenTelemetry](https://www.solo.io/blog/service-mesh-for-developers-exploring-the-power-of-observability-and-opentelemetry/)

## Visualization: Grafana

Ref:

* [Learn O11y from Grafana ecosystem](https://www.slideshare.net/hongweiqiu/learn-o11y-from-grafana-ecosystem)

## Visualization: Odigos

* [Odigos - Quickstart](https://docs.odigos.io/intro)

### Installation

```sh
brew install keyval-dev/homebrew-odigos-cli/odigos
odigos install
odigos ui
# http://localhost:3000
```

### Introduction

```sh
minikube start

# Deploying the target application
kubectl apply -f https://raw.githubusercontent.com/keyval-dev/microservices-demo/master/release/kubernetes-manifests.yaml

# Deploying Jaeger
kubectl create ns tracing
kubectl apply -f https://raw.githubusercontent.com/keyval-dev/opentelemetry-go-instrumentation/master/docs/getting-started/jaeger.yaml -n tracing
# http://jaeger.tracing:4317

kubectl port-forward -n tracing svc/jaeger 16686:16686
# http://localhost:16686
```

Ref

* [可觀測性宇宙的第三十一天 - Grafana Tempo 搭配 Odigos 實現 NoCode Observability](https://ithelp.ithome.com.tw/articles/10340539)

## Metrics: Prometheus

<img style="width:60%;" src="https://picluster.ricsanfre.com/assets/img/prometheus-stack-architecture.png">
<p align="center"><sub><sup>
  <a href="https://picluster.ricsanfre.com/docs/prometheus/" target="_blank" rel="noreferrer noopenner">Prometheus Operator Architecture</a>
</sup></sub></p>

* [Kube-Prometheus-Stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

```sh
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack --values=values.yaml -n prometheus --create-namespace

kubectl port-forward service/prometheus-stack-prometheus 9090:9090 -n prometheus
# http://localhost:9090

kubectl port-forward service/prometheus-stack-grafana 3000:80 -n prometheus
# http://localhost:3000

kubectl port-forward service/prometheus-stack-alertmanager 9093:9093 -n prometheus
# http://localhost:9093
```

Ref:

* [Monitoring (Prometheus)](https://picluster.ricsanfre.com/docs/prometheus/)
* [可觀測性宇宙的第十二天 - Prometheus 全家桶介紹](https://ithelp.ithome.com.tw/articles/10329207)

## Logs: Loki

<img style="width:60%;" src="https://grafana.com/docs/loki/latest/get-started/loki_architecture_components.svg">
<p align="center"><sub><sup>
  <a href="https://grafana.com/docs/loki/latest/get-started/components/" target="_blank" rel="noreferrer noopenner">Grafana Loki Components</a>
</sup></sub></p>

```sh
helm upgrade --install loki grafana/loki -f values.yaml -f config.yaml -n logging 
```

* [Install Grafana Loki with Helm](https://grafana.com/docs/loki/latest/setup/install/helm/)
  * [Loki deployment modes](https://grafana.com/docs/loki/latest/get-started/deployment-modes/): Simple Scalable, Monolithic, Microservices
  * [Configure storage](https://grafana.com/docs/loki/latest/setup/install/helm/configure-storage/): The scalable installation requires a managed object store such as AWS S3 or Google Cloud Storage or a self-hosted store such as Minio. The single binary installation can only use the filesystem for storage.
* [Log Aggregation (Loki)](https://picluster.ricsanfre.com/docs/loki/)
* [可觀測性宇宙的第二十三天 - Grafana Loki 實戰](https://ithelp.ithome.com.tw/articles/10336360)

## Traces: Jaeger/Tempo
