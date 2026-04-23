# 📊 MONITORING — Observabilité & Alerting

> **Prérequis :** Docker, notions de réseaux | **Durée totale :** ~2 semaines | **Niveau :** Intermédiaire

---

## 🗺️ Structure du Module

```
MONITORING/
├── README.md          ← Ce fichier
├── PROMETHEUS/
│   └── README.md      ← Métriques & Alerting (+ exercices)
└── GRAFANA/
    └── README.md      ← Dashboards & Visualisation (+ exercices)
```

---

## 🎯 Les 3 Piliers de l'Observabilité

```
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│    LOGS     │   │   MÉTRIQUES │   │   TRACES    │
│             │   │             │   │             │
│ Que s'est-  │   │ Combien ?   │   │ Où ça prend │
│ il passé ?  │   │ Quelle      │   │ du temps ?  │
│             │   │ tendance ?  │   │             │
│ ELK Stack   │   │ Prometheus  │   │ Jaeger      │
│ Loki        │   │ InfluxDB    │   │ Zipkin      │
└─────────────┘   └─────────────┘   └─────────────┘
                        ▼
              ┌─────────────────┐
              │     GRAFANA     │
              │  (Visualisation │
              │   unifiée)      │
              └─────────────────┘
```

---

## 🚀 Stack Prometheus + Grafana (Docker Compose)

Lancez la stack complète en une commande :

```bash
# Créer le fichier docker-compose.yml
cat > ~/monitoring-lab/docker-compose.yml << 'EOF'
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.retention.time=15d'

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'

volumes:
  prometheus-data:
  grafana-data:
EOF

# Lancer
docker-compose up -d

# Accès
# Prometheus : http://localhost:9090
# Grafana    : http://localhost:3000  (admin / admin)
# Node Exporter Metrics : http://localhost:9100/metrics
```

---

## 📊 Exercices — Tableau de Bord

| Module | Exercice | Durée |
|--------|----------|-------|
| Prometheus | [Installation & Configuration](./PROMETHEUS/README.md#exercices) | 1h |
| Prometheus | [PromQL — Requêtes de base](./PROMETHEUS/README.md#promql) | 1h30 |
| Prometheus | [Alerting avec Alertmanager](./PROMETHEUS/README.md#alerting) | 2h |
| Grafana | [Premier Dashboard](./GRAFANA/README.md#exercices) | 1h |
| Grafana | [Panels avancés & Variables](./GRAFANA/README.md#variables) | 2h |
| Grafana | [Alerting Grafana](./GRAFANA/README.md#alerting) | 1h30 |

---

## ✅ Checklist de Progression

- [ ] **Niveau 1** : Je lance Prometheus + Grafana avec Docker Compose
- [ ] **Niveau 2** : J'écris des requêtes PromQL et comprends les métriques
- [ ] **Niveau 3** : Je crée des dashboards Grafana avec variables
- [ ] **Niveau 4** : Je configure des alertes et des notifications Slack/email

---

## 🔗 Ressources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
- [Dashboards communautaires Grafana](https://grafana.com/grafana/dashboards/)
