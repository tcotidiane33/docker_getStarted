# 🎓 Concepts Pédagogiques Docker

## 🎯 Comprendre le "Pourquoi" Avant le "Comment"

### Pourquoi Docker Existe-t-il ?

**Le Problème Classique : "Ça marche sur ma machine"**

```
Développeur (Mac)    Serveur Test (Ubuntu)    Production (RedHat)
     │                      │                       │
Python 3.9              Python 3.7              Python 3.8
NodeJS 16               NodeJS 14               NodeJS 18
MySQL 8.0               MySQL 5.7               PostgreSQL 13
     │                      │                       │
     ✅ Ça marche           ❌ Erreur               ❌ Crash
```

**Solution : Docker**
```
┌──────────────────────────────────────┐
│  Container (environnement identique) │
│  ├─ Python 3.9                       │
│  ├─ NodeJS 16                        │
│  └─ MySQL 8.0                        │
└──────────────────────────────────────┘
        │          │          │
     Dev Mac    Test       Production
        ✅         ✅          ✅
   Identique  Identique   Identique
```

---

## 📚 Concept 1 : Container vs Virtual Machine

### Qu'est-ce qu'un Container ?

**Analogie :** Un container est comme un **appartement dans un immeuble**

```
┌─────────────────────────────────────┐
│         Immeuble (Serveur)          │
├─────────────────────────────────────┤
│ Appart 1  │ Appart 2  │ Appart 3  │
│ (App A)   │ (App B)   │ (App C)   │
├───────────┼───────────┼───────────┤
│      Infrastructure Partagée       │
│      (Plomberie, Électricité)      │
│         = OS Kernel                │
└─────────────────────────────────────┘

Chaque appartement :
✅ Isolé des autres
✅ Partage les ressources communes
✅ Léger (pas besoin de tout dupliquer)
```

### Container vs VM : La Différence

```
┌──────────── VIRTUAL MACHINES ────────────┐
│  VM 1        │  VM 2        │  VM 3      │
│  ─────       │  ─────       │  ─────     │
│  App A       │  App B       │  App C     │
│  Libs        │  Libs        │  Libs      │
│  ────────    │  ────────    │  ────────  │
│  Guest OS    │  Guest OS    │  Guest OS  │
│  (Linux)     │  (Linux)     │ (Windows)  │
│  ────────────────────────────────────────│
│         Hypervisor (VMware/VirtualBox)   │
│  ────────────────────────────────────────│
│              Host OS                     │
│  ────────────────────────────────────────│
│              Hardware                    │
└──────────────────────────────────────────┘

Poids : 5-10 GB par VM
Démarrage : 1-2 minutes
```

```
┌──────────── CONTAINERS ──────────────────┐
│  Container 1 │  Container 2 │ Container 3│
│  ─────       │  ─────       │  ─────     │
│  App A       │  App B       │  App C     │
│  Libs        │  Libs        │  Libs      │
│  ────────────────────────────────────────│
│         Docker Engine                    │
│  ────────────────────────────────────────│
│              Host OS                     │
│  ────────────────────────────────────────│
│              Hardware                    │
└──────────────────────────────────────────┘

Poids : 50-500 MB par container
Démarrage : 1-5 secondes
```

**Différences clés :**

| Aspect | VM | Container |
|--------|-----|-----------|
| **OS** | OS complet par VM | Partage OS hôte |
| **Taille** | Go (gigaoctets) | Mo (mégaoctets) |
| **Démarrage** | Minutes | Secondes |
| **Isolation** | Forte (hypervisor) | Processus Linux |
| **Performance** | Overhead | Native |

---

## 📚 Concept 2 : Image vs Container

### Qu'est-ce qu'une Image ?

**Analogie :** Une image est comme un **moule à gâteaux** ou **une recette**

```
Dockerfile (Recette)
    ↓ build
Docker Image (Moule)
    ↓ run
Container 1 (Gâteau 1)
Container 2 (Gâteau 2)  ← Identiques
Container 3 (Gâteau 3)
```

### Image : Structure en Couches (Layers)

```
┌────────────────────────────────┐
│  Layer 5: COPY app.js          │ +200 KB
├────────────────────────────────┤
│  Layer 4: RUN npm install      │ +50 MB
├────────────────────────────────┤
│  Layer 3: COPY package.json    │ +1 KB
├────────────────────────────────┤
│  Layer 2: RUN apt-get update   │ +100 MB
├────────────────────────────────┤
│  Layer 1: FROM ubuntu:22.04    │ 80 MB
└────────────────────────────────┘

Chaque layer = read-only
Container = Couche writable au-dessus
```

**Avantage des layers :**
```
Image A:                    Image B:
ubuntu:22.04 (80 MB)        ubuntu:22.04 (80 MB) ← PARTAGÉ!
+ Python (50 MB)            + Node.js (60 MB)

Espace total: 190 MB (pas 270 MB)
```

### Image vs Container : Clarification

```
IMAGE                      CONTAINER
─────                      ─────────
Read-only                  Read + Write
Template                   Instance en cours d'exécution
Stockée sur disque         Processus actif en mémoire
1 image                    → N containers

Exemple:
ubuntu:22.04 (image)
    ├─ container_web_1 (running)
    ├─ container_web_2 (running)
    └─ container_api_1 (running)
```

---

## 📚 Concept 3 : Dockerfile (Recette de Construction)

### Qu'est-ce qu'un Dockerfile ?

**Analogie :** Un Dockerfile est une **recette de cuisine** pour créer une image

```
Recette Gâteau              Dockerfile
──────────────              ──────────
1. Préchauffer four         FROM ubuntu:22.04
2. Mélanger farine          RUN apt-get update
3. Ajouter œufs             COPY app.js /app/
4. Cuire 30min              CMD ["node", "app.js"]
```

### Anatomie d'un Dockerfile

```dockerfile
# Étape 1: Image de base (fondation)
FROM node:18-alpine

# Étape 2: Métadonnées (optionnel)
LABEL maintainer="dev@example.com"
LABEL version="1.0"

# Étape 3: Variables d'environnement
ENV NODE_ENV=production
ENV PORT=3000

# Étape 4: Répertoire de travail
WORKDIR /app

# Étape 5: Copier dépendances
COPY package*.json ./

# Étape 6: Installer dépendances
RUN npm ci --only=production

# Étape 7: Copier code source
COPY . .

# Étape 8: Exposer port
EXPOSE 3000

# Étape 9: Commande de démarrage
CMD ["node", "server.js"]
```

### Instructions Dockerfile : Détails

#### FROM : Image de Base
```dockerfile
FROM ubuntu:22.04           # OS complet
FROM node:18-alpine         # Node.js pré-installé (recommandé)
FROM python:3.11-slim       # Python optimisé
```

**Choix de l'image :**
- `alpine` : Ultra-léger (~5 MB)
- `slim` : Léger (~50 MB)
- `regular` : Complet (~200 MB)

#### RUN : Exécuter des Commandes (Build-time)
```dockerfile
# Installer packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim

# Créer utilisateur
RUN useradd -m appuser

# Multiple commandes (best practice)
RUN apt-get update \
    && apt-get install -y package \
    && rm -rf /var/lib/apt/lists/*  # Nettoyage
```

#### COPY vs ADD
```dockerfile
# COPY : Simple copie (recommandé)
COPY file.txt /app/
COPY src/ /app/src/

# ADD : Copie + extraction archives
ADD archive.tar.gz /app/  # Extrait automatiquement
ADD http://example.com/file.zip /tmp/  # Télécharge
```

**Best practice :** Utiliser `COPY` sauf besoin spécifique

#### CMD vs ENTRYPOINT

**CMD :** Commande par défaut (peut être écrasée)
```dockerfile
CMD ["node", "server.js"]

# Lancement:
docker run mon-image               # Exécute: node server.js
docker run mon-image python app.py # Exécute: python app.py ← Override
```

**ENTRYPOINT :** Point d'entrée fixe
```dockerfile
ENTRYPOINT ["node"]
CMD ["server.js"]

# Lancement:
docker run mon-image           # Exécute: node server.js
docker run mon-image app.js    # Exécute: node app.js
```

---

## 📚 Concept 4 : Volumes (Persistence de Données)

### Le Problème sans Volumes

```
Container démarré
    ↓
Création de données (database.db)
    ↓
Container arrêté
    ↓
❌ Données perdues !
```

### Solution : Volumes

**Analogie :** Un volume est comme un **disque dur externe branché au container**

```
┌────────────────────┐
│    Container       │
│    /app/data/ ────┼──→ Volume (sur disque hôte)
│                    │      /var/lib/docker/volumes/
└────────────────────┘

Container détruit → Volume persiste
Nouveau container → Même volume
```

### Types de Volumes

#### 1. Named Volumes (Recommandé)
```bash
# Créer volume
docker volume create pgdata

# Utiliser
docker run -v pgdata:/var/lib/postgresql/data postgres

# Avantages:
✅ Géré par Docker
✅ Facile à backup
✅ Portable
```

#### 2. Bind Mounts (Dev)
```bash
# Monter dossier local
docker run -v /Users/me/code:/app node

# Use case:
- Développement (hot reload)
- Configuration files
```

#### 3. tmpfs (Temporaire en RAM)
```bash
docker run --tmpfs /tmp myapp

# Use case:
- Données sensibles éphémères
- Performance (en mémoire)
```

---

## 📚 Concept 5 : Networks (Communication)

### Le Problème : Isolation

```
Container A (web)      Container B (db)
     ❌─────────────────❌
   Isolés par défaut
```

### Solution : Docker Networks

**Analogie :** Un network est comme un **réseau Wi-Fi privé pour containers**

```
┌─────────────────────────────────┐
│      Docker Network "app-net"   │
│                                 │
│  ┌──────────┐   ┌──────────┐  │
│  │ web      │   │ api      │  │
│  │ :80      │──▶│ :3000    │  │
│  └──────────┘   └──────────┘  │
│                      │          │
│                      ▼          │
│                 ┌──────────┐   │
│                 │ database │   │
│                 │ :5432    │   │
│                 └──────────┘   │
└─────────────────────────────────┘

Communication par nom: http://api:3000
```

### Types de Networks

| Type | Usage | Isolation |
|------|-------|-----------|
| **bridge** | Défaut, containers locaux | Moyenne |
| **host** | Performance max | Aucune |
| **overlay** | Swarm (multi-host) | Haute |
| **none** | Pas de réseau | Totale |

### DNS Automatique

```
Network créé → Containers sur ce network

Container "web" peut joindre:
- Container "api" via: http://api:3000
- Container "db" via: postgresql://db:5432

✅ Pas besoin d'IP !
```

---

## 📚 Concept 6 : Docker Compose (Orchestration Multi-Containers)

### Le Problème

```bash
# Sans Compose: 10 commandes manuelles
docker network create app-net
docker volume create db-data
docker run --name db --network app-net -v db-data:/data postgres
docker run --name api --network app-net my-api
docker run --name web --network app-net -p 80:80 my-web
# ... etc
```

### Solution : Docker Compose

**Analogie :** Docker Compose est comme une **playlist**

```
Playlist (docker-compose.yml)
├─ Chanson 1 (service db)
├─ Chanson 2 (service api)
└─ Chanson 3 (service web)

Commande: docker-compose up
→ Lance TOUTES les chansons ensemble
```

### Structure docker-compose.yml

```yaml
version: '3.8'

services:
  # Service 1: Database
  db:
    image: postgres:15
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: secret
  
  # Service 2: Backend API
  api:
    build: ./backend
    depends_on:
      - db
    environment:
      DATABASE_URL: postgresql://db:5432/myapp
  
  # Service 3: Frontend
  web:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - api

volumes:
  db-data:

networks:
  default:
    driver: bridge
```

**Une seule commande :**
```bash
docker-compose up
# → Crée network
# → Crée volumes
# → Lance db
# → Lance api (attend db)
# → Lance web (attend api)
```

---

## 📚 Concept 7 : Multi-Stage Builds (Optimisation)

### Le Problème : Images Lourdes

```dockerfile
# ❌ MAUVAIS: Image finale = 1.5 GB
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install      # Dépendances dev + prod
COPY . .
RUN npm run build    # Outils de build inclus dans image finale
CMD ["node", "dist/server.js"]

Image finale contient:
├─ Node.js
├─ npm
├─ Tous les dev dependencies
├─ Code source TypeScript
└─ Code compilé JavaScript
```

### Solution : Multi-Stage Build

```dockerfile
# ✅ BON: Image finale = 150 MB
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
CMD ["node", "dist/server.js"]

Image finale contient UNIQUEMENT:
├─ Node.js (alpine)
├─ node_modules production
└─ Code compilé
```

**Réduction : 1.5 GB → 150 MB (10x plus léger)**

---

## 📚 Concept 8 : Registry (Distribution)

### Qu'est-ce qu'un Registry ?

**Analogie :** Un registry est comme un **App Store pour images Docker**

```
┌────────────────────────────────┐
│       Docker Hub (Registry)    │
│                                │
│  ubuntu:22.04                  │
│  nginx:latest                  │
│  postgres:15                   │
│  monuser/mon-app:1.0           │
└────────────────────────────────┘
         ↕ push/pull
┌────────────────────────────────┐
│   Votre Ordinateur             │
│   Images locales               │
└────────────────────────────────┘
```

### Workflow Registry

```bash
# 1. Créer image
docker build -t monuser/mon-app:1.0 .

# 2. Login au registry
docker login

# 3. Push
docker push monuser/mon-app:1.0

# 4. Quelqu'un d'autre peut pull
docker pull monuser/mon-app:1.0
```

### Registries Populaires

| Registry | Usage | Coût |
|----------|-------|------|
| **Docker Hub** | Public par défaut | Gratuit (limité) |
| **GitHub Container Registry** | Intégration GitHub | Gratuit |
| **AWS ECR** | Production AWS | Payant |
| **Google GCR** | Production GCP | Payant |
| **Harbor** | Self-hosted | Gratuit (open source) |

---

## 💡 Principes Fondamentaux Docker

### 1. Immutabilité

**Principe :** Les containers sont éphémères, les images sont immutables

```
❌ MAUVAIS:
docker exec mon-container apt-get install vim
→ Changement perdu au redémarrage

✅ BON:
Modifier Dockerfile → Rebuild image → Nouveau container
```

### 2. Un Processus par Container

**Principe :** Container = 1 processus principal

```
❌ MAUVAIS: Container "tout-en-un"
Container:
├─ Nginx
├─ PHP-FPM
├─ MySQL
└─ Redis

✅ BON: Containers séparés
Container web: Nginx
Container app: PHP-FPM
Container db: MySQL
Container cache: Redis
```

### 3. Configuration via Variables d'Environnement

```dockerfile
# Dans Dockerfile
ENV DATABASE_URL=postgresql://localhost/db

# Override au runtime
docker run -e DATABASE_URL=postgresql://prod-db/myapp mon-app
```

### 4. Pas de Données dans le Container

```
✅ Volumes pour données
✅ Secrets via Docker Secrets ou env vars
❌ Jamais hardcoder dans image
```

---

## 🎯 Cas d'Usage Réels

### Cas 1 : Environnement de Développement Identique

```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - .:/app  # Hot reload
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development

# Toute l'équipe:
git clone repo
docker-compose up
→ Environnement identique pour tous
```

### Cas 2 : Microservices

```
┌─────────────────────────────────┐
│  auth-service (Node.js)         │
├─────────────────────────────────┤
│  user-service (Python)          │
├─────────────────────────────────┤
│  order-service (Go)             │
├─────────────────────────────────┤
│  notification-service (Rust)    │
└─────────────────────────────────┘

Chaque service:
- Son propre container
- Son propre langage
- Déploiement indépendant
```

### Cas 3 : CI/CD Testing

```yaml
# .github/workflows/test.yml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build image
        run: docker build -t app:test .
      - name: Run tests
        run: docker run app:test npm test
```

---

## ✅ Checklist Maîtrise Docker

### Niveau Débutant
- [ ] Je comprends image vs container
- [ ] Je lance des containers simples
- [ ] Je crée un Dockerfile basique
- [ ] J'utilise docker run, stop, rm

### Niveau Intermédiaire
- [ ] Je crée des images optimisées
- [ ] J'utilise volumes et networks
- [ ] Je compose avec docker-compose
- [ ] Je publie sur Docker Hub

### Niveau Avancé
- [ ] Multi-stage builds expert
- [ ] Optimisation taille et sécurité
- [ ] Debugging containers
- [ ] Production-ready images

---

**Prochaine étape :** [Parcours Pédagogique](./PARCOURS-PEDAGOGIQUE.md)
