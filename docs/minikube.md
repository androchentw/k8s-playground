# Minikube

Minikube on MacOS M2

## Setup minikube

[minikube start](https://minikube.sigs.k8s.io/docs/start/)

```sh
brew install --cask docker
# open Docker Desktop > Settings > Advanced > Select "System"
docker -v 

# Setup minikube and kubectl
brew install minikube kubectl
kubectl version --client

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

Use the following to generate a yaml template:

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

We used:

* `kubectl expose --type=NodePort`
* `minikube service`
* `kubectl port-forward`

in the previous section. Now let's try

* `kubectl expose --type=LoadBalancer`
* `minikube tunnel`

```sh
kubectl create deployment balanced --image=kicbase/echo-server:1.0
kubectl expose deployment balanced --type=LoadBalancer --port=8080
minikube tunnel
# To find the routable IP, run this command and examine the EXTERNAL-IP column:
kubectl get services balanced
# Your deployment is now available at http://127.0.0.1:8080
```

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

### Enable ingress addon

```sh
minikube addons enable ingress
kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
kubectl get ingress
# open a new terminal window and run 
minikube tunnel 
curl 127.0.0.1/foo
curl 127.0.0.1/bar
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
