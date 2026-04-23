# 🚀 Formation DevOps, CI/CD & Orchestration

Bienvenue dans le dépôt de la formation **DevOps, CI/CD & Orchestration**. Ce dépôt centralise  les **ateliers pratiques** permettant d'appliquer les concepts fondamentaux du déploiement moderne : Docker, Kubernetes, et les pipelines de CI/CD.

---

## 🗺️ Organisation du Dépôt

```
Formation_DevOps_CICD_Orchestration/
├── README.md                                  ← Ce fichier d'accueil
├── 📚 supports_cours/
│   ├── Formation_DevOps_CICD_Orchestration.docx ← Support exhaustif
│   ├── DevOps_Guide_Complet.docx              ← Guide complet
│   ├── DevOps_CICD_Orchestration.pptx         ← Slides de présentation
│   └── Plan_Formation_DevOps_CICD.pdf         ← Syllabus PDF
├── 🛠️ ateliers/                                ← Ateliers pratiques du cours
│   ├── 01-docker-compose-nodejs/              ← Atelier 1 : Conteneurisation (Docker)
│   ├── 02-kubernetes-minikube/                ← Atelier 2 : Orchestration (K8s)
│   ├── 03-pipeline-github-actions/            ← Atelier 3 : CI/CD (GitHub Actions)
│   └── 04-projet-final/                       ← Projet Final : Déploiement multi-services
└── (Dossiers de référence : CONTAINER, IAC, GIT, MONITORING, ORCHESTRATION)
```

---

## 🎯 Liste des Ateliers Pratiques (Hub)

La philosophie DevOps s'acquiert par la pratique et l'automatisation. **Cliquez sur un atelier pour accéder à son énoncé complet.**

| Module | Atelier | Objectif Clé |
|--------|---------|--------------|
| **Mod. 02** | [👉 Atelier 1 : Docker & Conteneurisation](./ateliers/01-docker-compose-nodejs/README.md) | Créer un Dockerfile et utiliser Docker Compose pour une app Node.js |
| **Mod. 03** | [👉 Atelier 2 : Kubernetes (Minikube)](./ateliers/02-kubernetes-minikube/README.md) | Déployer une application via des objets K8s (Pod, Deployment, Service) |
| **Mod. 04** | [👉 Atelier 3 : Pipeline CI/CD](./ateliers/03-pipeline-github-actions/README.md) | Automatiser les tests et le build via GitHub Actions |
| **Mod. 07** | [👉 Projet Final : Déploiement Complet](./ateliers/04-projet-final/README.md) | Architecturer et déployer une stack multi-services de bout en bout |

---

## 💡 Principes Fondamentaux DevOps (Rappel)

1. **CALMS** : Culture, Automation, Lean, Measurement, Sharing. Les outils (Docker, K8s) ne sont qu'un moyen ; la culture de la communication entre Devs et Ops est la vraie finalité.
2. **Infrastructure as Code (IaC)** : Tout ce qui peut être codé (infrastructures, pipelines, configurations) DOIT être versionné dans Git.
3. **Shift Left** : Intégrez les tests et la sécurité le plus tôt possible dans la pipeline CI/CD pour réduire le coût des anomalies.

Bonnes automatisations !
