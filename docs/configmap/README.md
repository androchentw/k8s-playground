# ConfigMap

* Purpose: Configuration, environment management
* [Definition](https://kubernetes.io/docs/concepts/configuration/configmap/): A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.
* Use a ConfigMap for setting configuration data separately from application code.

<img style="width:50%;" src="https://images.contentstack.io/v3/assets/blt300387d93dabf50e/blt7118bc80b8cd018a/62f50128d3b8a57004568c03/ConfigMap_Diagram.jpg">
<p align="center"><sub><sup>
  <a href="https://www.weave.works/blog/kubernetes-configmap" target="_blank" rel="noreferrer noopenner">ConfigMap</a>
</sup></sub></p>

## k8s official

### Concepts

* [Concepts - ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

* Note: A ConfigMap is not designed to hold large chunks of data. The data stored in a ConfigMap cannot exceed 1 MiB. If you need to store settings that are larger than this limit, you may want to consider mounting a volume or use a separate database or file service.

* [Tasks - Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
* [Tutorials - Configuring Redis using a ConfigMap](https://kubernetes.io/docs/tutorials/configuration/configure-redis-using-configmap/)

## Sample

```sh

env | grep "ENV"
```

## Referenace Sample

* [A Guide to ConfigMap in Kubernetes](https://www.weave.works/blog/kubernetes-configmap)
* [Kubernetes manifests - ConfigMap example](https://www.kisphp.com/kubernetes-manifests/configmap)
* [Kubernetes ConfigMaps and Configuration Best Practices](https://earthly.dev/blog/kubernetes-config-maps/)
