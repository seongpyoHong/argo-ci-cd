# Argo CI/CD
The Repository for Spring Boot Application CI & CD using Argo Events, Workflow, CD in GCP(GKS).

---
## Component
Namespace : argo-events(Argo Event), argo(Argo Workflow), argocd(Argo CD)

### Secret

- **source-key-argo**
    
    The secret to access source repository with ssh private key. It used by Argo Workflow to pull the application code to test.    


- **deploy-key-argo**
    
    The secret to access deploy repository with ssh private key. It used by Argo Workflow to push the k8s manifest when CI is completed.     


- **deploy-key-argocd**
    
    The secret to access deploy repository with ssh private key. It used by Argo CD to pull k8s manifest when CD start.

- **github-access-argo-event**
    
    The secret to create Github API token for source repository. It used by Argo Event to receive webhook if new code is pushed. 

- **github-access-argo**
    
    The secret to create Github API token for deploy repository. It used by Argo Workflow to create pull request, commit, push in CI.

- **gcr-credentials**
    
    The secret to access GCP.


### Argo Event

- **event-source**
    
    The Custom Resource for Event Source. Event Source is configuration for received events.

- **event-source-svc**
    
    The Services accessible by webhook

- **event-sensor** 
    
    The Custom Resource for Event Sensor. Event Sensor perform predefined triggers when receive events which set in the sensor. 


### Argo Workflow
- **workflow-template**
    
    Predefined workflowTemplate. It used by Trigger in Event Sensor to create workflow.

- **argo-clusterrole**
    
    The clusterrole to access resources in argo namespace.

### Argo CD
- **application**
    The Custom Resource for Application. Application is configuration to deploy by ArgoCD.

- **repository**
    The ConfigMap to access deploy repository. It used by ArgoCD to deploy application CR.



**You can perform the entire process at once through `init.sh`. If you are curious about the details, please refer to [my blog post](https://sphong0417.tistory.com/2).**