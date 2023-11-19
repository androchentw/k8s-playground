# FastAPI Helloworld Sample

A part of [k8s-playground](https://github.com/androchentw/k8s-playground) demo case.

```text
fastapi-helloworld
├── app
│   ├── __init__.py
│   └── main.py
├── Dockerfile
└── requirements.txt
```

## Introduction

```sh
pip install -r requirements.txt

# Run1: simply run the server
uvicorn main:app --reload
# Endpoint: http://127.0.0.1:8000/items/5?q=somequery
# API Doc: http://127.0.0.1:8000/docs

# Run2: docker way
docker build -t fastapi-helloworld:latest .
docker run -d --name fastapi-helloworld -p 80:80 fastapi-helloworld:latest
# Endpoint: http://localhost:80/items/5?q=somequery
# API Doc: http://localhost:80/docs
```

Ref

* [Tutorial - User Guide](https://fastapi.tiangolo.com/tutorial/first-steps/)
* [FastAPI in Containers - Docker](https://fastapi.tiangolo.com/id/deployment/docker/)
* Github
  * [tiangolo/fastapi](https://github.com/tiangolo/fastapi)
  * [tiangolo/uvicorn-gunicorn-fastapi-docker](https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker)

## Push to Docker Hub

```sh
docker build -t androchentw/fastapi-helloworld:1.0.0 \
  -t androchentw/fastapi-helloworld:1.0.0-dev .
docker push androchentw/fastapi-helloworld --all-tags
```

## Other Ref

* [Deploying a FastAPI Application on Kubernetes: A Step-by-Step Guide for Production](https://sumanta9090.medium.com/deploying-a-fastapi-application-on-kubernetes-a-step-by-step-guide-for-production-d74faac4ca36)
* <https://github.com/4OH4/kubernetes-fastapi>
