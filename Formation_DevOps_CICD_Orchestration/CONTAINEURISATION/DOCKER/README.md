# 🐳 DOCKER - Containerisation

## 🎯 Pourquoi Docker ?

Docker résout le problème du "Ça marche sur ma machine" :
- ✅ **Portabilité** : Même environnement partout (dev/staging/prod)
- ✅ **Isolation** : Chaque app dans son container
- ✅ **Rapidité** : Démarrage en secondes vs minutes pour les VMs
- ✅ **Efficacité** : Partage du noyau OS (plus léger que VMs)
- ✅ **Reproductibilité** : Infrastructure as Code

---

## 📚 Parcours d'Apprentissage (2 semaines)

### Semaine 1 : Docker Basics

#### Jour 1-2 : Concepts Fondamentaux
**À comprendre :**
- Container vs VM
- Image vs Container
- Docker Engine
- Registry (Docker Hub)

**Exercices :**
- [01: Installation Docker](./exercices/01-installation)
- [02: Premiers Containers](./exercices/02-premiers-containers)
- [03: Docker CLI](./exercices/03-docker-cli)

#### Jour 3-4 : Dockerfile
**À maîtriser :**
- Instructions Dockerfile (FROM, RUN, COPY, CMD)
- Layers et cache
- Build context
- Tags et versioning

**Exercices :**
- [04: Premier Dockerfile](./exercices/04-dockerfile)
- [05: Application Node.js](./exercices/05-nodejs-app)
- [06: Multi-language Apps](./exercices/06-multi-language)

#### Jour 5-7 : Volumes et Networks
**À comprendre :**
- Volumes (persistence)
- Networks (communication inter-containers)
- Port mapping

**Exercices :**
- [07: Volumes](./exercices/07-volumes)
- [08: Networks](./exercices/08-networks)
- [09: App + Database](./exercices/09-app-database)

### Semaine 2 : Docker Avancé

#### Jour 8-10 : Docker Compose
**Stack multi-containers :**
- docker-compose.yml
- Services, networks, volumes
- Environment variables
- Scaling

**Exercices :**
- [10: Premier Compose](./exercices/10-compose-intro)
- [11: Stack LAMP](./exercices/11-stack-lamp)
- [12: Microservices](./exercices/12-microservices)

#### Jour 11-12 : Optimisation
**Best practices :**
- Multi-stage builds
- Réduction taille images
- Sécurité
- Health checks

**Exercices :**
- [13: Multi-stage Build](./exercices/13-multistage)
- [14: Optimisation Images](./exercices/14-optimization)

#### Jour 13-14 : Production
**Concepts production :**
- Logging
- Monitoring
- Secrets management
- CI/CD integration

**Exercices :**
- [15: Logging](./exercices/15-logging)
- [16: Health Checks](./exercices/16-healthchecks)
- [Projet Final: App Production-Ready](./projet-final)

---

## 🛠️ Commandes Essentielles

### Images
```bash
# Lister les images
docker images

# Télécharger une image
docker pull nginx:latest

# Build une image
docker build -t mon-app:1.0 .

# Tag une image
docker tag mon-app:1.0 monuser/mon-app:1.0

# Push vers registry
docker push monuser/mon-app:1.0

# Supprimer une image
docker rmi nginx:latest

# Nettoyer les images non utilisées
docker image prune -a
```

### Containers
```bash
# Lister containers actifs
docker ps

# Lister tous les containers
docker ps -a

# Lancer un container
docker run nginx

# Container en background
docker run -d --name webserver nginx

# Container interactif
docker run -it ubuntu bash

# Port mapping
docker run -d -p 8080:80 nginx

# Variables d'environnement
docker run -e NODE_ENV=production mon-app

# Volumes
docker run -v /host/path:/container/path nginx

# Arrêter un container
docker stop webserver

# Démarrer un container arrêté
docker start webserver

# Supprimer un container
docker rm webserver

# Voir les logs
docker logs webserver
docker logs -f webserver  # Follow (temps réel)

# Exécuter une commande dans un container
docker exec -it webserver bash

# Inspecter un container
docker inspect webserver

# Stats en temps réel
docker stats
```

### Docker Compose
```bash
# Démarrer les services
docker-compose up

# Background
docker-compose up -d

# Reconstruire les images
docker-compose up --build

# Voir les logs
docker-compose logs
docker-compose logs -f service-name

# Arrêter les services
docker-compose down

# Arrêter + supprimer volumes
docker-compose down -v

# Lister les services
docker-compose ps

# Exécuter une commande
docker-compose exec web bash

# Scaling
docker-compose up -d --scale web=3
```

### Nettoyage
```bash
# Tout nettoyer (prudence!)
docker system prune -a

# Volumes non utilisés
docker volume prune

# Networks non utilisés
docker network prune
```

---

## 📖 Dockerfile - Guide Complet

### Structure de Base
```dockerfile
# Image de base
FROM node:18-alpine

# Métadonnées
LABEL maintainer="votre@email.com"
LABEL version="1.0"

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci --only=production

# Copier le code source
COPY . .

# Exposer le port
EXPOSE 3000

# Définir l'utilisateur (sécurité)
USER node

# Commande de démarrage
CMD ["node", "server.js"]
```

### Instructions Principales

| Instruction | Usage | Exemple |
|-------------|-------|---------|
| `FROM` | Image de base | `FROM ubuntu:22.04` |
| `RUN` | Exécuter commande (build-time) | `RUN apt-get update` |
| `COPY` | Copier fichiers | `COPY . /app` |
| `ADD` | Copier + extraction archives | `ADD archive.tar.gz /app` |
| `WORKDIR` | Définir répertoire de travail | `WORKDIR /app` |
| `ENV` | Variable d'environnement | `ENV NODE_ENV=production` |
| `EXPOSE` | Port à exposer | `EXPOSE 8080` |
| `CMD` | Commande par défaut | `CMD ["npm", "start"]` |
| `ENTRYPOINT` | Point d'entrée | `ENTRYPOINT ["python"]` |
| `VOLUME` | Point de montage | `VOLUME /data` |
| `USER` | Utilisateur d'exécution | `USER appuser` |
| `ARG` | Argument de build | `ARG VERSION=1.0` |

### Multi-Stage Build (Optimisation)
```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

**Avantage :** Image finale ne contient QUE le nécessaire (pas les outils de build)

---

## 🐋 Docker Compose - Guide Complet

### Exemple Complet : App Web + DB + Cache
```yaml
version: '3.8'

services:
  # Frontend
  web:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - API_URL=http://api:4000
      - NODE_ENV=production
    depends_on:
      - api
    networks:
      - frontend
    restart: unless-stopped

  # Backend API
  api:
    build: ./backend
    ports:
      - "4000:4000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://cache:6379
    depends_on:
      - db
      - cache
    networks:
      - frontend
      - backend
    volumes:
      - ./backend/uploads:/app/uploads
    restart: unless-stopped

  # Base de données
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Cache Redis
  cache:
    image: redis:7-alpine
    networks:
      - backend
    restart: unless-stopped

# Volumes persistants
volumes:
  pgdata:
    driver: local

# Networks
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```

---

## 🎯 Best Practices

### 1. Dockerfile Optimization

❌ **Mauvais**
```dockerfile
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y pip
COPY . /app
CMD python3 /app/server.py
```

✅ **Bon**
```dockerfile
# Image de base légère + version fixe
FROM python:3.11-alpine

# Combiner les RUN (moins de layers)
RUN apk add --no-cache gcc musl-dev

# Copier requirements AVANT le code (cache)
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code
COPY . .

# Non-root user (sécurité)
RUN adduser -D appuser
USER appuser

# Commande explicite
CMD ["python", "server.py"]
```

### 2. .dockerignore
```
# Dépendances (installées dans l'image)
node_modules/
venv/
__pycache__/

# Fichiers de développement
.git/
.gitignore
.env
.env.local

# Documentation
README.md
docs/

# Tests
tests/
*.test.js

# CI/CD
.github/
.gitlab-ci.yml
```

### 3. Sécurité

✅ **Checklist Sécurité**
- [ ] Utiliser des images officielles
- [ ] Fixer les versions (`node:18` pas `node:latest`)
- [ ] Scanner les vulnérabilités (`docker scan`)
- [ ] Ne jamais commiter de secrets
- [ ] Utiliser des users non-root
- [ ] Limiter les capacités (capabilities)

```dockerfile
# User non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Read-only filesystem
docker run --read-only mon-app

# Limiter les ressources
docker run --memory="512m" --cpus="0.5" mon-app
```

---

## 📊 Container vs VM

```
┌──────────────────────────────────┐
│         Virtual Machines         │
├──────────────────────────────────┤
│  App A  │  App B  │  App C       │
│  Bins   │  Bins   │  Bins        │
│  Guest  │  Guest  │  Guest       │
│  OS     │  OS     │  OS          │
├──────────────────────────────────┤
│      Hypervisor (VMware/KVM)     │
├──────────────────────────────────┤
│         Host OS                  │
├──────────────────────────────────┤
│         Hardware                 │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│           Containers             │
├──────────────────────────────────┤
│  App A  │  App B  │  App C       │
│  Bins   │  Bins   │  Bins        │
├──────────────────────────────────┤
│       Docker Engine              │
├──────────────────────────────────┤
│         Host OS                  │
├──────────────────────────────────┤
│         Hardware                 │
└──────────────────────────────────┘
```

**Avantages Containers :**
- Plus léger (pas d'OS invité complet)
- Démarrage en secondes
- Meilleure densité (plus de containers sur même machine)

---

## 🚀 Cas d'Usage Réels

### 1. Environnement de Développement
```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - .:/app  # Hot reload
      - /app/node_modules  # Exclude
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    command: npm run dev
```

### 2. Tests Automatisés
```bash
# CI/CD pipeline
docker build -t app:test .
docker run app:test npm test
```

### 3. Microservices
```yaml
services:
  auth-service:
    build: ./services/auth
  user-service:
    build: ./services/user
  order-service:
    build: ./services/order
  gateway:
    image: nginx
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

---

## ✅ Auto-Évaluation

### Niveau Débutant
- [ ] Je comprends container vs VM
- [ ] Je lance des containers simples
- [ ] Je crée un Dockerfile basique
- [ ] J'utilise volumes pour les données

### Niveau Intermédiaire
- [ ] Je crée des images optimisées
- [ ] J'utilise Docker Compose
- [ ] Je configure networks
- [ ] Je debug les containers

### Niveau Avancé
- [ ] Multi-stage builds expert
- [ ] Sécurisation des images
- [ ] Orchestration (swarm/k8s)
- [ ] CI/CD avec Docker

---

**Prochaine étape :** [Kubernetes](../../ORCHESTRATION/K8S/README.md) 🚀

---

*"Docker is not magic, it's just Linux"*
