# Observability

* Grafana + Prometheus + Loki + Jaegar/Tempo

Ref

* [k8s-cluster-bootstrapPublic](https://github.com/LeoVS09/k8s-cluster-bootstrap)

## Visualization: Grafana

Ref:

* [Learn O11y from Grafana ecosystem](https://www.slideshare.net/hongweiqiu/learn-o11y-from-grafana-ecosystem)

## Metrics: Prometheus

<img style="width:60%;" src="https://picluster.ricsanfre.com/assets/img/prometheus-stack-architecture.png">
<p align="center"><sub><sup>
  <a href="https://picluster.ricsanfre.com/docs/prometheus/" target="_blank" rel="noreferrer noopenner">Prometheus Operator Architecture</a>
</sup></sub></p>

[Kube-Prometheus-Stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

Ref:

* [Monitoring (Prometheus)](https://picluster.ricsanfre.com/docs/prometheus/)
* [可觀測性宇宙的第十二天 - Prometheus 全家桶介紹](https://ithelp.ithome.com.tw/articles/10329207)

## Logs: Loki

<img style="width:60%;" src="https://grafana.com/docs/loki/latest/get-started/loki_architecture_components.svg">
<p align="center"><sub><sup>
  <a href="https://grafana.com/docs/loki/latest/get-started/components/" target="_blank" rel="noreferrer noopenner">Grafana Loki Components</a>
</sup></sub></p>

* [Install Grafana Loki with Helm](https://grafana.com/docs/loki/latest/setup/install/helm/)
  * [Loki deployment modes](https://grafana.com/docs/loki/latest/get-started/deployment-modes/): Simple Scalable, Monolithic, Microservices
  * [Configure storage](https://grafana.com/docs/loki/latest/setup/install/helm/configure-storage/): The scalable installation requires a managed object store such as AWS S3 or Google Cloud Storage or a self-hosted store such as Minio. The single binary installation can only use the filesystem for storage.
* [Log Aggregation (Loki)](https://picluster.ricsanfre.com/docs/loki/)
* [可觀測性宇宙的第二十三天 - Grafana Loki 實戰](https://ithelp.ithome.com.tw/articles/10336360)

## Traces: Jaegar/Tempo
