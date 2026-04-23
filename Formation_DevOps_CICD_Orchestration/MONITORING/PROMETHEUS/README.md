# 📊 PROMETHEUS - Monitoring & Alerting

## 🎯 Pourquoi Prometheus ?

Prometheus est **LE** standard pour le monitoring cloud-native :
- ✅ **Métriques** : Time-series database
- ✅ **Pull-based** : Scraping des targets
- ✅ **PromQL** : Langage de requêtes puissant
- ✅ **Alerting** : Alertmanager intégré
- ✅ **Service Discovery** : Auto-découverte (K8s, AWS, etc.)

---

## 📚 Architecture

```
Applications
    ↓ (expose /metrics)
Prometheus Server
    ↓ (scrape)
TSDB (Time Series Database)
    ↓ (query)
Grafana (Visualisation)
    ↓
Alertmanager (Alertes)
```

---

## 🛠️ Installation

### Docker Compose
```yaml
version: '3'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

volumes:
  prometheus-data:
  grafana-data:
```

### Configuration (prometheus.yml)
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  # Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter (métriques OS)
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

  # Application
  - job_name: 'app'
    static_configs:
      - targets: ['app:8080']
```

---

## 📊 PromQL - Exemples

```promql
# CPU usage
rate(cpu_usage_seconds_total[5m])

# Memory usage
node_memory_Active_bytes / node_memory_MemTotal_bytes * 100

# HTTP requests per second
rate(http_requests_total[5m])

# 95th percentile latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Error rate
rate(http_requests_total{status="500"}[5m])
```

---

## 🚨 Alerting (alertmanager)

```yaml
# alerts.yml
groups:
- name: example
  rules:
  - alert: HighCPU
    expr: cpu_usage > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU on {{ $labels.instance }}"
      description: "CPU is above 80% (current: {{ $value }}%)"
```

---

## 📚 Exercices

- [01: Installation](./exercices/01-installation)
- [02: Premier Dashboard](./exercices/02-dashboard)
- [03: PromQL](./exercices/03-promql)
- [04: Alerting](./exercices/04-alerting)
- [05: Kubernetes Monitoring](./exercices/05-k8s)

---

**Voir aussi :** [Grafana](../GRAFANA/README.md)
