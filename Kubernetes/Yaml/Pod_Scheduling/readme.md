# Pod scheduling will decide in which node any particular pod will run based on architecture.
# There are four types of pod scheduling
**1. Node-Based Scheduling:** 
* This type involves directly specifying the node on which a pod will run using `nodeName` in the pod specification.
* It does not support High Availability (HA) and failover mechanisms. If the designated node becomes unavailable, all pods assigned to it will remain in a pending state until the node is restored or manually rescheduled.
* In this mode of scheduling, the Kubernetes scheduler service is bypassed because the node assignment is explicitly defined, thereby eliminating the need for the scheduler to make placement decisions.

2. 

    * Nodelabel and Selector based
    * Taint and Toleration based scheduling
    * Affinity and Anti-Affinity based scheduling

