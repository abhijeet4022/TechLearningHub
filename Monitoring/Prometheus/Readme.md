# Prometheus is a metrics monitoring tool.
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