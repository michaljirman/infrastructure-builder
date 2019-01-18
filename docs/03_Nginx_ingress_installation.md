## Install nginx-ingress into the kubernetes cluster via Helm chart
```bash
KUBECONFIG=${YOUR_KUBECONFIG} helm install stable/nginx-ingress --name my-nginx --set rbac.create=true
```

```bash
kubectl --kubeconfig=${YOUR_KUBECONFIG} get svc --all-namespaces

NAMESPACE     NAME                                     TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                      AGE
default       kubernetes                               ClusterIP      172.20.0.1       <none>                                                                    443/TCP                      4d
default       my-nginx-nginx-ingress-controller        LoadBalancer   172.20.138.107   xxxxxxxxxx-1526747566.us-west-2.elb.amazonaws.com                         80:31248/TCP,443:32545/TCP   1d
```

### Add support for AWS SSL certificate. 
Edit configuration of the SVC controller by adding annotations and changing targetPort to http for both ports (http, https):-

```bash
kubectl --kubeconfig=${YOUR_KUBECONFIG} edit svc my-nginx-nginx-ingress-controller
```
Edit by adding:-
```yaml
service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:111111111111:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
```

and changing ports to:-
```yaml
ports:
  - name: http
    nodePort: 31248
    port: 80
    protocol: TCP
    targetPort: http
  - name: https
    nodePort: 32545
    port: 443
    protocol: TCP
    targetPort: http
```

Final configuration similar to the following:-
```yaml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
    service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:111111111111:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
  creationTimestamp: "2019-01-16T13:39:41Z"
  labels:
    app: nginx-ingress
    chart: nginx-ingress-1.1.4
    component: controller
    heritage: Tiller
    release: my-nginx
  name: my-nginx-nginx-ingress-controller
  namespace: default
  resourceVersion: "804527"
  selfLink: /api/v1/namespaces/default/services/my-nginx-nginx-ingress-controller
  uid: 2d4e24c1-1994-11e9-9928-029d73ceb734
spec:
  clusterIP: 172.20.138.107
  externalTrafficPolicy: Cluster
  ports:
  - name: http
    nodePort: 31248
    port: 80
    protocol: TCP
    targetPort: http
  - name: https
    nodePort: 32545
    port: 443
    protocol: TCP
    targetPort: http
  selector:
    app: nginx-ingress
    component: controller
    release: my-nginx
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - hostname: xxxxxxxxxx-1526747566.us-west-2.elb.amazonaws.com
```

Manually check the AWS LB configuration. Should be similar to the following:-
```bash
Load Balancer Protocol  Load Balancer Port  Instance Protocol   Instance Port  Cipher  SSL Certificate
HTTPS	                443	                HTTP	            32545	               Change	dcd98e7e-ad49-4a7f-8364-b56819d9a19f (ACM) Change
HTTP	                80	                HTTP	            31248	        N/A	   N/A
```