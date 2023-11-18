# ArgoCD

* GitOps: ArgoCD

Ref

* [ArgoCD - Overview](https://argo-cd.readthedocs.io/en/stable/)
* [Installing ArgoCD on Minikube and deploying a test application](https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf)
* [Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)
* [GitOps (ArgoCD)](https://picluster.ricsanfre.com/docs/argocd/)

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
kubectl port-forward svc/argocd-server -n argocd 8080:443
# localhost:8080

# Get the admin password
# username: admin
# password: THE_PASSWORD_YOU_GOT_ABOVE
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Change password and Delete the Initial Admin Password
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## Deploying a Sample App

* Check [src/nginx-helloworld/](../src/nginx-helloworld/)
* Settings > Repositories > Connect Repo > VIA HTTPS
  * Project: default
  * URL: <https://github.com/androchentw/k8s-playground>
* Save > Hamburger menu > Create application
  * Project: default
  * Name: k8s-playground
  * Sync Policy: Automatic
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
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
```

## User Management

* [User Management - Overview](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/)

Ref

* [Installing ArgoCD on Minikube and deploying a test application](https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf)
* [Tutorial: Using ArgoCD with Helm Charts](https://www.env0.com/blog/argocd-with-helm-charts)
* [Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)
