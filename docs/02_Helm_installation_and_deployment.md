## Helm Server (Tiller) installation in kubernetes cluster 

```bash
$ kubectl --kubeconfig=kubeconfig create -f rbac-config.yaml
serviceaccount "tiller" created
clusterrolebinding "tiller" created

$ KUBECONFIG=kubeconfig helm init --service-account tiller
OR 
$ KUBECONFIG=kubeconfig helm init --upgrade --service-account tiller
```

In case of the following error `Error: could not find tiller`:
```bash
$ kubectl --kubeconfig=kubeconfig -n kube-system delete deployment tiller-deploy
$ kubectl --kubeconfig=kubeconfig -n kube-system delete service/tiller-deploy
$ KUBECONFIG=kubeconfg helm init --upgrade --service-account tiller
```
Then try to deploy demo app:
```bash
$ KUBECONFIG=kubeconfig helm install --name=my-slate errm/kubeslate
```

### Helm - Deployment example
```bash
$ KUBECONFIG=kubeconfig helm install --name=my-slate errm/kubeslate
NAME:   my-slate
LAST DEPLOYED: Tue Jan  8 15:40:06 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ServiceAccount
NAME                SECRETS  AGE
my-slate-kubeslate  1        1s

==> v1/ClusterRole
NAME                AGE
my-slate-kubeslate  1s

==> v1/ClusterRoleBinding
NAME                AGE
my-slate-kubeslate  1s

==> v1/Service
NAME                TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)  AGE
my-slate-kubeslate  ClusterIP  172.20.105.107  <none>       80/TCP   1s

==> v1beta2/Deployment
NAME                DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
my-slate-kubeslate  2        2        2           0          1s

==> v1/Pod(related)
NAME                               READY  STATUS             RESTARTS  AGE
my-slate-kubeslate-c9996587-4xfk5  0/1    ContainerCreating  0         1s
my-slate-kubeslate-c9996587-fmj7x  0/1    ContainerCreating  0         1s


NOTES:
To access Kubeslate

1. First start the kubectl proxy:

   kubectl proxy

2. Now open the following URL in your browser:

   http://localhost:8001/api/v1/namespaces/default/services/my-slate-kubeslate:http/proxy

Please try reloading the page if you see "ServiceUnavailable / no endpoints available for service", as pod creation might take a few moments.

$ kubectl --kubeconfig=kubeconfig proxy
Starting to serve on 127.0.0.1:8001
```

Open http://localhost:8001/api/v1/namespaces/default/services/my-slate-kubeslate:http/proxy in browser.
