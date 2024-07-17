# Pod scheduling will decide in which node any particular pod will run based on architecture.
# There are four types of pod scheduling
**1. Node-Based Scheduling:** 
        * This type involves directly specifying the node on which a pod will run using nodeName in the pod specification.
        * It did not supports HA and Failover If node is down all pod will come in pending state.
        * In this pod scheduling API won't talk with scheduler service becasue node is already defined.
2. 

    * Nodelabel and Selector based
    * Taint and Toleration based scheduling
    * Affinity and Anti-Affinity based scheduling

