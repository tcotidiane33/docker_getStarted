# 🎯 Cas d'Usage Pratiques Docker

## 💡 Niveaux de Complexité

- 🟢 **Niveau 1** : Débutant (Semaine 1)
- 🟡 **Niveau 2** : Intermédiaire (Semaine 2)
- 🔴 **Niveau 3** : Avancé (Semaine 3+)

---

## 🟢 Niveau 1 : Cas Débutant

### Cas 1 : Containeriser une Application Node.js Simple

**Contexte :** Vous avez une app Node.js et voulez la containeriser.

**Structure :**
```
app/
├── server.js
├── package.json
└── Dockerfile
```

**server.js :**
```javascript
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send('Hello from Docker!');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

**package.json :**
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  },
  "scripts": {
    "start": "node server.js"
  }
}
```

**Dockerfile :**
```dockerfile
# Image de base
FROM node:18-alpine

# Répertoire de travail
WORKDIR /app

# Copier package files
COPY package*.json ./

# Installer dépendances
RUN npm ci --only=production

# Copier code source
COPY server.js ./

# Exposer port
EXPOSE 3000

# Commande de démarrage
CMD ["npm", "start"]
```

**Workflow :**
```bash
# 1. Build l'image
docker build -t my-node-app:1.0 .

# 2. Run le container
docker run -d -p 3000:3000 --name app my-node-app:1.0

# 3. Tester
curl http://localhost:3000
# → "Hello from Docker!"

# 4. Voir logs
docker logs app

# 5. Arrêter et supprimer
docker stop app
docker rm app
```

**Compétences Apprises :**
- ✅ Créer un Dockerfile
- ✅ `docker build`
- ✅ `docker run` avec port mapping
- ✅ `docker logs`

**Temps estimé :** 1 heure

---

### Cas 2 : Environnement de Développement avec Volumes

**Contexte :** Développer avec hot-reload sans rebuild.

**Structure :**
```
dev-app/
├── src/
│   └── index.js
├── package.json
├── Dockerfile
└── docker-compose.yml
```

**Dockerfile :**
```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install  # Inclut dev dependencies
CMD ["npm", "run", "dev"]
```

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  app:
    build: .
    volumes:
      - ./src:/app/src  # Hot reload
      - /app/node_modules  # Exclude node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    command: npm run dev
```

**Workflow :**
```bash
# 1. Démarrer
docker-compose up

# 2. Modifier src/index.js
# → App se recharge automatiquement

# 3. Voir les logs en temps réel
docker-compose logs -f

# 4. Arrêter
docker-compose down
```

**Compétences Apprises :**
- ✅ Docker Compose
- ✅ Volumes pour hot reload
- ✅ Environment variables
- ✅ Development workflow

**Temps estimé :** 2 heures

---

### Cas 3 : Base de Données PostgreSQL Persistante

**Contexte :** Lancer PostgreSQL avec données persistantes.

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: myapp
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U devuser"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
    driver: local
```

**init.sql :**
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(100)
);

INSERT INTO users (username, email) VALUES
  ('alice', 'alice@example.com'),
  ('bob', 'bob@example.com');
```

**Workflow :**
```bash
# 1. Démarrer database
docker-compose up -d

# 2. Vérifier santé
docker-compose ps

# 3. Se connecter
docker-compose exec db psql -U devuser -d myapp

# 4. Query
SELECT * FROM users;

# 5. Arrêter (données persistent via volume)
docker-compose down

# 6. Redémarrer (données toujours là)
docker-compose up -d
```

**Compétences Apprises :**
- ✅ Volumes pour persistence
- ✅ Init scripts
- ✅ Health checks
- ✅ `docker-compose exec`

**Temps estimé :** 1h30

---

## 🟡 Niveau 2 : Cas Intermédiaire

### Cas 4 : Stack MERN (MongoDB, Express, React, Node)

**Contexte :** Application full-stack avec frontend/backend/database.

**Structure :**
```
mern-app/
├── frontend/
│   ├── Dockerfile
│   └── package.json
├── backend/
│   ├── Dockerfile
│   └── package.json
└── docker-compose.yml
```

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  # MongoDB
  mongo:
    image: mongo:7
    volumes:
      - mongo-data:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: secret
    networks:
      - backend

  # Backend API
  api:
    build: ./backend
    ports:
      - "4000:4000"
    environment:
      MONGODB_URI: mongodb://admin:secret@mongo:27017/myapp?authSource=admin
      NODE_ENV: production
    depends_on:
      - mongo
    networks:
      - frontend
      - backend
    restart: unless-stopped

  # Frontend React
  web:
    build: ./frontend
    ports:
      - "3000:80"
    environment:
      REACT_APP_API_URL: http://localhost:4000
    depends_on:
      - api
    networks:
      - frontend
    restart: unless-stopped

volumes:
  mongo-data:

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```

**backend/Dockerfile :**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app .
EXPOSE 4000
CMD ["node", "server.js"]
```

**frontend/Dockerfile :**
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Workflow :**
```bash
# 1. Build et démarrer toute la stack
docker-compose up --build -d

# 2. Vérifier tous les services
docker-compose ps

# 3. Voir logs d'un service spécifique
docker-compose logs -f api

# 4. Scaler le backend
docker-compose up -d --scale api=3

# 5. Arrêter tout
docker-compose down
```

**Compétences Apprises :**
- ✅ Multi-stage builds
- ✅ Multi-services stack
- ✅ Networks isolation
- ✅ Service dependencies
- ✅ Scaling

**Temps estimé :** 4-6 heures

---

### Cas 5 : Microservices avec API Gateway

**Contexte :** Architecture microservices avec Nginx comme reverse proxy.

**Structure :**
```
microservices/
├── auth-service/
├── user-service/
├── order-service/
├── gateway/
│   └── nginx.conf
└── docker-compose.yml
```

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  # Auth Microservice (Node.js)
  auth:
    build: ./auth-service
    environment:
      PORT: 3001
      JWT_SECRET: ${JWT_SECRET}
    networks:
      - backend

  # User Microservice (Python)
  users:
    build: ./user-service
    environment:
      PORT: 3002
      DATABASE_URL: postgresql://db:5432/users
    networks:
      - backend

  # Order Microservice (Go)
  orders:
    build: ./order-service
    environment:
      PORT: 3003
    networks:
      - backend

  # API Gateway (Nginx)
  gateway:
    image: nginx:alpine
    volumes:
      - ./gateway/nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:80"
    depends_on:
      - auth
      - users
      - orders
    networks:
      - backend

networks:
  backend:
```

**gateway/nginx.conf :**
```nginx
events {
    worker_connections 1024;
}

http {
    upstream auth_service {
        server auth:3001;
    }
    
    upstream user_service {
        server users:3002;
    }
    
    upstream order_service {
        server orders:3003;
    }

    server {
        listen 80;

        location /api/auth/ {
            proxy_pass http://auth_service/;
        }

        location /api/users/ {
            proxy_pass http://user_service/;
        }

        location /api/orders/ {
            proxy_pass http://order_service/;
        }
    }
}
```

**Workflow :**
```bash
# 1. Démarrer tous les microservices
docker-compose up -d

# 2. Tester via gateway
curl http://localhost/api/auth/health
curl http://localhost/api/users/health
curl http://localhost/api/orders/health

# 3. Voir logs d'un service
docker-compose logs -f auth

# 4. Redémarrer un service spécifique
docker-compose restart users
```

**Compétences Apprises :**
- ✅ Microservices architecture
- ✅ Nginx reverse proxy
- ✅ Service discovery
- ✅ Multi-language stack

**Temps estimé :** 6-8 heures

---

## 🔴 Niveau 3 : Cas Avancé

### Cas 6 : CI/CD avec Tests et Multi-Stage Build

**Contexte :** Pipeline complet de test et déploiement.

**Dockerfile.multistage :**
```dockerfile
# Stage 1: Dependencies
FROM node:18-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Stage 2: Test
FROM dependencies AS test
COPY . .
RUN npm run lint
RUN npm test
RUN npm run test:coverage

# Stage 3: Build
FROM dependencies AS builder
COPY . .
RUN npm run build

# Stage 4: Production
FROM node:18-alpine AS production
WORKDIR /app

# Créer user non-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copier seulement le nécessaire
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=dependencies --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs package.json ./

USER nodejs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))"

CMD ["node", "dist/server.js"]
```

**.github/workflows/docker.yml :**
```yaml
name: Docker CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build test stage
        run: docker build --target test -t app:test .
      
      - name: Run tests in container
        run: docker run app:test

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            myapp:latest
            myapp:${{ github.sha }}
          target: production

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: |
          # SSH vers serveur production
          # docker pull myapp:latest
          # docker-compose up -d
```

**Compétences Apprises :**
- ✅ Multi-stage builds avancés
- ✅ CI/CD integration
- ✅ Security (non-root user)
- ✅ Health checks
- ✅ Automated testing

**Temps estimé :** 8 heures

---

### Cas 7 : Monitoring Stack (Prometheus + Grafana)

**Contexte :** Monitorer vos containers et applications.

**docker-compose.monitoring.yml :**
```yaml
version: '3.8'

services:
  # Application to monitor
  app:
    image: myapp:latest
    ports:
      - "3000:3000"
    networks:
      - monitoring

  # Prometheus
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - monitoring
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  # Node Exporter (métriques système)
  node-exporter:
    image: prom/node-exporter:latest
    networks:
      - monitoring

  # cAdvisor (métriques containers)
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      -"8080:8080"
    networks:
      - monitoring

  # Grafana
  grafana:
    image: grafana/grafana:latest
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
    networks:
      - monitoring

volumes:
  prometheus-data:
  grafana-data:

networks:
  monitoring:
```

**prometheus.yml :**
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'app'
    static_configs:
      - targets: ['app:3000']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

**Workflow :**
```bash
# 1. Démarrer stack monitoring
docker-compose -f docker-compose.monitoring.yml up -d

# 2. Accéder aux interfaces
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3001 (admin/admin)
# cAdvisor: http://localhost:8080

# 3. Importer dashboards Grafana
# Dashboard ID: 1860 (Node Exporter Full)
# Dashboard ID: 893 (Docker monitoring)
```

**Compétences Apprises :**
- ✅ Prometheus configuration
- ✅ Grafana dashboards
- ✅ Metrics collection
- ✅ Container monitoring

**Temps estimé :** 6 heures

---

### Cas 8 : Production-Ready avec Secrets et Health Checks

**Contexte :** Configuration pour production avec sécurité.

**docker-compose.prod.yml :**
```yaml
version: '3.8'

services:
  app:
    image: myapp:${VERSION:-latest}
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
        max_attempts: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    secrets:
      - db_password
      - jwt_secret
    environment:
      NODE_ENV: production
      DB_HOST: db
      DB_USER: appuser
      DB_PASSWORD_FILE: /run/secrets/db_password
      JWT_SECRET_FILE: /run/secrets/jwt_secret
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - frontend
      - backend

  db:
    image: postgres:15-alpine
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints:
          - node.role == manager

secrets:
  db_password:
    file: ./secrets/db_password.txt
  jwt_secret:
    file: ./secrets/jwt_secret.txt

volumes:
  db-data:

networks:
  frontend:
    driver: overlay
  backend:
    driver: overlay
    internal: true
```

**secrets/db_password.txt :**
```
my-secure-password-here
```

**Workflow :**
```bash
# 1. Créer secrets
mkdir -p secrets
echo "secure-db-password" > secrets/db_password.txt
echo "jwt-secret-key" > secrets/jwt_secret.txt
chmod 600 secrets/*

# 2. Deploy en production
docker stack deploy -c docker-compose.prod.yml myapp

# 3. Vérifier déploiement
docker service ls
docker service ps myapp_app

# 4. Voir logs d'un service
docker service logs -f myapp_app

# 5. Scaler
docker service scale myapp_app=5

# 6. Update sans downtime
docker service update --image myapp:v2 myapp_app
```

**Compétences Apprises :**
- ✅ Docker Swarm / Stack
- ✅ Secrets management
- ✅ Resource limits
- ✅ Health checks avancés
- ✅ Logging configuration
- ✅ Zero-downtime deployments

**Temps estimé :** 10 heures

---

## 📊 Tableau Récapitulatif

| Cas | Niveau | Stack | Use Case | Temps |
|-----|--------|-------|----------|-------|
| 1 | 🟢 | Node.js | App simple | 1h |
| 2 | 🟢 | Dev env | Hot reload | 2h |
| 3 | 🟢 | PostgreSQL | Database | 1h30 |
| 4 | 🟡 | MERN | Full-stack | 4-6h |
| 5 | 🟡 | Microservices | Architecture | 6-8h |
| 6 | 🔴 | CI/CD | Automation | 8h |
| 7 | 🔴 | Monitoring | Observability | 6h |
| 8 | 🔴 | Production | Enterprise | 10h |

---

## 🎯 Progression Recommandée

**Semaine 1 :** Cas 1, 2, 3  
**Semaine 2 :** Cas 4, 5  
**Semaine 3+ :** Cas 6, 7, 8

---

**Prochaine étape :** [Retour au Parcours](./PARCOURS-PEDAGOGIQUE.md)
