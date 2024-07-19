## This is helpful if we do not define the quota on resource level also user cannot define the unwanted minimum quota on deployment if mentioning.
#apiVersion: v1
#kind: LimitRange
#metadata:
#  name: cpu-resource-constraint
#spec:
#  limits:
#    - type: Container
#      # This is useful when we didn't mention the quota on deployment.
#      defaultRequest: # this section defines default requests
#        memory: 128mi
#        cpu: 200m
#      default: # this section defines default limits
#        memory: 256Mi
#        cpu: 400m
#      # This will restrict user to define unnecessary quota value on deployment.
#      max: # max and min define the limit range
#        memory: 800Mi
#        cpu: 1000m
#      min:
#        memory: 100Mi
#        cpu: 150m

---