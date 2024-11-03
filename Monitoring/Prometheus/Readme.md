# Prometheus is a completely open source metrics monitoring tool.
# Server Configuration.
- Install prometheus on prometheus server from `https://prometheus.io/download/`

# Client Configuration.
- Install Node exporter on Node from - `https://prometheus.io/download/#node_exporter'

* In prometheus server mention the node details on configuration file - `/opt/prometheus/prometheus.yml`.
```   
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
      - targets: ["localhost:9090"]
        labels:
          name: "Master_Node"


  # Node2 Details
  - job_name: "node2"
    static_configs:
      - targets: ["172.16.0.3:9100"]
        labels:
          name: "Node-2"      

  # Node1 Details
  - job_name: "node1"
    static_configs:
      - targets: ["172.16.0.2:9100"]
        labels:
          name: "Node-1"      
```

* If the server ip is not fixed then use ec2_sd to fetch the IP dynamically.
* This is the Scrape Config to discover the EC2 based on tag "Monitor = yes"
``` 
scrape_configs:
- job_name: 'ec2'
  ec2_sd_configs:
    - region: us-east-1
      port: 9100
      filters:
        - name: "tag:Monitor"
          values: ["yes"]
```

# To by default it will come with IP and port for the instance and it is difficult to recognise the Server. So we will use relabel config to add some label.
```
relabel_configs:
  - source_labels: [ __meta_ec2_tag_Name ]
    target_label: name
  - source_labels: [ __meta_ec2_tag_env ]
    target_label: env
  - source_labels: [ __meta_ec2_instance_type ]
    target_label: instance_type
  - source_labels: [ __meta_ec2_instance_state ]
    target_label: instance_state
```

# Now if any node went down prometheus should create alert also.
```
groups:
  - name: VirtualMachine
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Node Down"
```


# Query
* To check uptime.
`UP`

* CPU Utilization
* For single core.
`100 - (rate(node_cpu_seconds_total{mode="idle"}[1m]) * 100)`
* For multiple core.
`avg by (name) (100 - (rate(node_cpu_seconds_total{mode="idle"}[1m]) * 100))` or
`avg by (instance,name,job,instance_state,instance-type) (100 - (rate(node_cpu_seconds_total{mode="idle"}[1m]) * 100))`
* Full Explanation of Query Logic
- Step 1: node_cpu_seconds_total{mode="idle"} filters only the idle time of the CPU, allowing us to focus on how much time the CPU spends in an idle state.
- Step 2: rate(...[5m]) calculates the per-second rate of increase in idle time over the last 5 minutes, giving us the "idle rate."
- Step 3: avg(...) takes this idle rate and averages it across all cores to get a system-wide idle rate.
- Step 4: 1 - avg(...) flips the idle rate to active rate, showing us the proportion of time spent in non-idle states (i.e., active CPU time).
- Step 5: 100 * (...) converts this active CPU fraction into a percentage, which is the CPU utilization over the past 5 minutes.

* Memory Utilization
* To Calculate Free Memory Percentage.
`((node_memory_MemFree_bytes + node_memory_Cached_bytes + node_memory_Buffers_bytes) / node_memory_MemTotal_bytes) * 100`
* To Calculate Used Memory Percentage.
`100 - (((node_memory_MemFree_bytes + node_memory_Cached_bytes + node_memory_Buffers_bytes) / node_memory_MemTotal_bytes) * 100)`

* Configure Nginx exporter to see nginx logs
* Total Request
`nginx_http_request_total` - Stat
`rate(nginx_http_request_total[1m])` - TimeSeries