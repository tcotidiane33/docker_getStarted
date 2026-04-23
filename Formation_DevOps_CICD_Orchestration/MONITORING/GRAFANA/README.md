# 📈 GRAFANA - Dashboards & Visualisation

## 🎯 Pourquoi Grafana ?

- ✅ **Multi-sources** : Prometheus, InfluxDB, Elasticsearch, etc.
- ✅ **Dashboards** : Visualisation puissante
- ✅ **Alerting** : Notifications multi-canaux
- ✅ **Templating** : Dashboards dynamiques
- ✅ **Plugins** : Extensible

---

## 🚀 Quickstart

### Docker
```bash
docker run -d -p 3000:3000 --name=grafana grafana/grafana
```

**Accès :** http://localhost:3000  
**Credentials :** admin / admin

---

## 📊 Configuration Data Source (Prometheus)

1. Settings → Data Sources → Add Prometheus
2. URL: `http://prometheus:9090`
3. Save & Test

---

## 📈 Dashboard Essentials

### Panels Types
- **Graph** : Time series
- **Stat** : Single value
- **Gauge** : Jauge
- **Table** : Tableau
- **Heatmap** : Carte de chaleur

### Variables (Templating)
```
Name: instance
Query: label_values(up, instance)
```

Utilisation dans query :
```promql
rate(http_requests_total{instance="$instance"}[5m])
```

---

## 🚨 Alerting

```yaml
# Alert Rule
Expression: cpu_usage > 80
For: 5m
Conditions: WHEN last() OF query(A) IS ABOVE 80

# Notification Channel
Type: Slack
Webhook URL: https://hooks.slack.com/services/...
```

---

## 📚 Exercices

- [01: Premier Dashboard](./exercices/01-dashboard)
- [02: Panels Avancés](./exercices/02-panels)
- [03: Variables](./exercices/03-variables)
- [04: Alerting](./exercices/04-alerting)

---

## 📦 Dashboards Pré-faits

- [Node Exporter Full](https://grafana.com/grafana/dashboards/1860)
- [Kubernetes Cluster](https://grafana.com/grafana/dashboards/7249)
- [Docker Monitoring](https://grafana.com/grafana/dashboards/893)

---

**Voir aussi :** [Prometheus](../PROMETHEUS/README.md)
