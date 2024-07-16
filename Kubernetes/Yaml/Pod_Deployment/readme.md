# ReplicationController(RC)
* RC is a structure that enables you to easily create multiple pods, then make sure that that number of pods always exists. If a pod does crash, the Replication Controller replaces it. 
* It is an equality-based selector, so we can define only one selector to select the pod based on label.

# ReplicaSet(RS)
* A ReplicaSet (RS) is a Kubernetes object used to maintain a stable set of replicated pods running within a cluster at any given time.
* It supports multiple labels and selectors to select the pod for the controller.


# Deployments
* Deployments come with all the features of RS.
* It additionally supports Rollout and Rollback.
* When we create deployment automatically, it will create on RS in backend to achieve the HA and Scalability. 
* rolling update means it;s a blue green deployment strategy
* recreate means it's cannery deployment strategy
* Canary Deployment is a technique to reduce the risk of introducing a new software version in production by gradually shifting traffic to the new version while monitoring its performance. It allows for early detection of issues before rolling out the new version to the entire user base.
* Blue-Green Deployment is a release management strategy that reduces downtime and risk by running two identical production environments, Blue and Green. One environment (let's say Blue) is live and serving all the production traffic. The other environment (Green) is idle and used to test the new version of the application.
* Rolling Update is a deployment strategy in Kubernetes that gradually updates the instances of a deployment's pods with new versions. It ensures that some instances of the application are always running and available during the update process, minimizing downtime.
 