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


**4. Affinity and Anti-Affinity based scheduling:**
* Here we have more flexibility over the node selection based on label. In nodeSelector we can use only one type of condition, but here we can use more conditions.
1. Affinity: "disk=ssd" It will create the pod on the node has label "disk=ssd"
2. Anti-Affinity: "disk=ssd" It will create the pod on all node except the node labeled with "disk=ssd".

* Affinity Operator
1. In: It will match key and value.
2. Exists: It will match only key not the value.

* Anti-Affinity Operator
1. NotIn: It will match key and value.
2. DoesNotExists: It will match only key not the value.

* Affinity and Anti-Affinity has two types:
1. Node Type: It will check the nodes where to create the pod.
2. Pod Type: It will check the created pod, where to create or not.
   1. Inter Affinity: Two pods must run on the same node.
   2. Inter Anti-Affinity: Two pods should not run on the same node.
* `requiredDuringSchedulingIgnoredDuringExecution` : Pods must be placed on nodes matching the criteria.
* `matchExpressions` : Specifies that the node must have the label disk=ssd
* `Required`: This is a "hard" rule. The node must match the criteria, or the pod won't be scheduled.
* `Preferred`: This is a "soft" rule. Kubernetes will try to place the pod on a matching node, but if none are available, the pod will be scheduled on any available node, so it won't remain pending.




