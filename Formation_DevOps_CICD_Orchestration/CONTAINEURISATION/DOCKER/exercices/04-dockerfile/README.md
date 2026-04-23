# Exercice 04 : Premier Dockerfile

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer un Dockerfile from scratch
- ✅ Comprendre les instructions de base (FROM, RUN, COPY, CMD)
- ✅ Build une image Docker
- ✅ Optimiser le cache des layers
- ✅ Utiliser .dockerignore

## ⏱️ Durée Estimée
**1 heure 30 minutes**

## 📋 Prérequis
- [Exercice 03 : Docker CLI](../03-docker-cli/README.md) complété

---

## 📚 Partie 1 : Premier Dockerfile Simple

### Exercice 1.1 : Hello World Container

```bash
# Créer un répertoire de travail
mkdir -p ~/docker-exercices/hello-world
cd ~/docker-exercices/hello-world

# Créer un Dockerfile
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04

CMD echo "Hello from my first Dockerfile!"
EOF

# Build l'image
docker build -t my-hello .

# Tester
docker run --rm my-hello
```

**💡 Explications :**
- `FROM` : Image de base
- `CMD`: Commande exécutée au démarrage
- `.` : Build context (répertoire courant)

### Exercice 1.2 : Script Personnalisé

```bash
# Créer un script
cat > hello.sh << 'EOF'
#!/bin/bash
echo "🐳 Container started at: $(date)"
echo "🖥️  Hostname: $(hostname)"
echo "👤 User: $(whoami)"
EOF

# Dockerfile
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04

# Copier le script
COPY hello.sh /usr/local/bin/hello.sh

# Le rendre exécutable
RUN chmod +x /usr/local/bin/hello.sh

# L'exécuter au démarrage
CMD ["/usr/local/bin/hello.sh"]
EOF

# Build
docker build -t my-script .

# Run
docker run --rm my-script
```

---

## 📚 Partie 2 : Instructions Principales

### Exercice 2.1 : FROM - Image de Base

```dockerfile
# Option 1: Version spécifique (RECOMMANDÉ)
FROM ubuntu:22.04

# Option 2: Tag latest (À ÉVITER en production)
FROM ubuntu:latest

# Option 3: Image alpine (plus légère)
FROM alpine:3.18

# Option 4: Image avec langage
FROM python:3.11-slim
FROM node:18-alpine
FROM golang:1.21-alpine
```

**✅ Best Practice :** Toujours spécifier une version précise pour la reproductibilité

### Exercice 2.2 : RUN - Exécuter des Commandes

```bash
mkdir -p ~/docker-exercices/run-demo
cd ~/docker-exercices/run-demo

cat > Dockerfile << 'EOF'
FROM ubuntu:22.04

# Mauvaise pratique: plusieurs RUN
# RUN apt-get update
# RUN apt-get install -y curl
# RUN apt-get install -y wget

# Bonne pratique: combiner les RUN
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        vim \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
EOF

docker build -t tools-image .
docker run -it --rm tools-image
```

**💡 Pourquoi combiner ?**
- Moins de layers = image plus légère
- Nettoyage du cache apt dans le même layer

### Exercice 2.3 : COPY vs ADD

```bash
mkdir -p ~/docker-exercices/copy-add
cd ~/docker-exercices/copy-add

# Créer des fichiers de test
echo "Config file" > config.txt
mkdir app
echo "console.log('app');" > app/index.js

cat > Dockerfile << 'EOF'
FROM node:18-alpine

# COPY: Simple copie de fichiers
COPY config.txt /etc/config.txt

# COPY: Copier un répertoire
COPY app/ /app/

# ADD peut extraire des archives (utiliser COPY en général)
# ADD archive.tar.gz /extracted/

WORKDIR /app
CMD ["node", "index.js"]
EOF

docker build -t copy-demo .
docker run --rm copy-demo
```

### Exercice 2.4 : WORKDIR

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine

# Mauvaise pratique
# RUN cd /app
# COPY package.json ./

# Bonne pratique
WORKDIR /app
COPY package.json .
COPY . .

CMD ["npm", "start"]
EOF
```

### Exercice 2.5 : ENV - Variables d'Environnement

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine

ENV NODE_ENV=production \
    PORT=3000 \
    LOG_LEVEL=info

WORKDIR /app

CMD echo "ENV: $NODE_ENV, PORT: $PORT, LOG: $LOG_LEVEL"
EOF

docker build -t env-demo .
docker run --rm env-demo

# Override au runtime
docker run --rm -e NODE_ENV=development env-demo
```

---

## 📚 Partie 3 : Application Node.js Complète

### Exercice 3.1 : Setup du Projet

```bash
mkdir -p ~/docker-exercices/node-app
cd ~/docker-exercices/node-app

# package.json
cat > package.json << 'EOF'
{
  "name": "docker-node-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

# server.js
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Dockerized Node.js!',
    environment: process.env.NODE_ENV,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
EOF
```

### Exercice 3.2 : Dockerfile Non-Optimisé

```dockerfile
cat > Dockerfile.bad << 'EOF'
FROM node:18

# Copier TOUT
COPY . /app

WORKDIR /app

# Installer
RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
EOF

# Build
docker build -f Dockerfile.bad -t node-app:bad .

# Problèmes:
# - Image lourde (node:18 au lieu de alpine)
# - Cache npm invalidé à chaque changement de code
# - Pas de .dockerignore
```

### Exercice 3.3 : Dockerfile Optimisé

```dockerfile
cat > Dockerfile << 'EOF'
# Image légère
FROM node:18-alpine

# Metadata
LABEL maintainer="votre@email.com"
LABEL version="1.0"

# Variables d'environnement
ENV NODE_ENV=production \
    PORT=3000

# Répertoire de travail
WORKDIR /app

# Copier SEULEMENT package.json (pour le cache)
COPY package*.json ./

# Installer dépendances
RUN npm ci --only=production && \
    npm cache clean --force

# Copier le code source
COPY server.js .

# User non-root (sécurité)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs

# Port exposé (documentation)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:$PORT/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Commande de démarrage
CMD ["node", "server.js"]
EOF

# .dockerignore
cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
Dockerfile*
.dockerignore
EOF

# Build
docker build -t node-app:optimized .

# Comparer les tailles
docker images | grep node-app
```

### Exercice 3.4 : Tester l'Application

```bash
# Lancer le container
docker run -d \
  --name my-node-app \
  -p 3000:3000 \
  -e NODE_ENV=development \
  node-app:optimized

# Tester
curl http://localhost:3000
curl http://localhost:3000/health

# Voir les logs
docker logs my-node-app

# Health check
docker inspect --format='{{json .State.Health}}' my-node-app | jq

# Cleanup
docker stop my-node-app
docker rm my-node-app
```

---

## 📚 Partie 4 : ARG vs ENV

### Exercice 4.1 : Build Arguments

```dockerfile
cat > Dockerfile.args << 'EOF'
FROM node:18-alpine

# ARG: disponible UNIQUEMENT pendant le build
ARG VERSION=1.0.0
ARG BUILD_DATE

# ENV: disponible au runtime
ENV APP_VERSION=${VERSION}

LABEL version=${VERSION}
LABEL build-date=${BUILD_DATE}

RUN echo "Building version ${VERSION}"

CMD echo "Running version $APP_VERSION"
EOF

# Build avec arguments
docker build \
  -f Dockerfile.args \
  --build-arg VERSION=2.0.0 \
  --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  -t app:v2 .

# Vérifier
docker run --rm app:v2
docker inspect app:v2 | grep -A 5 Labels
```

---

## 📚 Partie 5 : CMD vs ENTRYPOINT

### Exercice 5.1 : CMD Seul

```dockerfile
cat > Dockerfile.cmd << 'EOF'
FROM alpine:3.18

CMD ["echo", "Hello World"]
EOF

docker build -f Dockerfile.cmd -t cmd-demo .

# Utilisation
docker run --rm cmd-demo              # Hello World
docker run --rm cmd-demo echo "Bye"   # Bye (override CMD)
```

### Exercice 5.2 : ENTRYPOINT Seul

```dockerfile
cat > Dockerfile.entrypoint << 'EOF'
FROM alpine:3.18

ENTRYPOINT ["echo"]
EOF

docker build -f Dockerfile.entrypoint -t entry-demo .

# Utilisation
docker run --rm entry-demo "Hello"    # Hello
docker run --rm entry-demo "Hi" "There"  # Hi There
```

### Exercice 5.3 : ENTRYPOINT + CMD (Meilleure Pratique)

```dockerfile
cat > Dockerfile.both << 'EOF'
FROM alpine:3.18

ENTRYPOINT ["echo"]
CMD ["Default message"]
EOF

docker build -f Dockerfile.both -t both-demo .

# Utilisation
docker run --rm both-demo              # Default message
docker run --rm both-demo "Custom"     # Custom
```

---

## 📚 Partie 6 : Multi-Language Examples

### Python Flask App

```bash
mkdir -p ~/docker-exercices/python-app
cd ~/docker-exercices/python-app

cat > requirements.txt << 'EOF'
Flask==3.0.0
EOF

cat > app.py << 'EOF'
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify(message="Hello from Flask + Docker!")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

RUN adduser --disabled-password --gecos '' appuser
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
EOF

cat > .dockerignore << 'EOF'
__pycache__
*.pyc
.venv
EOF

docker build -t python-app .
docker run -d -p 5000:5000 --name flask-app python-app
curl http://localhost:5000
docker stop flask-app && docker rm flask-app
```

### Go Application

```bash
mkdir -p ~/docker-exercices/go-app
cd ~/docker-exercices/go-app

cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Go + Docker!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server starting on :8080")
    http.ListenAndServe(":8080", nil)
}
EOF

cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY main.go .

RUN go build -o server main.go

FROM alpine:3.18
COPY --from=builder /app/server /server

EXPOSE 8080
CMD ["/server"]
EOF

docker build -t go-app .
docker run -d -p 8080:8080 --name go-server go-app
curl http://localhost:8080
docker stop go-server && docker rm go-server
```

---

## ✅ Exercice de Validation

Créez une application web complète avec Dockerfile optimisé :

**Checklist :**
- [ ] Image de base alpine ou slim
- [ ] .dockerignore configuré
- [ ] Dependencies installées avant le code (cache)
- [ ] User non-root
- [ ] Health check
- [ ] Labels (version, maintainer)
- [ ] EXPOSE documente le port
- [ ] CMD utilise la forme exec

---

## 🎯 Défis

### Défi 1 : Static Website

Créez un container nginx servant un site HTML statique.

### Défi 2 : Database Init

Créez un Dockerfile PostgreSQL qui exécute un script SQL au démarrage.

### Défi 3 : Multi-service

Créez une image qui démarre nginx ET php-fpm (indice: supervisord).

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Créer un Dockerfile
- ✅ Instructions principales (FROM, RUN, COPY, CMD)
- ✅ Optimisation du cache
- ✅ .dockerignore
- ✅ ARG vs ENV
- ✅ CMD vs ENTRYPOINT
- ✅ Best practices de sécurité

---

## ➡️ Prochaine Étape

[Exercice 05 : Application Node.js Complète](../05-nodejs-app/README.md)

---

## 📚 Ressources

- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
