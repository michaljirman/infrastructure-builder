# Jenkins installation via Helm
```bash
# create jenkins namespace
kubectl --kubeconfig=kubeconfig create namespace jenkins
# https://github.com/helm/charts/issues/1092 - allow only permissions to serviceaccounts inside of the namespace which you specified
kubectl --kubeconfig=kubeconfig create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts:jenkins
# update helm repo
KUBECONFIG=kubeconfig helm repo update
# inspect chart
KUBECONFIG=kubeconfig helm inspect stable/jenkins
# dry run of the installation
KUBECONFIG=kubeconfig helm install stable/jenkins --name my-jenkins --namespace jenkins --dry-run --debug
# installation of the jenkins chart into the jenkins namespace
KUBECONFIG=kubeconfig helm install stable/jenkins --name my-jenkins --namespace jenkins
# upgrade or installation of the jenkins chart into the jenkins namespace 
KUBECONFIG=kubeconfig helm upgrade --install my-jenkins stable/jenkins --namespace jenkins

# if the default values needs to be replaces create a jenkins.yaml file with the new values 
#KUBECONFIG=kubeconfig helm install stable/jenkins --name my-jenkins -f jenkins.yaml --namespace jenkins --dry-run --debug

# to install from local chart folder
#KUBECONFIG=kubeconfig helm install --name=my-jenkins ./jenkins --namespace jenkins
```

Deletion of the namespace
```bash
KUBECONFIG=kubeconfig helm del --purge my-jenkins
```

```txt
NAME:   my-jenkins
LAST DEPLOYED: Tue Jan  8 17:51:28 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME        TYPE    DATA  AGE
my-jenkins  Opaque  2     1s

==> v1/ConfigMap
NAME              DATA  AGE
my-jenkins        5     1s
my-jenkins-tests  1     1s

==> v1/PersistentVolumeClaim
NAME        STATUS   VOLUME           CAPACITY  ACCESS MODES  STORAGECLASS  AGE
my-jenkins  Pending  general-purpose  1s

==> v1/Service
NAME              TYPE          CLUSTER-IP     EXTERNAL-IP  PORT(S)         AGE
my-jenkins-agent  ClusterIP     172.20.185.32  <none>       50000/TCP       1s
my-jenkins        LoadBalancer  172.20.238.73  <pending>    8080:32202/TCP  1s

==> v1/Deployment
NAME        DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
my-jenkins  1        1        1           0          1s

==> v1/Pod(related)
NAME                         READY  STATUS   RESTARTS  AGE
my-jenkins-5f9b97cff6-p5fpd  0/1    Pending  0         1s


NOTES:
1. Get your 'admin' user password by running:
  printf $(kubectl get secret --namespace default my-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        You can watch the status of by running 'kubectl get svc --namespace default -w my-jenkins'
  export SERVICE_IP=$(kubectl get svc --namespace default my-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo http://$SERVICE_IP:8080/login

3. Login with the password from step 1 and the username: admin

For more information on running Jenkins on Kubernetes, visit:
https://cloud.google.com/solutions/jenkins-on-container-engine
```


# Jenkins installation from a chart generated locally
```bash
mkdir jenkins-helm
cd jenkins-helm
helm fetch --repo https://kubernetes-charts.storage.googleapis.com --untar --untardir ./charts jenkins
mkdir manifests
mkdir values
helm template --values ./values/jenkins.yaml --output-dir ./manifests ./charts/jenkins --namespace jenkins --name my-jenkins
# Install the chart via kubectl
kubectl --kubeconfig=${YOUR_KUBECONFIG} apply --recursive --filename ./jenkins-helm/manifests/jenkins --namespace jenkins

# Remove the chart
kubectl --kubeconfig=${YOUR_KUBECONFIG} delete --recursive --filename ./jenkins-helm/manifests/jenkins --namespace jenkins
```

###1b] Install Jenkins via helm command
references: https://technologyconversations.com/2018/06/01/deploying-jenkins-to-a-kubernetes-cluster-using-helm/
```bash
# Install the chart
KUBECONFIG=${YOUR_KUBECONFIG} helm install stable/jenkins --name my-jenkins --namespace jenkins --values jenkins-values.yaml

# Remove the chart
KUBECONFIG=${YOUR_KUBECONFIG} helm delete --purge my-jenkins
```


### Enforce SSL on the Jenkins Ingress
```bash
kubectl --kubeconfig=${YOUR_KUBECONFIG} get ing --all-namespaces
kubectl --kubeconfig=${YOUR_KUBECONFIG} edit ing my-jenkins -n jenkins
```


Change ssl-redirect values to "true" and add tls section so it looks as the following:-
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/proxy-body-size: 50m
    ingress.kubernetes.io/proxy-request-buffering: "off"
    ingress.kubernetes.io/ssl-redirect: "true"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"annotations":{"ingress.kubernetes.io/proxy-body-size":"50m","ingress.kubernetes.io/proxy-request-buffering":"off","ingress.kubernetes.io/ssl-redirect":"false","nginx.ingress.kubernetes.io/proxy-body-size":"50m","nginx.ingress.kubernetes.io/proxy-request-buffering":"off","nginx.ingress.kubernetes.io/ssl-redirect":"false"},"name":"my-jenkins","namespace":"jenkins"},"spec":{"rules":[{"host":"jenkins.yourcompany.com","http":{"paths":[{"backend":{"serviceName":"my-jenkins","servicePort":8080}}]}}]}}
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
    nginx.ingress.kubernetes.io/proxy-request-buffering: "off"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  creationTimestamp: "2019-01-16T14:21:38Z"
  generation: 2
  name: my-jenkins
  namespace: jenkins
  resourceVersion: "809344"
  selfLink: /apis/extensions/v1beta1/namespaces/jenkins/ingresses/my-jenkins
  uid: 0957b78f-199a-11e9-9928-029d73ceb734
spec:
  rules:
  - host: jenkins.yourcompany.com
    http:
      paths:
      - backend:
          serviceName: my-jenkins
          servicePort: 8080
  tls:
  - hosts:
    - jenkins.yourcompany.com
    secretName: jenkins-tls
status:
  loadBalancer:
    ingress:
    - {}
```


