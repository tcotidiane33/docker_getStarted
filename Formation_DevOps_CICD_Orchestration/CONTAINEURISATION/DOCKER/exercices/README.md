# 🐳 Docker - Exercices et Objectifs

## Vue d'Ensemble du Parcours

Ce module contient **10 exercices progressifs** pour maîtriser Docker de zéro à un niveau production-ready. 

**Durée totale estimée**: 15-20 heures  
**Niveau**: Débutant → Avancé

---

## 📋 Liste des Exercices

### [Exercice 01 : Installation et Configuration Docker](./01-installation/README.md)
⏱️ **45 minutes** | 🎯 **Niveau: Débutant**

**Objectifs:**
- ✅ Installer Docker sur votre système (macOS/Linux/Windows)
- ✅ Vérifier que Docker fonctionne correctement
- ✅ Comprendre les composants Docker (Engine, CLI, Daemon)
- ✅ Exécuter votre premier container

**Concepts clés:** Installation, Docker daemon, hello-world, port mapping

---

### [Exercice 02 : Premiers Containers](./02-premiers-containers/README.md)
⏱️ **1 heure** | 🎯 **Niveau: Débutant**

**Objectifs:**
- ✅ Lancer différents types de containers (interactif, détaché)
- ✅ Gérer le cycle de vie (start, stop, restart, pause)
- ✅ Inspecter l'état des containers
- ✅ Interagir avec des containers en cours
- ✅ Copier des fichiers vers/depuis containers

**Concepts clés:** Modes interactifs vs détachés, logs, exec, inspect, stats

---

### [Exercice 03 : Maîtrise de Docker CLI](./03-docker-cli/README.md)
⏱️ **1 heure 30** | 🎯 **Niveau: Intermédiaire**

**Objectifs:**
- ✅ Utiliser les commandes Docker avancées
- ✅ Filtrer et formater les sorties
- ✅ Gérer les images efficacement
- ✅ Utiliser les networks de base
- ✅ Nettoyer et maintenir votre environnement Docker

**Concepts clés:** Filters, formats, prune, network basics, resource management

---

### [Exercice 04 : Premier Dockerfile](./04-dockerfile/README.md)
⏱️ **1 heure 30** | 🎯 **Niveau: Intermédiaire**

**Objectifs:**
- ✅ Créer un Dockerfile from scratch
- ✅ Comprendre les instructions (FROM, RUN, COPY, CMD, ENTRYPOINT)
- ✅ Build des images Docker
- ✅ Optimiser le cache des layers
- ✅ Utiliser .dockerignore

**Concepts clés:** Dockerfile instructions, layer caching, .dockerignore, ARG vs ENV, CMD vs ENTRYPOINT

---

### [Exercice 05 : Application Node.js Avancée](./05-nodejs-app/README.md)
⏱️ **2 heures** | 🎯 **Niveau: Intermédiaire**

**Objectifs:**
- ✅ Créer une application Node.js/Express complète
- ✅ Implémenter le hot-reload en développement
- ✅ Gérer plusieurs environnements (dev/prod)
- ✅ Optimiser l'image avec multi-stage builds
- ✅ Utiliser des volumes pour le développement

**Concepts clés:** Hot reload, environment-specific builds, dumb-init, health checks

---

### [Exercice 06 : Docker Volumes - Persistence](./06-volumes/README.md)
⏱️ **1 heure 30** | 🎯 **Niveau: Intermédiaire**

**Objectifs:**
- ✅ Créer et gérer des volumes Docker
- ✅ Comprendre les types de montage (volume, bind, tmpfs)
- ✅ Partager des données entre containers
- ✅ Backup et restore des volumes
- ✅ Volumes pour bases de données

**Concepts clés:** Named volumes, bind mounts, tmpfs, volume drivers, backup/restore

---

### [Exercice 07 : Docker Networks](./07-networks/README.md)
⏱️ **1 heure 30** | 🎯 **Niveau: Intermédiaire**

**Objectifs:**
- ✅ Créer et gérer des networks Docker
- ✅ Comprendre les drivers (bridge, host, none)
- ✅ Connecter des containers entre eux
- ✅ Isoler des containers sur différents networks
- ✅ Débugger la connectivité réseau

**Concepts clés:** Bridge networks, DNS resolution, network isolation, aliases, microservices architecture

---

### [Exercice 08 : Docker Compose](./08-docker-compose/README.md)
⏱️ **2 heures** | 🎯 **Niveau: Avancé**

**Objectifs:**
- ✅ Créer un fichier docker-compose.yml
- ✅ Orchestrer plusieurs services
- ✅ Gérer les dépendances entre services
- ✅ Utiliser des variables d'environnement
- ✅ Scaler des services
- ✅ Déployer des stacks complètes

**Concepts clés:** Services, depends_on, environment variables, scaling, override files

---

### [Exercice 09 : Multi-Stage Builds](./09-multistage/README.md)
⏱️ **1 heure 30** | 🎯 **Niveau: Avancé**

**Objectifs:**
- ✅ Créer des Dockerfiles multi-stage
- ✅ Optimiser la taille des images (réduction jusqu'à 98%)
- ✅ Séparer build dependencies des runtime dependencies
- ✅ Créer des images production-ready
- ✅ Utiliser des build targets

**Concepts clés:** Multi-stage builds, distroless images, scratch images, build optimization

---

### [Exercice 10 : Projet Final Production-Ready](./10-projet-final/README.md)
⏱️ **3-4 heures** | 🎯 **Niveau: Expert**

**Objectifs:**
- ✅ Application full-stack complète
- ✅ Frontend + Backend + Database + Cache
- ✅ Reverse proxy avec Nginx
- ✅ Multi-stage builds optimisés
- ✅ Health checks sur tous les services
- ✅ Networks isolés multi-tiers
- ✅ Volumes persistants
- ✅ Scripts de backup et monitoring

**Concepts clés:** Production architecture, reverse proxy, health checks, graceful shutdown, monitoring

---

## 🎯 Progression Recommandée

### Semaine 1 : Fondamentaux
- **Jour 1-2:** Exercices 01-02 (Installation + Premiers containers)
- **Jour 3-4:** Exercice 03 (CLI avancée)
- **Jour 5-7:** Exercices 04-05 (Dockerfile + Node.js)

### Semaine 2 : Concepts Avancés
- **Jour 8-9:** Exercices 06-07 (Volumes + Networks)
- **Jour 10-12:** Exercice 08 (Docker Compose)
- **Jour 13-14:** Exercices 09-10 (Multi-stage + Projet final)

---

## ✅ Auto-Évaluation par Niveau

### 🟢 Niveau Débutant (Exercices 1-3)
- [ ] Je peux installer et configurer Docker
- [ ] Je lance et gère des containers basiques
- [ ] Je comprends les commandes CLI essentielles
- [ ] Je sais voir les logs et inspecter les containers

### 🟡 Niveau Intermédiaire (Exercices 4-7)
- [ ] Je crée des Dockerfiles optimisés
- [ ] J'utilise des volumes pour la persistence
- [ ] Je configure des networks multi-containers
- [ ] Je comprends le layer caching

### 🔴 Niveau Avancé (Exercices 8-10)
- [ ] Je maîtrise Docker Compose
- [ ] J'utilise les multi-stage builds
- [ ] Je crée des applications production-ready
- [ ] Je peux orchestrer des stacks complètes
- [ ] Je connais les best practices de sécurité

---

## 📚 Compétences Acquises

À la fin de ce parcours, vous serez capable de:

### Développement
- ✅ Containeriser n'importe quelle application
- ✅ Mettre en place un environnement de dev avec Docker
- ✅ Utiliser le hot-reload pour le développement
- ✅ Gérer plusieurs environnements (dev/staging/prod)

### Production
- ✅ Créer des images optimisées (< 50MB)
- ✅ Implémenter des health checks
- ✅ Gérer la persistence des données
- ✅ Configurer des networks sécurisés
- ✅ Orchestrer des applications multi-services

### DevOps
- ✅ Automatiser le déploiement avec Docker Compose
- ✅ Créer des pipelines CI/CD
- ✅ Mettre en place du monitoring
- ✅ Faire des backups automatisés
- ✅ Débugger des problèmes de containers

---

## 🎓 Certifications et Prochaines Étapes

### Après ce module Docker

1. **Kubernetes** - Orchestration à grande échelle
   - Voir: [../../../ORCHESTRATION/K8S/](../../../ORCHESTRATION/K8S/)

2. **CI/CD avec Docker**
   - Voir: [../../../CI/](../../../CI/)

3. **Docker Swarm** - Alternative à Kubernetes
   - Mode cluster Docker natif

4. **Registry privé**
   - Héberger vos propres images

### Certifications Recommandées
- 🎯 **Docker Certified Associate (DCA)**
- 🎯 **Certified Kubernetes Administrator (CKA)**
- 🎯 **AWS Certified Developer**

---

## 📖 Ressources Complémentaires

### Documentation Officielle
- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

### Pratique Interactive
- [Play with Docker](https://labs.play-with-docker.com/) - Environnement Docker dans le navigateur
- [Katacoda Docker Scenarios](https://www.katacoda.com/courses/docker)

### Livres Recommandés
- "Docker Deep Dive" - Nigel Poulton
- "Docker in Action" - Jeff Nickoloff
- "Docker: Up & Running" - Karl Matthias & Sean Kane

### Communautés
- [Docker Community Forums](https://forums.docker. com/)
- [Stack Overflow - Docker Tag](https://stackoverflow.com/questions/tagged/docker)
- [Reddit r/docker](https://www.reddit.com/r/docker/)

---

## 🏆 Conseils pour Réussir

### Pour les Débutants
1. **Ne sautez pas d'exercice** - Chaque exercice construit sur le précédent
2. **Pratiquez chaque commande** - Tapez les commandes vous-même
3. **Lisez les erreurs** - Les messages d'erreur Docker sont informatifs
4. **Utilisez `docker --help`** - Documentation intégrée très utile

### Pour les Intermédiaires
1. **Expérimentez** - Modifiez les exemples donnés
2. **Créez vos propres projets** - Containerisez vos applications existantes
3. **Comprenez le "pourquoi"** - Pas seulement le "comment"
4. **Optimisez** - Challengez-vous à réduire la taille des images

### Pour les Avancés
1. **Production-first mindset** - Pensez sécurité et performance
2. **Automatisez** - Scripts, CI/CD, monitoring
3. **Contribuez** - Partagez vos Dockerfiles et configurations
4. **Apprenez Kubernetes** - Prochaine étape naturelle

---

## 💡 Troubleshooting Général

### Problèmes Courants

<details>
<summary><strong>Docker daemon not running</strong></summary>

```bash
# macOS/Windows: Lancer Docker Desktop
# Linux:
sudo systemctl start docker
sudo systemctl enable docker
```
</details>

<details>
<summary><strong>Permission denied (Linux)</strong></summary>

```bash
sudo usermod -aG docker $USER
newgrp docker
```
</details>

<details>
<summary><strong>Port already in use</strong></summary>

```bash
# Trouver processus
sudo lsof -i :8080
# Utiliser un autre port
docker run -p 8081:80 nginx
```
</details>

<details>
<summary><strong>Out of disk space</strong></summary>

```bash
# Nettoyer
docker system prune -a --volumes
docker volume prune
docker image prune -a
```
</details>

---

## 🎉 Félicitations!

En complétant tous ces exercices, vous aurez acquis des compétences Docker de niveau **production-ready**.

Bon apprentissage! 🐳

---

**Prochaine étape:** [Kubernetes - Orchestration](../../../ORCHESTRATION/K8S/README.md) 🚀
