# 🏗️ Exercice 09 : Multi-stage Builds - L'Optimisation

## 🎯 Objectif
Créer des images Docker ultra-légères avec les multi-stage builds.

## 💡 L'Analogie : La Construction d'une Maison
*   **Image normale** = Laisser tous les **échafaudages** et **outils** après construction. Encombrant !
*   **Multi-stage** = **Démonter les échafaudages** une fois la maison finie. Seul le résultat final reste.
*   **Stage "builder"** = Le **chantier** avec tous les outils
*   **Stage "production"** = La **maison finale** propre et habitable

## 🗺️ Roadmap & Étapes

### Étape 1 : Le Problème (Image Énorme)
**Dockerfile classique :**
```dockerfile
FROM node:18

WORKDIR /app
COPY package*.json ./
RUN npm install  # TOUTES les deps (dev + prod)
COPY . .
RUN npm run build  # Compile TypeScript

EXPOSE 3000
CMD ["node", "dist/server.js"]
```

**Résultat :** Image de 1.2 GB ! 😱
- node_modules avec deps de dev
- Code source TypeScript
- Outils de build

### Étape 2 : La Solution (Multi-stage)
```dockerfile
# STAGE 1: Construction
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install  # Tout installer

COPY . .
RUN npm run build  # Compiler

# STAGE 2: Production
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production  # Seulement deps prod

# Copier SEULEMENT le code compilé depuis builder
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/server.js"]
```

**Résultat :** Image de 180 MB ! 🎉 (-85%)

**Analogie :** On a construit dans le chantier (builder), puis on a pris uniquement la maison finie et on a tout nettoyé.

### Étape 3 : Exemple Go (Encore Plus Impressionnant)
**Sans multi-stage :**
```dockerfile
FROM golang:1.21

WORKDIR /app
COPY . .
RUN go build -o server

CMD ["./server"]
```

**Taille :** 800 MB (avec tout le SDK Go)

**Avec multi-stage :**
```dockerfile
# Build
FROM golang:1.21 AS builder

WORKDIR /app
COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server

# Production
FROM alpine:3.18

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]
```

**Taille :** 15 MB ! 🤯 (-98%)

### Étape 4 : Exemple React (Frontend)
```dockerfile
# Build
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build  # Crée /app/build

# Production
FROM nginx:alpine

# Copier seulement les fichiers statiques
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Avant :** 1.5 GB (Node + sources)  
**Après :** 25 MB (Nginx + HTML/JS/CSS)

### Étape 5 : Nommer les Stages
```dockerfile
FROM node:18 AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:18 AS build
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:18 AS test
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm test

FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
```

**Build seulement le stage test :**
```bash
docker build --target test -t myapp:test .
```

### Étape 6 : Copier Depuis N'importe Quelle Image
```dockerfile
FROM alpine:latest

# Copier depuis une autre image (pas forcément un stage précédent)
COPY --from=nginx:latest /etc/nginx/nginx.conf /myconf/

# Utiliser une image externe comme "builder"
COPY --from=golang:1.21 /usr/local/go/bin/go /usr/local/bin/
```

### Étape 7 : Secrets dans le Build (Sans les Leaker)
```dockerfile
FROM alpine AS builder

# Monte un secret SEULEMENT pendant le build
RUN --mount=type=secret,id=npmrc \
    cat /run/secrets/npmrc > ~/.npmrc && \
    npm install

# Le secret n'est PAS dans l'image finale!

FROM alpine
COPY --from=builder /app /app
```

```bash
docker build --secret id=npmrc,src=.npmrc -t myapp .
```

## ✅ Exercice Complet
Optimisez une app complète :

**Avant (Dockerfile simple) :**
```dockerfile
FROM python:3.11

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN pytest  # Tests
CMD ["gunicorn", "app:app"]
```

**Après (Multi-stage optimisé) :**
```dockerfile
# Dependencies
FROM python:3.11-slim AS deps
WORKDIR /app
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Tests
FROM python:3.11-slim AS test
WORKDIR /app
COPY --from=deps /wheels /wheels
RUN pip install --no-index --find-links=/wheels -r requirements.txt
COPY . .
RUN pytest

# Production
FROM python:3.11-alpine
WORKDIR /app
COPY --from=deps /wheels /wheels
COPY requirements.txt .
RUN pip install --no-index --find-links=/wheels -r requirements.txt
COPY app.py .

RUN adduser -D appuser
USER appuser

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
```

**Comparaison :**
- Avant : 1.1 GB
- Après : 95 MB
- Tests inclus dans le build mais pas dans l'image finale

## ➡️ Prochaine Étape
[Exercice 10 : Projet Final](../10-projet-final/GUIDE.md)

**Ce que vous avez compris :**
Multi-stage builds = Construction en plusieurs étapes. On garde seulement le résultat final (maison finie), on jette les outils (échafaudages). Résultat : images 10x plus légères !
