# 🏆 Exercice 10 : Projet Final - Application Production-Ready

## 🎯 Objectif
Créer une application complète avec toutes les bonnes pratiques Docker.

## 💡 L'Analogie : L'Entreprise Complète
*   **Votre App** = Une **entreprise** avec plusieurs départements
*   **Frontend** = Le **magasin** (vitrine publique)
*   **Backend** = Le **bureau** (traite les commandes)
*   **Database** = L'**entrepôt** (stocke tout)
*   **Redis** = Le **bloc-notes** (mémoire rapide)
*   **Nginx** = Le **gardien** à l'entrée (reverse proxy)

## 🗺️ Roadmap & Étapes

### Architecture Complète
```
Internet
    ↓
Nginx (Reverse Proxy)
    ↓
Frontend (React) ← → Backend (Node.js) ← → Database (PostgreSQL)
                           ↓
                        Redis (Cache)
```

### Étape 1 : Structure du Projet
```
projet-final/
├── docker-compose.yml
├── docker-compose.prod.yml
├── .env
├── .dockerignore
├── nginx/
│   └── nginx.conf
├── frontend/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── package.json
│   └── src/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
└── database/
    └── init.sql
```

### Étape 2 : Backend (API Node.js)
**backend/Dockerfile :**
```dockerfile
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --chown=appuser:appgroup package*.json ./

USER appuser

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:4000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

CMD ["node", "dist/server.js"]
```

### Étape 3 : Frontend (React)
**frontend/Dockerfile :**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
```

### Étape 4 : Docker Compose Development
**docker-compose.yml :**
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER:-devuser}
      POSTGRES_PASSWORD: ${DB_PASS:-devpass}
      POSTGRES_DB: ${DB_NAME:-appdb}
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-devuser}"]
      interval: 10s
    networks:
      - backend

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redisdata:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
    networks:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    ports:
      - "4000:4000"
    environment:
      DATABASE_URL: postgresql://${DB_USER:-devuser}:${DB_PASS:-devpass}@postgres:5432/${DB_NAME:-appdb}
      REDIS_URL: redis://redis:6379
      NODE_ENV: development
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - backend
      - frontend

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    environment:
      REACT_APP_API_URL: http://localhost:4000
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend
    networks:
      - frontend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - frontend
      - backend
    networks:
      - frontend

volumes:
  pgdata:
  redisdata:

networks:
  frontend:
  backend:
```

### Étape 5 : Production (Optimisé)
**docker-compose.prod.yml :**
```yaml
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile  # Multi-stage optimisé
    restart: unless-stopped
    environment:
      NODE_ENV: production
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 128M
```

**Déployer :**
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Étape 6 : Nginx Reverse Proxy
**nginx/nginx.conf :**
```nginx
upstream frontend {
    server frontend:3000;
}

upstream backend {
    server backend:4000;
}

server {
    listen 80;

    location / {
        proxy_pass http://frontend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
    }

    location /api {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /health {
        access_log off;
        return 200 "healthy\n";
    }
}
```

### Étape 7 : Sécurité et Best Practices

**.env (JAMAIS commiter !) :**
```env
DB_USER=produser
DB_PASS=ChangeM3!Pr0d
DB_NAME=proddb
```

**.dockerignore :**
```.dockerignore
node_modules
npm-debug.log
.git
.env
.env.local
.vscode
**/*.test.js
```

**Checklist Sécurité :**
- ✅ User non-root dans tous les Dockerfiles
- ✅ Images Alpine (légères)
- ✅ Multi-stage builds
- ✅ Health checks
- ✅ Secrets dans .env (pas hardcodé)
- ✅ Networks isolés (frontend/backend)
- ✅ Volumes pour la persistence
- ✅ Resource limits en production

### Étape 8 : CI/CD (Bonus)
**.github/workflows/docker.yml :**
```yaml
name: Docker Build

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build images
        run: |
          docker-compose build
          
      - name: Run tests
        run: |
          docker-compose run backend npm test
          
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker-compose push
```

## ✅ Validation Complète
```bash
# 1. Démarrer tout
docker-compose up -d

# 2. Vérifier que tout tourne
docker-compose ps

# 3. Voir les logs
docker-compose logs -f

# 4. Tester l'API
curl http://localhost/api/health

# 5. Tester le frontend
open http://localhost

# 6. Vérifier les health checks
docker inspect backend | grep Health -A 10

# 7. Stats
docker stats

# 8. Nettoyer
docker-compose down -v
```

## 🎓 Ce Que Vous Maîtrisez Maintenant
- ✅ Multi-container orchestration
- ✅ Multi-stage builds optimisés
- ✅ Networks et isolation
- ✅ Volumes et persistence
- ✅ Health checks
- ✅ Security best practices
- ✅ Dev vs Prod environments
- ✅ Reverse proxy (Nginx)

## 🚀 Prochaines Étapes
1. **Kubernetes** : Orchestrer en production
2. **Monitoring** : Prometheus + Grafana
3. **CI/CD** : Automatiser le déploiement
4. **Cloud** : Déployer sur AWS/Azure/GCP

**Félicitations ! Vous êtes maintenant un expert Docker ! 🐳**
