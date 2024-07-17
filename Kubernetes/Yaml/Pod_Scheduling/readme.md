# Pod scheduling will decide in which node any particular pod will run based on architecture.
# There are four types of pod scheduling
**1. Node-Based Scheduling:** 
* This type involves directly specifying the node on which a pod will run using `nodeName` in the pod specification.
* It does not support High Availability (HA) and failover mechanisms. If the designated node becomes unavailable, all pods assigned to it will remain in a pending state until the node is restored or manually rescheduled.
* In this mode of scheduling, the Kubernetes scheduler service is bypassed because the node assignment is explicitly defined, thereby eliminating the need for the scheduler to make placement decisions.

**2. Node label and Selector-based:**
* Node label and selector-based scheduling in Kubernetes allows you to control where your pods are scheduled based on labels assigned to nodes and selectors specified in pod specifications.
* We can use Node label and Selector-based scheduling on two sources.
  1. Pod labels: Labels assigned directly to pods/deployment yaml file.
  2. Name Space Label: Labels assigned to namespaces.
     *  By default, this setting is disabled. To enable it, you need to edit the `/etc/kubernetes/manifests/kube-apiserver.yaml` file.
     * Add or modify the `--enable-admission-plugins` flag to include "NodeRestriction" and "PodNodeSelector", like so.
     * `- --enable-admission-plugins=NodeRestriction,PodNodeSelector`
     * Save the file and wait for the API server to restart automatically.
     * Verify it by `ps -ef | grep -i API | grep -i PodNodeSelector`
     * After enabling the feature, you can annotate namespaces where you want to utilize node selectors for pod scheduling. Annotate a namespace with the following annotation.
     * `annotations:
       scheduler.alpha.kubernetes.io/node-selector: "your-node-label-key=your-node-label-value"
       `
     * Once annotated, all pods created within that namespace will look for the specified node label and schedule pods accordingly.
     
**3. Taint and Toleration based scheduling**
* Taints and tolerations based scheduling in Kubernetes provide a mechanism for controlling which pods can be scheduled on which nodes, based on node "taints" and pod "tolerations".
* This is helpful when we don't want to create any unwanted pod on any particular node.
* Taint Node: `Node Side` and Toleration: `Deployment Side`
* Master node by default comes with tained; that's why no container will spin in Master Node.
* In industry, we will use both taint-tolerations with node selector. Taint won't allow other containers to spin and node selector will restrict the container to spin on selected node only.
* **Use Cases:**

  **1. Node Specialization:** Taints can be used to mark nodes with specialized hardware (e.g., GPUs) so that only pods requiring those resources are scheduled there.

  **2. Team or Application Isolation:** Taints can isolate nodes for specific teams or applications, ensuring resource segregation.

* **Taint Effect:**
  **1. NoSchedule:** It does not evict existing pod even we did not mention tolerations on deployment.
  **2. NoExecute:** It will evict existing pod if we did not mention tolerations.
* 
* 
 

    * Affinity and Anti-Affinity based scheduling

