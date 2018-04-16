## K8 Canary

This repository offers a simplistic [Go app](source/1.0/app.go) along with resources useful for deploying the app to [Kubernetes](https://kubernetes.io).


The Go application exposes 2 endpoints:

 * `/health`: Responds with HTTP 200, useful for talking to Kubernetes [Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/).
 * `/version`: Exposes the version number of the application, which is set as a [constant](source/1.0/app.go#L8).

## Location of Docker Image
- https://hub.docker.com/r/shreyasgune/canaryk8/tags/


## Docker build
```
#To build Version 1
docker build --build-arg version=1.0 -t canary:1.0 .

#To build Version 2
docker build --build-arg version=2.0 -t canary:2.0 .
```

## Enable Ingress and apply routing rules
 ```
 minikube addons enable ingress

 kubectl --namespace=ingress-test run echoserver --image=gcr.io/google_containers/echoserver:1.4 --port=8080
 kubectl --namespace=ingress-test expose deployment echoserver --type=NodePort
 minikube --namespace=ingress-test service echoserver

 kubectl --namespace=ingress-test apply -f app-production.yml
 minikube --namespace=ingress-test service kubeapp-production-service
 kubectl --namespace=ingress-test apply -f app-ingress-production.yml


 kubectl --namespace=ingress-test apply -f app-canary.yml
 minikube --namespace=ingress-test service kubeapp-production-service
 kubectl --namespace=ingress-test apply -f app-ingress-canary.yml
```

## Stuff you gotta do when you ssh into Minikube
`minikube ssh`

```
$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	minikube
127.0.0.1 myapp.sgune
127.0.0.1	canary.foo.bar
127.0.0.1 foo.bar
```

```
$ curl myapp.sgune/version
Congratulations! Version 1.0 of your application is running on Kubernetes.

$ curl foo.bar
Congratulations! Version 1.0 of your application is running on Kubernetes.

$ curl canary.foo.bar
Congratulations! Version 2.0 of your application is running on Kubernetes.
```
