# Projet Final : Déploiement Complet (Full Stack)

**Durée estimée :** 60 minutes  
**Type :** Travail indépendant de synthèse

## 🎯 Objectif
Mettre en place la "chaîne complète" vue durant la formation. D'un code source Frontend et Backend, jusqu'à leur mise en production sécurisée.

---

## 🛠️ Le Cahier des Charges

Vous jouez le rôle du Lead DevOps pour une startup qui lance une application de "Météo locale". Les développeurs ont poussé le code (un serveur backend API et un front React). À vous de mener le produit en production.

### Phase 1 : La Conteneurisation (Docker)
1. Rédigez un `Dockerfile` "Multi-stage" pour le Frontend.
   * *Stage 1 : Build de l'app (Node.js).*
   * *Stage 2 : Hébergement des fichiers statiques compilés avec un serveur NGINX allégé.*
2. Prouvez que les images peuvent se parler correctement via un `docker-compose.yaml` réunissant le Frontend et l'API sur le même réseau.

### Phase 2 : Automatisation CI/CD (Pipeline)
1. Rédigez le `.gitlab-ci.yml` ou `.github/workflows/deploy.yml`.
2. Le pipeline doit comporter les "Stages" suivants :
   - `Linting` : Vérification du code source.
   - `Testing` : Lancement des tests unitaires.
   - `Build` : Création et push des images Docker créées en Phase 1 sur un Registry.

### Phase 3 : L'Orchestration (Kubernetes)
La scalabilité est nécessaire au cas où le produit fait le "Buzz".
1. Rédigez les manifests Kubernetes (`deployment.yaml` et `service.yaml`) pour l'API Backend. Configurez 3 replicas.
2. Déployez le frontend avec un `service` de type `LoadBalancer` ou via un `Ingress Controller` pour exposer le port 80 au monde extérieur.

### Phase 4 (Bonus) : Observabilité
- Pensez au *"Day 2" Operations*. Comment l'équipe saura si le cluster surchauffe ? 
- Identifiez les modifications à apporter au cluster pour y adosser des briques de monitoring *Prometheus / Grafana* (Conceptuel/Explication orale ou brève doc).

---

## 📝 Livrable attendu
- Un répertoire Git architecturé.
- Les fichiers Dockerfiles (Front/Back) + Le docker-compose.
- Les fichiers YAML de Kubernetes (`deployments` et `services`).
- Le fichier du pipeline exécutable par la plateforme CI visée.
- *Un README clair explicitant la procédure de déploiement à un nouveau membre d'équipe.*
