# ReplicationController(RC)
* RC is a structure that enables you to easily create multiple pods, then make sure that that number of pods always exists. If a pod does crash, the Replication Controller replaces it. 
* It is an equality-based selector, so we can define only one selector to select the pod based on label.

# ReplicaSet(RS)
* A ReplicaSet (RS) is a Kubernetes object used to maintain a stable set of replicated pods running within a cluster at any given time.
* It supports multiple labels and selectors to select the pod for the controller.
 