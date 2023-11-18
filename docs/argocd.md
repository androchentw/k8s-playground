# ArgoCD

* GitOps: ArgoCD

Ref

* [ArgoCD - Overview](https://argo-cd.readthedocs.io/en/stable/)
* [Installing ArgoCD on Minikube and deploying a test application](https://medium.com/@mehmetodabashi/installing-argocd-on-minikube-and-deploying-a-test-application-caa68ec55fbf)
* [Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)

## Installation

Install by [Helm chart](https://artifacthub.io/packages/helm/argo/argo-cd)

```sh
helm repo add argo https://argoproj.github.io/argo-helm
helm install argo-cd argo/argo-cd
```

or install from GitHub: [ArgoCD - Overview](https://argo-cd.readthedocs.io/en/stable/)

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
