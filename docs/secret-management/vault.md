# Vault

## Setup

```sh
kubectl create namespace vault
kubectl get ns
kubectl config set-context --current --namespace=vault

cat > helm-vault-raft-values.yml <<EOF
server:
  affinity: ""
  ha:
    enabled: true
    raft:
      enabled: true
EOF
helm install vault hashicorp/vault --values helm-vault-raft-values.yml -n vault

# helm install vault hashicorp/vault --values helm-vault-values.yaml

kubectl get po -n vault
kubectl exec vault-0 -n vault -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json
cat cluster-keys.json
# operator init command generates a root key that it disassembles into key shares -key-shares=1
# -key-threshold=1 then sets the number of key shares required to unseal Vault
```

### Unseal

Do not run an unsealed Vault in production with a single key share and a single key threshold.

```sh
VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)

# for i in 0 1 2
#   do
#     kubectl exec vault-$i -- vault operator unseal  $VAULT_UNSEAL_KEY
#   done

# Unseal Vault running on the vault-0 pod
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY

# Join the vault-1 and vault-2 pods to the Raft cluster
kubectl exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200

# Use the unseal key from above to unseal vault-1 and vault-2
kubectl exec -ti vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec -ti vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY

# After this unsealing process all vault pods are now in running (1/1 ready ) state
kubectl get po -n vault

# Vault service is of ClusterIP type which means we can access Vault console from browser so to access this we need to use port-forward command
kubectl port-forward service/vault -n vault 8200:8200
# type http://localhost:8200 in browser and enter root token
```

## Create a Secret Engine in Vault

To deploy sample web application it expects Vault to store a username and password at the path secret/webapp/config . We have two options to create secrets in Vault ,

1. create using vault command by logging to vault pod
2. create from Vault UI console

### Vault UI Console

* Secrets > Enable new engine > KV

```sh
# Display the root token found in cluster-keys.json
jq -r ".root_token" cluster-keys.json

# Start an interactive shell session on the vault-0 pod
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh
vault login

# Enable an instance of the kv-v2 secrets engine at the path secret
vault secrets enable -path=secret kv-v2

# Create a secret at path secret/webapp/config with a username and password.
vault kv put secret/webapp/config username="static-user" password="static-password"

# Verify that the secret is defined at the path secret/webapp/config
vault kv get secret/webapp/config
```

### Configure Kubernetes Authentication

* Enable Authentication method: Access > Auth Methods > Enable new method

```sh
vault auth enable kubernetes

# Configure the Kubernetes authentication method to use the location of the Kubernetes API.
vault write auth/kubernetes/config \
 kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
```

### Create a Policy

* Policies > Create ACL Policy

```sh
# Write out the policy named webapp that enables the read capability for secrets at path secret/data/webapp/config
vault policy write webapp - <<EOF
path "secret/data/webapp/config" {
  capabilities = ["read"]
}
EOF
```

### Create a Role

```sh
kubectl create namespace webapps

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp-service-account
  namespace: webapps
EOF

# Create a Kubernetes authentication role, named webapp, that connects the Kubernetes service account name and webapp policy.
vault write auth/kubernetes/role/webapp \
        bound_service_account_names=webapp-service-account \
        bound_service_account_namespaces=webapps \
        policies=webapp \
        ttl=24h
```

### Web Application Deployment

#### Deploy Web Application

```sh
kubectl apply -f - <<EOF
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: webapps
  labels:
    app: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      serviceAccountName: webapp-service-account
      containers:
        - name: app
          image: burtlo/exampleapp-ruby:k8s
          imagePullPolicy: Always
          env:
            - name: VAULT_ADDR
              value: 'http://vault:8200'
            - name: JWT_PATH
              value: '/var/run/secrets/kubernetes.io/serviceaccount/token'
            - name: SERVICE_PORT
              value: '8080'
EOF
```

* `JWT_PATH` sets the path of the JSON web token (JWT) issued by Kubernetes. This token is used by the web application to authenticate with Vault.
* `VAULT_ADDR` sets the address of the Vault service (accept traffic on port 8200). The Helm chart defined a Kubernetes service named vault that forwards requests to its endpoints (i.e. The pods named vault-0, vault-1, and vault-2).
* `SERVICE_PORT` sets the port that the service listens for incoming HTTP requests.

#### Access Web Application Endpoint to Retrieve Secret

```sh
# http://localhost:8080
kubectl port-forward \
 $(kubectl get pod -n webapps -l app=webapp -o jsonpath="{.items[0].metadata.name}") \
 8080:8080 -n webapps
```

The sample web application running on port 8080 in the webapp pod is able to

* authenticates with the Kubernetes service account token
* receives a Vault token with the read capability at the secret/data/webapp/config path
* retrieves the secrets from secret/data/webapp/config path
* displays the secrets as JSON

## Enabling secrets engine

```sh
VAULT_ROOT_PASSWORD=$(cat cluster-keys.json | jq -r ".root_token")

kubectl exec vault-0 -- vault login $VAULT_ROOT_PASSWORD

kubectl exec vault-0 -- vault secrets enable -path=internal kv-v2
```

## Enabling Kubernetes Auth module

```sh
kubectl exec vault-0 -- vault auth enable kubernetes

kubectl exec -it vault-0 -- /bin/sh
vault write auth/kubernetes/config \
 token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
      kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
      kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

vault policy write app - <<EOF
path "internal/data/database/config" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/app \
       bound_service_account_names=app \
       bound_service_account_namespaces=default \
       policies=app \
       ttl=24h
```

## Deploying an application

```sh
kubectl exec vault-0 -- vault kv put internal/database/config username="db-readonly-username" password="db-secret-password"

kubectl create serviceaccount app

kubectl create -f orgchart.yaml
kubectl get pods -l app=orgchart

kubectl exec orgchart-6dbb599c46-rmn9t -c orgchart -- cat /vault/secrets/database-config.txt

kubectl patch deploy orgchart --patch-file orgchat-patch.yaml
# deployment.apps/orgchart patched

kubectl exec orgchart-54d575974b-5ncfl -c orgchart -- cat /vault/secrets/database-config.txt
postgresql://db-readonly-username:db-secret-password@postgres:5432/wizard
```

## Ref

* [Vault on Kubernetes: Helm Chart](https://developer.hashicorp.com/vault/docs/platform/k8s/helm)
* [Run Vault on kubernetes](https://developer.hashicorp.com/vault/docs/platform/k8s/helm/run)
* <https://raw.githubusercontent.com/hashicorp/vault-helm/master/values.yaml>
* [Deploying High Available Vault on Kubernetes using Helm](https://floatingpoint.sorint.it/blog/post/deploying-high-available-vault-on-kubernetes-using-helm)
* [Vault Installation to Minikube via Helm with Integrated Storage](https://mycloudjourney.medium.com/vault-installation-to-minikube-via-helm-with-integrated-storage-15c9d1a907e6)
