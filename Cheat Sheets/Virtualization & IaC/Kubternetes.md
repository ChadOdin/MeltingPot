# Kubernetes (K8s) Cheat Sheet

## Pods
- **Create a pod:**
    ```bash
    kubectl create pod <pod-name> --image=<image-name>
    ```
    This command creates a pod with the specified name using the specified container image.

- **Get pods:**
    ```bash
    kubectl get pods
    ```
    This command lists all pods in the current namespace.

- **Delete a pod:**
    ```bash
    kubectl delete pod <pod-name>
    ```
    This command deletes the specified pod.

## Deployments
- **Create a deployment:**
    ```bash
    kubectl create deployment <deployment-name> --image=<image-name>
    ```
    This command creates a deployment with the specified name using the specified container image.

- **Get deployments:**
    ```bash
    kubectl get deployments
    ```
    This command lists all deployments in the current namespace.

- **Scale a deployment:**
    ```bash
    kubectl scale deployment <deployment-name> --replicas=<num-replicas>
    ```
    This command scales the specified deployment to the desired number of replicas.

- **Delete a deployment:**
    ```bash
    kubectl delete deployment <deployment-name>
    ```
    This command deletes the specified deployment.

## Services
- **Expose a deployment as a service:**
    ```bash
    kubectl expose deployment <deployment-name> --port=<port>
    ```
    This command exposes the specified deployment as a service on the specified port.

- **Get services:**
    ```bash
    kubectl get services
    ```
    This command lists all services in the current namespace.

- **Delete a service:**
    ```bash
    kubectl delete service <service-name>
    ```
    This command deletes the specified service.

## Configuration
- **Get configuration:**
    ```bash
    kubectl config view
    ```
    This command displays the current Kubernetes configuration.

- **Set current-context:**
    ```bash
    kubectl config use-context <context-name>
    ```
    This command sets the current context to the specified context name.

- **View current-context:**
    ```bash
    kubectl config current-context
    ```
    This command displays the current context.

## Nodes
- **Get nodes:**
    ```bash
    kubectl get nodes
    ```
    This command lists all nodes in the cluster.

- **Describe a node:**
    ```bash
    kubectl describe node <node-name>
    ```
    This command provides detailed information about the specified node.

## Volumes
- **Create a pod with a volume:**
    ```bash
    kubectl create pod <pod-name> --image=<image-name> --volume=<volume-name>
    ```
    This command creates a pod with the specified name using the specified container image and attaches the specified volume.

- **List volumes:**
    ```bash
    kubectl get pv
    ```
    This command lists all persistent volumes in the cluster.

## Secrets
- **Create a secret:**
    ```bash
    kubectl create secret generic <secret-name> --from-literal=<key>=<value>
    ```
    This command creates a secret with the specified name and data.

- **List secrets:**
    ```bash
    kubectl get secrets
    ```
    This command lists all secrets in the current namespace.

## ConfigMaps
- **Create a ConfigMap:**
    ```bash
    kubectl create configmap <configmap-name> --from-literal=<key>=<value>
    ```
    This command creates a ConfigMap with the specified name and data.

- **List ConfigMaps:**
    ```bash
    kubectl get configmaps
    ```
    This command lists all ConfigMaps in the current namespace.

## Ingress
- **Create an Ingress resource:**
    ```bash
    kubectl create ingress <ingress-name> --rule=<path>='<service-name>:<port>'
    ```
    This command creates an Ingress resource with the specified name and routing rule.

- **List Ingress resources:**
    ```bash
    kubectl get ingress
    ```
    This command lists all Ingress resources in the current namespace.

## Network Policies
- **Create a network policy:**
    ```bash
    kubectl create networkpolicy <policy-name> --spec=<policy-spec>
    ```
    This command creates a network policy with the specified name and specifications.

- **List network policies:**
    ```bash
    kubectl get networkpolicies
    ```
    This command lists all network policies in the current namespace.

## Custom Resource Definitions (CRDs)
- **Create a custom resource definition:**
    ```bash
    kubectl create -f <crd-definition.yaml>
    ```
    This command creates a custom resource definition using the specified YAML file.

- **List custom resource definitions:**
    ```bash
    kubectl get crds
    ```
    This command lists all custom resource definitions in the cluster.

## StatefulSets
- **Create a StatefulSet:**
    ```bash
    kubectl create -f <statefulset-definition.yaml>
    ```
    This command creates a StatefulSet using the specified YAML file.

- **Scale a StatefulSet:**
    ```bash
    kubectl scale statefulset <statefulset-name> --replicas=<num-replicas>
    ```
    This command scales the specified StatefulSet to the desired number of replicas.

## Jobs and CronJobs
- **Create a Job:**
    ```bash
    kubectl create job <job-name> --image=<image-name> -- <command>
    ```
    This command creates a one-off Job with the specified name and command.

- **Create a CronJob:**
    ```bash
    kubectl create cronjob <cronjob-name> --image=<image-name> --schedule=<schedule> -- <command>
    ```
    This command creates a CronJob to run the specified command on a schedule.

## Horizontal Pod Autoscaler (HPA)
- **Create an HPA:**
    ```bash
    kubectl autoscale deployment <deployment-name> --cpu-percent=<target-cpu-percent> --min=<min-replicas> --max=<max-replicas>
    ```
    This command creates an HPA for the specified deployment based on CPU utilization.

## Pod Security Policies (PSP)
- **Create a Pod Security Policy:**
    ```bash
    kubectl create -f <psp-definition.yaml>
    ```
    This command creates a Pod Security Policy using the specified YAML file.

## Service Mesh (e.g., Istio)
- **Install Istio:**
    ```bash
    istioctl install
    ```
    This command installs Istio in the Kubernetes cluster.

- **Configure Istio Ingress Gateway:**
    ```bash
    istioctl manifest apply --set profile=demo
    ```
    This command configures Istio Ingress Gateway.

## Custom Metrics
- **Create a custom metric HPA:**
    ```bash
    kubectl autoscale deployment <deployment-name> --metric-name=<metric-name> --target-custom-metric=<target-metric-value> --min=<min-replicas> --max=<max-replicas>
    ```
    This command creates an HPA based on custom application metrics.

## Pod Disruption Budgets (PDB)
- **Create a PDB:**
    ```bash
    kubectl create pdb <pdb-name> --min-available=<num-pods>
    ```
    This command creates a Pod Disruption Budget to ensure a minimum number of pods are available during maintenance.

## PersistentVolumeClaims (PVC)
- **Create a PVC:**
    ```bash
    kubectl create -f <pvc-definition.yaml>
    ```
    This command creates a PersistentVolumeClaim using the specified YAML file.

## Resource Quotas and LimitRange
- **Create a Resource Quota:**
    ```bash
    kubectl create quota <quota-name> --hard=<resource-limits>
    ```
    This command creates a Resource Quota with specified limits.

## PodAffinity and PodAntiAffinity
- **Set PodAffinity:**
    ```bash
    kubectl label pod <pod-name> <label-key>=<label-value>
    ```
    This command sets PodAffinity based on labels.

## Taints and Tolerations
- **Taint a node:**
    ```bash
    kubectl taint nodes <node-name> <taint-key>=<taint-value>:<taint-effect>
    ```
    This command taints a node with the specified key, value, and effect.

## Network Plugins (e.g., Calico, Flannel)
- **Install Calico:**
    ```bash
    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
    ```
    This command installs Calico as the network plugin in the cluster.

## Container Runtime Interface (CRI)
- **View container runtimes:**
    ```bash
    crictl ps
    ```
    This command lists containers using the Container Runtime Interface (CRI).

## Pod Design Patterns
- **Sidecar Pattern**: 
  - Deploying a helper container alongside the main application container.
- **Ambassador Pattern**: 
  - Exposing an application to the external world through a separate proxy container.
- **Adapter Pattern**: 
  - Adapting an existing service to meet the requirements of a new service interface.
- **Initializer Pattern**: 
  - Initializing or configuring a pod before the main container starts.

## Pod Overhead
- **View pod overhead:**
    ```bash
    kubectl top pod <pod-name> --containers
    ```
    This command shows the CPU and memory overhead of a pod's containers.

## Pod Presets
- **Enable Pod Presets:**
    ```bash
    kubectl create -f <pod-preset-definition.yaml>
    ```
    This command enables Pod Presets using the specified YAML file.

## Pod Security Contexts
- **Set security context in a pod spec:**
    ```yaml
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
      fsGroup: 2000
    ```
    This YAML snippet sets security-related attributes for a pod.

## DaemonSets
- **Create a DaemonSet:**
    ```bash
    kubectl create -f <daemonset-definition.yaml>
    ```
    This command creates a DaemonSet using the specified YAML file.

## Pod Lifecycle
- **View pod lifecycle events:**
    ```bash
    kubectl describe pod <pod-name>
    ```
    This command displays detailed information about a pod, including its lifecycle events.

## Multi-container Pods
- **Create a multi-container pod:**
    ```yaml
    spec:
      containers:
      - name: main-container
        image: <main-image>
      - name: helper-container
        image: <helper-image>
    ```
    This YAML snippet defines a pod with multiple containers.

## Kubernetes Dashboard
- **Access Kubernetes Dashboard:**
    ```bash
    kubectl proxy
    ```
    Open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ in a web browser.

## Kubectl Plugins
- **Install kubectl plugins:**
    ```bash
    kubectl krew install <plugin-name>
    ```
    This command installs a kubectl plugin using krew.

## Kubernetes API
- **Interact with Kubernetes API:**
    ```bash
    curl -X GET http://localhost:8001/api/<version>/<resource>
    ```
    This command sends a GET request to the Kubernetes API to retrieve resources.

## Kubernetes Operators
- **Install Operator SDK:**
    ```bash
    operator-sdk init --domain=<your-domain> --repo=<your-repo>
    ```
    This command initializes a new operator project with the Operator SDK.

- **Create a custom resource and controller:**
    ```bash
    operator-sdk create api --group=<group> --version=<version> --kind=<kind>
    ```
    This command creates a custom resource definition (CRD) and controller.

## Pod Disruption Budgets (PDB)
- **Create a PDB:**
    ```bash
    kubectl create pdb <pdb-name> --min-available=<num-pods>
    ```
    This command creates a Pod Disruption Budget to ensure a minimum number of pods are available during maintenance.

## Pod Priority and Preemption
- **Set pod priority:**
    ```yaml
    spec:
      priorityClassName: <priority-class-name>
    ```
    This YAML snippet sets the priority for a pod.

- **Enable preemption:**
    ```yaml
    spec:
      priorityClassName: <priority-class-name>
      preemptionPolicy: PreemptLowerPriority
    ```
    This YAML snippet enables preemption for the pod.

## Kubernetes Namespaces
- **Create a namespace:**
    ```bash
    kubectl create namespace <namespace-name>
    ```
    This command creates a new namespace.

- **List namespaces:**
    ```bash
    kubectl get namespaces
    ```
    This command lists all namespaces in the cluster.

## Kubernetes RBAC (Role-Based Access Control)
- **Create a role:**
    ```bash
    kubectl create role <role-name> --verb=<verb> --resource=<resource> --namespace=<namespace>
    ```
    This command creates a role with specified permissions.

- **Assign role to user:**
    ```bash
    kubectl create rolebinding <rolebinding-name> --role=<role-name> --user=<username> --namespace=<namespace>
    ```
    This command assigns a role to a user within a namespace.

## Kubernetes Custom Resource Definitions (CRDs)
- **Create a CRD:**
    ```bash
    kubectl create -f <crd-definition.yaml>
    ```
    This command creates a Custom Resource Definition using the specified YAML file.

## Kubernetes Admission Controllers
- **Enable admission controller:**
    ```bash
    kube-apiserver --enable-admission-plugins=<list-of-plugins>
    ```
    This command enables specified admission controllers for the Kubernetes API server.

## Kubernetes API Server
- **View API server logs:**
    ```bash
    kubectl logs -n kube-system <api-server-pod-name>
    ```
    This command displays logs from the Kubernetes API server pod.

## Kubernetes Control Plane Components
- **View control plane components:**
    ```bash
    kubectl get componentstatuses
    ```
    This command lists the status of control plane components.

## Kubernetes Networking
- **View network policies:**
    ```bash
    kubectl get networkpolicies
    ```
    This command lists all network policies in the cluster.

## Kubernetes Storage
- **Create a storage class:**
    ```bash
    kubectl create storageclass <storageclass-name> --provisioner=<provisioner> --parameters=<parameters>
    ```
    This command creates a storage class for dynamic provisioning.

- **Create a PersistentVolumeClaim (PVC):**
    ```bash
    kubectl create -f <pvc-definition.yaml>
    ```
    This command creates a PersistentVolumeClaim using the specified YAML file.