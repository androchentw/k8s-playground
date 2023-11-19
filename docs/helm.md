# Helm

* Helm is the package manager for Kubernetes

## Install

* [Helm Quickstart Guide](https://helm.sh/docs/intro/quickstart/)
* [Helm Cheat Sheet](https://helm.sh/docs/intro/cheatsheet/)

```sh
brew install helm
```

## Introduction

`helm create helm-demo`

```text
foo/
├── .helmignore   # Contains patterns to ignore when packaging Helm charts.
├── Chart.yaml    # Information about your chart
├── values.yaml   # The default values for your templates
├── charts/       # Charts that this chart depends on
└── templates/    # The template files
    └── tests/    # The test files
```

## Sample

* [Helm Chart Template Guide - Getting Started](https://helm.sh/docs/chart_template_guide/getting_started/)

```sh
helm create mychart
# Creating mychart

rm -rf mychart/templates/*
```

Ref

* [Kubernetes 基礎教學（三）Helm 介紹與建立 Chart](https://chengweihu.com/kubernetes-tutorial-3-helm/)
* [DAY20 — 利用 Helm 把 K8s 元件都包裝起來吧！](https://github.com/superj80820/2020-ithelp-contest/tree/master/DAY20)
* [Helm v3 使用簡介](https://godleon.github.io/blog/DevOps/Helm-v3-Chart-Template-Guide/)
* [Helm - Templating variables in values.yaml](https://stackoverflow.com/questions/55958507/helm-templating-variables-in-values-yaml)

## [Combine Helm and Kustomize Deployments](https://humalect.com/blog/kustomize-vs-helm#when-to-use-helm-vs-kustomize)

* kustomize
  * Customizing Manifests
  * Multi-Environment Management
* helm
  * Packaging Complex Applications
  * Managing Releases
  * Centralized Configuration
