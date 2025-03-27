# tanka-lib-k8-onehq
## Project to deploy kubernetes resources with Jsonnet Tanka.
Through the following links you can access the official documentation of the Jsonnet libraries and also a tutorial to learn Tanka.  
* [Jsonnet Standard Library.](https://jsonnet.org/ref/stdlib.html)
* [Grafana Tanka Tutorial.](https://tanka.dev/tutorial/overview/)  
  
## How to import the library tanka-lib-k8-onehq  
The first step is to create a new project where we will import the necessary libraries. To do this, follow these steps:  
  
 1. **Create a directory for your project.**
```bash
mkdir onehq-example-project && cd onehq-example-project
```  
2. **Initialize new Tanka project.**  
```bash
tk init --k8s=1.28  
```  
> [!NOTE]  
> --k8s=1.28 (kubernetes version handle by the cluster)  
  
  3. **Add a new environment to a Tanka project.**  
```bash  
tk env add environments/onehq-example-staging  
```  
4. **Defines the URL of the Kubernetes cluster server associated with the environment.**  
  
```bash  
tk env set environments/onehq-example-staging/ --server=https://api.crc.testing:6443  
``` 
5. **Sets the default namespace for resources created in this environment.**  
```bash  
tk env set environments/onehq-example-staging/ --namespace=onehq-example-staging  
```  
6. **Import k8s-libsonnet library.**  
```bash  
jb install github.com/jsonnet-libs/k8s-libsonnet/1.28@main github.com/grafana/jsonnet-libs/ksonnet-util  
```  
7. **Import tanka-lib-k8-onehq library.**  
```bash  
jb install github.com/OneHQ/tanka-lib-k8-onehq@main  
```  
8. **Create the file `k8-onehq.libsonnet` in the _lib/_ with the following content**  
```bash  
import 'github.com/OneHQ/tanka-lib-k8-onehq/main.libsonnet'  
```  
  

With these steps, we have successfully installed the necessary libraries for our project. Now, we just need to define the resources we want to deploy in `main.jsonnet` along with our `values` file. For this tutorial, I will define a **Deployment**, a **StatefulSet**, and a **CronJob**.  
  

The following `main.jsonnet` file is an example of how we can define resources.  

```bash  
# K8s resources libsonnet.
local k = import 'k.libsonnet';
local k8 = import 'k8-onehq.libsonnet';
# values
local values = import 'staging-values.jsonnet';

{

  deploy: k.apps.v1.deployment.new(name='onehq-example-deploy-staging', replicas=2, podLabels={}, containers=[]) + k8.createDeploy(values.rails, 'onehq-example-staging '),
  cj: k.batch.v1.cronJob.new(name='onehq-example-cj-staging', schedule=[], containers=[]) + k8.generateCronJob(values.rails),
  ss: k.apps.v1.statefulSet.new(name='onehq-example-ss-staging', replicas=2, containers=[], volumeClaims=[], podLabels={}) + k8.createSS(values.cj, 'onehq-example-staging'),

}  
```  
In the root of the project, you will find the `values-example.jsonnet` file, which you can use as a reference to define the values for the Deployment, StatefulSet, and CronJob.  

You can run `tk show` to view the Kubernetes configuration generated from the Jsonnet files in the project without applying any changes to the cluster.  
```bash  
tk show environments/onehq-example-staging/  
```  
You can run `tk apply` to apply the generated configuration. This will deploy the resources defined in your files to the cluster.  
```bash 
tk apply environments/onehq-example-staging/  
```  
You can run `tk diff` to compare the current state of the resources. This allows you to see the differences before applying any changes.  
```bash  
tk diff environments/onehq-example-staging/