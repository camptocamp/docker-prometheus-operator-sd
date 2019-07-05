Prometheus-operator-sd
======================

This image dumps one static_config per Prometheus object in the K8S API that one
can use as a file in a file_sd_config scrape config.

Run this container and dump the output in a file:

```shell
$ docker run -e AUTH_TOKEN=<bearer_token> -v <file_sd_dir>:/output camptocamp/prometheus-operator-sd <api_endpoint> /output/targets.yml
$ docker run -v <file_sd_vol>:/etc/prometheus/k8s-federate prom/prometheus
```

You have to configure a scrape_config section in your prometheus.yml:

```yaml
  - job_name: 'k8s-federate'

    honor_labels: true
    params:
      match[]:
        - up
        - '{__name__=~".+"}'
    scheme: https
    bearer_token: "<bearer_token>"

    file_sd_configs:
      - files:
          - k8s-federate/targets.yml
        refresh_interval: 10s

    relabel_configs:
      - source_labels: [namespace,service]
        separator: ;
        regex: (.+);(.+)
        target_label: __metrics_path__
        replacement: /api/v1/namespaces/$1/services/$2:9090/proxy/federate
        action: replace
```
