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

  # Node1 Details
  - job_name: "node2"
    static_configs:
      - targets: ["172.16.0.3:9100"]

  # Node2 Details
  - job_name: "node1"
    static_configs:
      - targets: ["172.16.0.2:9100"]
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


# Query
* To check uptime.
`UP`