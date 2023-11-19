# ArgoCD

* GitOps: ArgoCD

Ref

* [ArgoCD - Overview](https://argo-cd.readthedocs.io/en/stable/)
* [Installing ArgoCD on Minikube and deploying a test application](https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf)
* [Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)
* [GitOps (ArgoCD)](https://picluster.ricsanfre.com/docs/argocd/)

## Endpoints Summary

```sh
# ArgoCD: http://localhost:8080
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Introduction

<img style="width:50%;" src="https://argo-cd.readthedocs.io/en/stable/assets/argocd_architecture.png">
<p align="center"><sub><sup>
  <a href="https://argo-cd.readthedocs.io/en/stable/operator-manual/architecture/" target="_blank" rel="noreferrer noopenner">ArgoCD - Architectural Overview</a>
</sup></sub></p>

* 可將服務的佈署檔案放在 git 上面，然後 Argo CD 會自動偵測 git 的改動，並重新佈署有更動的 k8s 元件。
* 因為佈署檔案放在 git 上面，可方便我們追蹤及記錄各環境的參數設定
* 可自動偵測 kubernetes 不同類型的佈署檔案，有 k8s 原生的 yaml / kustomize / helm /ksonnet/ jsonneet / 客製化的 config management plugin，並可將其佈署的變數截出顯示。
藉由指定 branch/tag/commit，來做 application 的更新
* 可顯示 sync 的 version (包含 git commit 的紀錄)，並且做 rollback
* 可搭配 argo notification 來做佈署的通知或是服務的 unhealth 告警

Ref:

* [Argo 生態系的介紹](https://sean22492249.medium.com/argo-生態系的介紹-9a0501eb5007)

## Installation

Official way: [ArgoCD - Overview](https://argo-cd.readthedocs.io/en/stable/), from GitHub: <https://github.com/argoproj/argo-cd/releases>

```sh
# Non-HA: (Here we choose this one)
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# HA:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml
```

or install by [Helm chart](https://artifacthub.io/packages/helm/argo/argo-cd), community maintained chart, non-HA version.

```sh
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd --create-namespace --namespace argocd
```

## Access ArgoCD UI

```sh
# Check Argo CD Services
kubectl get all -n argocd

# Expose the ArgoCD API Server
# ArgoCD: http://localhost:8080
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get the admin password
# username: admin
# password: THE_PASSWORD_YOU_GOT_ABOVE
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Change password and Delete the Initial Admin Password
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## Deploying a Sample App

* Check [src/nginx-helloworld/](../../src/nginx-helloworld/)
  * [Run a Stateless Application Using a Deployment](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)
* Settings > Repositories > Connect Repo > VIA HTTPS
  * Project: default
  * URL: <https://github.com/androchentw/k8s-playground>
* Save > Hamburger menu > Create application
  * Project: default
  * Name: k8s-playground
  * Sync Policy: None
  * path: src/nginx-helloworld     (resource files path in repo)
  * Cluster URL: <https://kubernetes.default.svc>
  * Namespace: helloworld

Equivalent to yaml:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: k8s-playground
spec:
  destination:
    name: ''
    namespace: ''
    server: 'https://kubernetes.default.svc'
  source:
    path: src/nginx-helloworld
    repoURL: 'https://github.com/androchentw/k8s-playground'
    targetRevision: HEAD
  sources: []
  project: default
```

Check status on ArgoCD UI, kubernetes-dashboard UI and `kubectl`

```sh
kubectl get all -n helloworld
# NAME                                    READY   STATUS    RESTARTS   AGE
# pod/nginx-deployment-7c79c4bf97-2kwwp   1/1     Running   0          9h
# pod/nginx-deployment-7c79c4bf97-dg8g2   1/1     Running   0          24m

# NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# service/nginx-service   NodePort   10.103.202.41   <none>        80:30080/TCP   9h

# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   2/2     2            2           9h

# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-7c79c4bf97   2         2         2       9h

kubectl describe deployment nginx-deployment -n helloworld
kubectl describe pod nginx-deployment-7c79c4bf97-2kwwp -n helloworld

# minikube ip
# 192.168.49.2
minikube service nginx-service -n helloworld
# |------------|---------------|-------------|---------------------------|
# | NAMESPACE  |     NAME      | TARGET PORT |            URL            |
# |------------|---------------|-------------|---------------------------|
# | helloworld | nginx-service | http/80     | http://192.168.49.2:30080 |
# |------------|---------------|-------------|---------------------------|
# 🏃  Starting tunnel for service nginx-service.
# |------------|---------------|-------------|------------------------|
# | NAMESPACE  |     NAME      | TARGET PORT |          URL           |
# |------------|---------------|-------------|------------------------|
# | helloworld | nginx-service |             | http://127.0.0.1:49204 |
# |------------|---------------|-------------|------------------------|

# nginx at: http://127.0.0.1:49204 
```

<img style="width:70%;" src="https://github.com/androchentw/k8s-playground/blob/main/docs/argocd/argocd-nginx-helloworld.png?raw=true">
<p align="center"><sub><sup>
  <a href="https://github.com/androchentw/k8s-playground/blob/main/src/nginx-hellowold" target="_blank" rel="noreferrer noopenner">ArgoCD - nginx-helloworld</a>
</sup></sub></p>

Ref:

* [使用 Argo CD 在 K8s 上實作持續佈署](https://docfunc.com/posts/100/使用-argo-cd-在-k8s-上實作持續佈署-post)

## User Management

* [User Management - Overview](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/)

Ref

* [Installing ArgoCD on Minikube and deploying a test application](https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf)
* [Tutorial: Using ArgoCD with Helm Charts](https://www.env0.com/blog/argocd-with-helm-charts)
* [Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)
* [使用 DroneCI 與 ArgoCD 實現 K8s 自動整合部署](https://minghsu.io/posts/droneci-argocd/)
