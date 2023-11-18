#!/bin/bash
# command used of docs/minikube/minikube.md

function setup() {
  brew install --cask docker
  docker -v
  brew install kubectl

  kubectl version --client
  source <(kubectl completion zsh)
  echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >>~/.zshrc

  brew install minikube
}

function exec_minikube() {
  minikube start
  kubectl get po -A
  kubectl get nodes
  kubectl cluster-info

  minikube dashboard
  cat ~/.kube/config
  minikube addons list
}

function delete_minikube() {
  minikube stop
  minikube delete
}

function create_service() {
  # kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0 --dry-run=client --output=yaml
  kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
  kubectl get pods
  kubectl expose deployment hello-minikube --type=NodePort --port=8080
  kubectl get services hello-minikube
  minikube service hello-minikube
  curl -v http://127.0.0.1:51666/

  kubectl port-forward service/hello-minikube 7080:8080 
  curl -v http://localhost:7080/

  kubectl delete service hello-minikube
  kubectl delete deployment hello-minikube
}

function create_load_balancer() {
  kubectl create deployment balanced --image=kicbase/echo-server:1.0
  kubectl expose deployment balanced --type=LoadBalancer --port=8080
  minikube tunnel
  kubectl get services balanced
  curl -v http://127.0.0.1:8080

  kubectl delete service balanced
  kubectl delete deployment balanced
}

function enable_ingress_addon() {
  minikube addons enable ingress
  kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
  kubectl get ingress
  minikube tunnel 
  curl -v 127.0.0.1/foo
  curl -v 127.0.0.1/bar

  kubectl delete -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
}

function main() {
  setup
  exec_minikube
  create_service
  create_load_balancer
  enable_ingress_addon
  remove_minikube
}

main
