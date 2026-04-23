# Exercice 09 : Multi-Stage Builds - Optimisation des Images

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer des Dockerfiles multi-stage
- ✅ Optimiser la taille des images (réduction jusqu'à 90%)
- ✅ Séparer les dépendances build des dépendances runtime
- ✅ Créer des images production-ready
- ✅ Utiliser des builders pour différents environnements

## ⏱️ Durée Estimée
**1 heure 30 minutes**

## 📋 Prérequis
- [Exercice 08 : Docker Compose](../08-docker-compose/README.md) complété

---

## 📚 Partie 1 : Problème - Image Non-Optimisée

```bash
mkdir -p ~/docker-exercices/multistage
cd ~/docker-exercices/multistage

# Application Go simple
cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from optimized Go app!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server starting on :8080...")
    http.ListenAndServe(":8080", nil)
}
EOF

# Dockerfile NON-OPTIMISÉ
cat > Dockerfile.bad << 'EOF'
FROM golang:1.21

WORKDIR /app

COPY main.go .

RUN go build -o server main.go

EXPOSE 8080

CMD ["./server"]
EOF

# Build
docker build -f Dockerfile.bad -t go-app:bad .

# Vérifier la taille
docker images go-app:bad
# Taille: ~800MB! 😱
```

---

## 📚 Partie 2 : Solution - Multi-Stage Build

```dockerfile
cat > Dockerfile << 'EOF'
# ====================
# Stage 1: Builder
# ====================
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copier le code source
COPY main.go .

# Build l'application
RUN go build -o server main.go

# ====================
# Stage 2: Production
# ====================
FROM alpine:3.18

WORKDIR /app

# Copier SEULEMENT l'exécutable depuis le builder
COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
EOF

# Build optimisé
docker build -t go-app:optimized .

# Comparer les tailles
docker images | grep go-app

# Résultat:
# go-app:bad        ~800MB
# go-app:optimized  ~15MB  ← 98% de réduction! 🎉

# Tester
docker run -d -p 8080:8080 --name go-optimized go-app:optimized
curl http://localhost:8080
docker stop go-optimized && docker rm go-optimized
```

**💡 Pourquoi c'est mieux ?**
- Stage 1 (builder): Contient Go compiler + outils → jamais inclus dans l'image finale
- Stage 2 (production): Seulement alpine + exécutable → image ultra-légère

---

## 📚 Partie 3 : Node.js Multi-Stage

```bash
mkdir -p ~/docker-exercices/multistage-node
cd ~/docker-exercices/multistage-node

cat > package.json << 'EOF'
{
  "name": "node-multistage",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "build": "echo 'Building...'",
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "eslint": "^8.0.0"
  }
}
EOF

cat > server.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Multi-stage Node.js app', optimized: true });
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});
EOF

cat > Dockerfile << 'EOF'
# ====================
# Stage 1: Dependencies
# ====================
FROM node:18-alpine AS dependencies

WORKDIR /app

# Installer TOUTES les dépendances (prod + dev)
COPY package*.json ./
RUN npm ci

# ====================
# Stage 2: Builder (si build needed)
# ====================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

# Build step (TypeScript, webpack, etc.)
RUN npm run build

# ====================
# Stage 3: Production
# ====================
FROM node:18-alpine AS production

# Installer dumb-init
RUN apk add --no-cache dumb-init

# User non-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copier SEULEMENT les node_modules de production
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copier le code source
COPY --chown=nodejs:nodejs server.js .

USER nodejs

ENV NODE_ENV=production

EXPOSE 3000

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
EOF

# Build
docker build -t node-app:multistage .

# Comparer avec build simple
cat > Dockerfile.simple << 'EOF'
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
EOF

docker build -f Dockerfile.simple -t node-app:simple .

# Comparer
docker images | grep node-app

# Tester
docker run -d -p 3000:3000 --name node-multi node-app:multistage
curl http://localhost:3000
docker stop node-multi && docker rm node-multi
```

---

## 📚 Partie 4 : Python Multi-Stage

```bash
mkdir -p ~/docker-exercices/multistage-python
cd ~/docker-exercices/multistage-python

cat > requirements.txt << 'EOF'
Flask==3.0.0
gunicorn==21.2.0
pandas==2.1.3
numpy==1.26.2
EOF

cat > app.py << 'EOF'
from flask import Flask, jsonify
import pandas as pd

app = Flask(__name__)

@app.route('/')
def index():
    df = pd.DataFrame({'data': [1, 2, 3]})
    return jsonify({
        'message': 'Multi-stage Python app',
        'data_sum': int(df['data'].sum())
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

cat > Dockerfile << 'EOF'
# ====================
# Stage 1: Builder
# ====================
FROM python:3.11-slim AS builder

WORKDIR /app

# Installer compilateurs pour wheels
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Copier dependencies
COPY requirements.txt .

# Créer un virtualenv et installer
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# ====================
# Stage 2: Production
# ====================
FROM python:3.11-slim AS production

# User non-root
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Copier le virtualenv depuis builder
COPY --from=builder /opt/venv /opt/venv

# Copier le code
COPY app.py .

# Changer ownership
RUN chown -R appuser:appuser /app

USER appuser

ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
EOF

docker build -t python-app:multistage .

# Tester
docker run -d -p 5000:5000 --name python-multi python-app:multistage
curl http://localhost:5000
docker stop python-multi && docker rm python-multi
```

---

## 📚 Partie 5 : React Multi-Stage (Frontend)

```bash
mkdir -p ~/docker-exercices/multistage-react
cd ~/docker-exercices/multistage-react

cat > package.json << 'EOF'
{
  "name": "react-app",
  "version": "1.0.0",
  "scripts": {
    "build": "echo 'Building React app...'"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
EOF

# Simuler un build React
mkdir -p build
cat > build/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>React App</title></head>
<body>
  <div id="root">
    <h1>🚀 React Multi-Stage Build</h1>
    <p>Built with optimization!</p>
  </div>
</body>
</html>
EOF

cat > Dockerfile << 'EOF'
# ====================
# Stage 1: Build
# ====================
FROM node:18-alpine AS build

WORKDIR /app

# Installer dependencies
COPY package*.json ./
RUN npm ci

# Build l'app
COPY . .
RUN npm run build
# En vrai: npm run build créerait le dossier build/

# ====================
# Stage 2: Production avec Nginx
# ====================
FROM nginx:alpine AS production

# Copier la config nginx custom (optionnel)
# COPY nginx.conf /etc/nginx/nginx.conf

# Copier SEULEMENT les fichiers buildés
COPY --from=build /app/build /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

docker build -t react-app:multistage .

# Image finale: ~25MB
# Sans multi-stage: ~1GB+

# Tester
docker run -d -p 8080:80 --name react-app react-app:multistage
curl http://localhost:8080
docker stop react-app && docker rm react-app
```

---

## 📚 Partie 6 : Techniques Avancées

### 6.1 Named Stages et Targets

```dockerfile
# Build seulement un stage spécifique
cat > Dockerfile.targets << 'EOF'
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

FROM base AS development
RUN npm install
COPY . .
CMD ["npm", "run", "dev"]

FROM base AS production
RUN npm ci --only=production
COPY . .
CMD ["node", "server.js"]

FROM base AS test
RUN npm ci
COPY . .
CMD ["npm", "test"]
EOF

# Build pour dev
docker build --target development -t app:dev -f Dockerfile.targets .

# Build pour prod
docker build --target production -t app:prod -f Dockerfile.targets .

# Build pour tests
docker build --target test -t app:test -f Dockerfile.targets .
```

### 6.2 Copier depuis des Images Externes

```dockerfile
# Copier depuis une image Docker Hub
FROM scratch

COPY --from=nginx:alpine /etc/nginx/nginx.conf /nginx.conf
COPY --from=busybox:latest /bin/busybox /bin/busybox
```

### 6.3 Build Arguments dans Multi-Stage

```dockerfile
cat > Dockerfile.args << 'EOF'
ARG NODE_VERSION=18

FROM node:${NODE_VERSION}-alpine AS builder

ARG BUILD_ENV=production
ENV NODE_ENV=${BUILD_ENV}

WORKDIR /app
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EOF

# Build avec arguments
docker build \
  --build-arg NODE_VERSION=20 \
  --build-arg BUILD_ENV=staging \
  -t app:custom \
  -f Dockerfile.args .
```

---

## ✅ Exercice de Validation

Créez une application full-stack optimisée:

**Contraintes:**
- Frontend React avec multi-stage
- Backend Node.js avec multi-stage
- Image finale < 50MB pour chaque service

<details>
<summary>Solution</summary>

```dockerfile
# Frontend
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
# Taille: ~25MB

# Backend
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
RUN addgroup -g 1001 nodejs && adduser -S nodejs -u 1001
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY server.js .
USER nodejs
CMD ["node", "server.js"]
# Taille: ~40MB
```
</details>

---

## 🎯 Défis Avancés

### Défi 1 : Distroless Image

```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 go build -o app

FROM gcr.io/distroless/static-debian11
COPY --from=builder /app/app /app
CMD ["/app"]
# Taille: ~5MB!
```

### Défi 2 : Scratch Image

```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-s -w' -o app

FROM scratch
COPY --from=builder /app/app /app
EXPOSE 8080
ENTRYPOINT ["/app"]
# Taille: ~2MB!
```

### Défi 3 : Cache Optimization

```dockerfile
# Mauvais: invalidation du cache à chaque changement
COPY . .
RUN npm install

# Bon: cache préservé
COPY package*.json ./
RUN npm install
COPY . .
```

---

## 📊 Comparaison des Tailles

| Type | Sans Multi-Stage | Avec Multi-Stage | Réduction |
|------|------------------|------------------|-----------|
| Go | 800 MB | 15 MB | 98% |
| Node.js | 950 MB | 120 MB | 87% |
| Python | 1.1 GB | 180 MB | 84% |
| React | 1.2 GB | 25 MB | 98% |

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Multi-stage builds
- ✅ Réduction massive de la taille des images
- ✅ Séparation build/runtime
- ✅ Named stages et targets
- ✅ Optimisation pour la production

---

## ➡️ Prochaine Étape

[Exercice 10 : Projet Final](../10-projet-final/README.md)

---

## 📚 Ressources

- [Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
