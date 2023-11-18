# Minikube

Minikube on MacOS M2 + zsh.
Ref [k8s-basics.md](../k8s-basics.md) for details.

## Setup minikube

The concise version of command is aggregated at [demo-minikube-start.sh](demo-minikube-start.sh)

* [minikube start](https://minikube.sigs.k8s.io/docs/start/)
* [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [Startup Local Kubernetes via Minikube](https://fufu.gitbook.io/kk8s/startup-kubernetes-via-minikube)
* [Macbook 開發環境設定大全](https://blog.androchen.tw/macbook-setup/)

```sh
brew install --cask docker
# open Docker Desktop > Settings > Advanced > Select "System"
docker -v 

brew install kubectl
kubectl version --client
source <(kubectl completion zsh)  # set up autocomplete in zsh into the current shell
echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc # add autocomplete permanently to your zsh shell


brew install minikube 

minikube start
# 😄  minikube v1.32.0 on Darwin 14.0 (arm64)
# ✨  Automatically selected the docker driver
# 📌  Using Docker Desktop driver with root privileges
# 👍  Starting control plane node minikube in cluster minikube
# 🚜  Pulling base image ...
# 💾  Downloading Kubernetes v1.28.3 preload ...
#🔥  Creating docker container (CPUs=2, Memory=4000MB) ...
# 🐳  Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
#     ▪ Generating certificates and keys ...
#     ▪ Booting up control plane ...
#     ▪ Configuring RBAC rules ...
# 🔗  Configuring bridge CNI (Container Networking Interface) ...
# 🔎  Verifying Kubernetes components...
#     ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
# 🌟  Enabled addons: storage-provisioner, default-storageclass
# 🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

kubectl get po -A
kubectl get nodes
kubectl cluster-info
# Kubernetes control plane is running at https://127.0.0.1:51225
# CoreDNS is running at https://127.0.0.1:51225/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

minikube dashboard
# 🎉  Opening http://127.0.0.1:51298/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...

cat ~/.kube/config
minikube addons list
```

You can also check Docker Desktop for more information, like ports opened:

```text
51226:22⁠
51227:2376⁠
51228:32443⁠
51229:5000⁠
51225:8443⁠
```

## Deploy applications: hello-minikube

[minikube start - Deploy applications](https://minikube.sigs.k8s.io/docs/start/)

### Create a Service (Deployment)

```sh
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
# deployment.apps/hello-minikube created

kubectl get pods
# NAME                              READY   STATUS    RESTARTS   AGE
# hello-minikube-7f54cff968-97lz8   1/1     Running   0          66s

kubectl expose deployment hello-minikube --type=NodePort --port=8080
# service/hello-minikube exposed

kubectl get services hello-minikube
# NAME             TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
# hello-minikube   NodePort   10.102.105.220   <none>        8080:30225/TCP   9s

minikube service hello-minikube
# |-----------|----------------|-------------|---------------------------|
# | NAMESPACE |      NAME      | TARGET PORT |            URL            |
# |-----------|----------------|-------------|---------------------------|
# | default   | hello-minikube |        8080 | http://192.168.49.2:30225 |
# |-----------|----------------|-------------|---------------------------|
# 🏃  Starting tunnel for service hello-minikube.
# |-----------|----------------|-------------|------------------------|
# | NAMESPACE |      NAME      | TARGET PORT |          URL           |
# |-----------|----------------|-------------|------------------------|
# | default   | hello-minikube |             | http://127.0.0.1:51666 |
# |-----------|----------------|-------------|------------------------|
# 🎉  Opening service default/hello-minikube in default browser...
# ❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
# Your application is now available on http://127.0.0.1:51666/

kubectl port-forward service/hello-minikube 7080:8080
# Forwarding from 127.0.0.1:7080 -> 8080
# Forwarding from [::1]:7080 -> 8080
# Tada! Your application is now available at http://localhost:7080/
```

You can also check `minikube dashboard` GUI for a better overview on the minikube cluster and hello-minikube deployments.

Use the following to generate a [hello-minikube-deployment.yaml](hello-minikube-deployment.yaml) template:

`kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0 --dry-run=client --output=yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: hello-minikube
  name: hello-minikube
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-minikube
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-minikube
    spec:
      containers:
      - image: kicbase/echo-server:1.0
        name: echo-server
        resources: {}
status: {}
```

### Create a LoadBalancer

We used the following in the previous section:

* `kubectl expose --type=NodePort`
* `minikube service`
* `kubectl port-forward`

Now let's try:

* `kubectl expose --type=LoadBalancer`
* `minikube tunnel`

ref: [minikube > Handbook / Accessing apps](https://minikube.sigs.k8s.io/docs/handbook/accessing/)

```sh
kubectl create deployment balanced --image=kicbase/echo-server:1.0
kubectl expose deployment balanced --type=LoadBalancer --port=8080
minikube tunnel
# To find the routable IP, run this command and examine the EXTERNAL-IP column:
kubectl get services balanced
# Your deployment is now available at http://127.0.0.1:8080
```

Use the following to generate a [balanced-deployment.yaml](balanced-deployment.yaml) template:

`kubectl create deployment balanced --image=kicbase/echo-server:1.0 --dry-run=client --output=yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: balanced
  name: balanced
spec:
  replicas: 1
  selector:
    matchLabels:
      app: balanced
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: balanced
    spec:
      containers:
      - image: kicbase/echo-server:1.0
        name: echo-server
        resources: {}
status: {}
```

### Enable Ingress Addon

```sh
minikube addons enable ingress
# 💡  ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
# You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
# 💡  After the addon is enabled, please run "minikube tunnel" and your ingress resources would be available at "127.0.0.1"
# 🔎  Verifying ingress addon...
# 🌟  The 'ingress' addon is enabled

kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
# pod/foo-app created
# service/foo-service created
# pod/bar-app created
# service/bar-service created
# ingress.networking.k8s.io/example-ingress created

kubectl get ingress
# NAME              CLASS   HOSTS   ADDRESS        PORTS   AGE
# example-ingress   nginx   *       192.168.49.2   80      2m24s

# open a new terminal window and run 
minikube tunnel 
# ✅  Tunnel successfully started
# 📌  NOTE: Please do not close this terminal as this process must stay alive for the tunnel to be accessible ...
# 🏃  Starting tunnel for service balanced.
# ❗  The service/ingress example-ingress requires privileged ports to be exposed: [80 443]
# 🔑  sudo permission will be asked for it.
# 🏃  Starting tunnel for service example-ingress.

curl 127.0.0.1/foo
# Request served by foo-app
# HTTP/1.1 GET /foo
# Host: 127.0.0.1
# Accept: */*
# User-Agent: curl/8.1.2
# X-Forwarded-For: 10.244.0.1
# X-Forwarded-Host: 127.0.0.1
# X-Forwarded-Port: 80
# X-Forwarded-Proto: http
# X-Forwarded-Scheme: http
# X-Real-Ip: 10.244.0.1
# X-Request-Id: c59d9ad90253f624abe25c5ec515343c
# X-Scheme: http

curl 127.0.0.1/bar
# Request served by bar-app
# HTTP/1.1 GET /bar
# Host: 127.0.0.1
# Accept: */*
# User-Agent: curl/8.1.2
# X-Forwarded-For: 10.244.0.1
# X-Forwarded-Host: 127.0.0.1
# X-Forwarded-Port: 80
# X-Forwarded-Proto: http
# X-Forwarded-Scheme: http
# X-Real-Ip: 10.244.0.1
# X-Request-Id: 11b71a0d69ea7e334cc973650125601e
# X-Scheme: http
```

* Note for Docker Desktop Users: To get ingress to work you'll need to open a new terminal window and run minikube tunnel and in the following step use 127.0.0.1 in place of <ip_from_above>.

### Wrap up

* [minikube command reference](https://minikube.sigs.k8s.io/docs/commands/)

```sh
minikube service list   # list all services. -n <namespace>
minikube service --all  # Forwards all services in a namespace (defaults to "false")
```

You could cleanup with the following command:

```sh
kubectl get services
kubectl get deploy

# for kubectl create deployment, revert it by
kubectl delete service hello-minikube
kubectl delete deployment hello-minikube
kubectl delete service balanced
kubectl delete deployment balanced

# for kubectl apply -f <filename>, revert it by:
kubectl delete -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml

minikube pause
minikube stop

minikube delete  # Optional, deletes the whole cluster
```

### kubectl resource control cheatsheet

```sh
# check
kubectl get <resource>
kubectl describe <resource> <resource-name>
# create
kucectl create <resource> ...
kubectl create -f <config-yaml>
kubectl apply -f ./
# modify
kubectl edit <resource> <resource-name>
kubectl delete <resource> <resource-name>
# all
kubectl get all
kubectl delete all --all
```

## Another Tutorial - Hello Minikube

[Tutorial - Hello Minikube](https://kubernetes.io/docs/tutorials/hello-minikube/)

* This tutorial shows you how to run a sample app on Kubernetes using minikube. The tutorial provides a container image that uses NGINX to echo back all the requests.

```sh
# Run a test container image that includes a webserver
kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080
kubectl get deployments
kubectl get pods
kubectl get events
kubectl config view
kubectl logs hello-node-5f76cf6ccf-br9b5

# Create a Service
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl get services
minikube service hello-node
minikube addons list
minikube addons enable metrics-server
kubectl get pod,svc -n kube-system

# Cleanup
kubectl delete service hello-node
kubectl delete deployment hello-node
minikube stop
```
