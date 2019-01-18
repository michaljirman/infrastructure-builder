# Generate helm charts locally
https://blog.giantswarm.io/what-you-yaml-is-what-you-get/

### stable/jenkins - Generation, Apply, Delete
```bash
mkdir helm-jenkins
cd helm-jenkins

helm fetch --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts jenkins

mkdir manifests
mkdir values

cp ./charts/jenkins/values.yaml ./values/jenkins.yaml

helm template --values ./values/jenkins.yaml --output-dir ./manifests ./charts/jenkins --namespace jenkins --name my-jenkins

kubectl --kubeconfig=${YOUR_KUBECONFIG} apply --recursive --filename ./manifests/jenkins/ --namespace jenkins
kubectl --kubeconfig=${YOUR_KUBECONFIG} delete --recursive --filename ./manifests/jenkins/ --namespace jenkins

# to update svc in k8s
kubectl --kubeconfig=${YOUR_KUBECONFIG} apply -f ./manifests/jenkins/templates/jenkins-master-svc.yaml --namespace jenkins
``` 



### Prometheus
```bash
11394  helm fetch --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts --version 5.5.3 prometheus
11395  ls
11396  cp ./charts/prometheus/values.yaml ./values/prometheus.yaml
11397  cp ./charts/prometheus/values.yaml ./values/prometheus.yaml
11398  mkdir values
11399  cp ./charts/prometheus/values.yaml ./values/prometheus.yaml
11400  helm template --values ./values/prometheus.yaml --output-dir ./manifests   ./charts/prometheus
11401  mkdir manifests
11402  helm template --values ./values/prometheus.yaml --output-dir ./manifests   ./charts/prometheus
11403  cd ..
11404  cd jenkins-helm
11405  helm fetch --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts --version 5.5.3 jenkins
11406  helm fetch --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts jenkins
11407  ls  --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts --version 5.5.3 jenkins
```