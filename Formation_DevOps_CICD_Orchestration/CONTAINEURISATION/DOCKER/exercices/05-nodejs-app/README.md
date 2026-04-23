# Exercice 05 : Application Node.js Avancée avec Docker

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer une application Node.js/Express complète
- ✅ Implémenter le hot-reload en développement
- ✅ Gérer plusieurs environnements (dev/prod)
- ✅ Optimiser l'image avec multi-stage builds
- ✅ Utiliser des volumes pour le développement

## ⏱️ Durée Estimée
**2 heures**

## 📋 Prérequis
- [Exercice 04 : Premier Dockerfile](../04-dockerfile/README.md) complété
- Connaissance basique de Node.js/Express

---

## 📚 Partie 1 : Setup du Projet

```bash
mkdir -p ~/docker-exercices/nodejs-advanced
cd ~/docker-exercices/nodejs-advanced

# Structure du projet
mkdir -p src routes controllers config

# package.json
cat > package.json << 'EOF'
{
  "name": "docker-nodejs-advanced",
  "version": "1.0.0",
  "description": "Advanced Node.js app with Docker",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js",
    "test": "echo \"Tests passed\" && exit 0"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

# server.js
cat > src/server.js << 'EOF'
require('dotenv').config();
const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;
const ENV = process.env.NODE_ENV || 'development';

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'Node.js + Docker Advanced',
    environment: ENV,
    version: process.env.npm_package_version,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.get('/api/users', (req, res) => {
  res.json([
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' }
  ]);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT} in ${ENV} mode`);
});
EOF

# .env.example
cat > .env.example << 'EOF'
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:pass@db:5432/mydb
REDIS_URL=redis://cache:6379
EOF

# .dockerignore
cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.*
!.env.example
Dockerfile*
.dockerignore
coverage
*.md
EOF
```

---

## 📚 Partie 2 : Dockerfile de Développement

```dockerfile
cat > Dockerfile.dev << 'EOF'
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev)
RUN npm install

# Don't copy source code (we'll use volumes)

EXPOSE 3000

# Use nodemon for hot reload
CMD ["npm", "run", "dev"]
EOF
```

---

## 📚 Partie 3 : Dockerfile de Production (Multi-Stage)

```dockerfile
cat > Dockerfile << 'EOF'
# ==================
# Stage 1: Dependencies
# ==================
FROM node:18-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production && \
    npm cache clean --force

# ==================
# Stage 2: Build (if needed for TypeScript, etc.)
# ==================
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY src/ ./src/

# If you had build step (TypeScript, etc.):
# RUN npm run build

# ==================
# Stage 3: Production
# ==================
FROM node:18-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy dependencies from dependencies stage
COPY --from=dependencies --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy source code
COPY --chown=nodejs:nodejs src/ ./src/
COPY --chown=nodejs:nodejs package*.json ./

# Environment
ENV NODE_ENV=production \
    PORT=3000

# Switch to non-root user
USER nodejs

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "src/server.js"]
EOF
```

---

## 📚 Partie 4 : Docker Compose pour Développement

```yaml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      # Mount source code for hot reload
      - ./src:/app/src:ro
      - ./package.json:/app/package.json:ro
      # Use named volume for node_modules
      - node_modules:/app/node_modules
    environment:
      - NODE_ENV=development
      - PORT=3000
      - DATABASE_URL=postgresql://postgres:secret@db:5432/devdb
      - REDIS_URL=redis://cache:6379
    depends_on:
      - db
      - cache
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: devdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - app-network

  cache:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - app-network

volumes:
  node_modules:
  postgres_data:

networks:
  app-network:
    driver: bridge
EOF
```

---

## 📚 Partie 5 : Tester en Développement

```bash
# Lancer l'environnement de dev
docker-compose up

# Dans un autre terminal, installer les dépendances la première fois
docker-compose run --rm app npm install

# Tester l'API
curl http://localhost:3000
curl http://localhost:3000/api/users
curl http://localhost:3000/health

# Modifier src/server.js et voir le reload automatique!

# Arrêter
docker-compose down
```

---

## 📚 Partie 6 : Build et Test de Production

```bash
# Build l'image de production
docker build -t nodejs-app:1.0 .

# Vérifier la taille
docker images nodejs-app

# Comparer avec une version non-optimisée
docker build -f Dockerfile.dev -t nodejs-app:dev .
docker images nodejs-app

# Lancer en production
docker run -d \
  --name nodejs-prod \
  -p 3000:3000 \
  -e NODE_ENV=production \
  nodejs-app:1.0

# Tester
curl http://localhost:3000

# Vérifier health check
docker inspect --format='{{json .State.Health}}' nodejs-prod | jq

# Cleanup
docker stop nodejs-prod
docker rm nodejs-prod
```

---

## 📚 Partie 7 : Optimisations Avancées

### Layer Caching Optimal

```dockerfile
# ❌ Mauvais: Cache invalidé à chaque changement de code
COPY . .
RUN npm install

# ✅ Bon: Cache npm préservé
COPY package*.json ./
RUN npm install
COPY . .

# ✅ Encore mieux: Séparer prod et dev deps
COPY package*.json ./
RUN npm ci --only=production
COPY . .
```

### Security Scanning

```bash
# Scanner les vulnérabilités
docker scout quickview nodejs-app:1.0

# Ou avec Trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image nodejs-app:1.0
```

---

## ✅ Exercice de Validation

Ajoutez ces fonctionnalités :

### 1. Endpoint Database

```javascript
// src/server.js
app.get('/api/db-test', async (req, res) => {
  try {
    // Simuler une requête DB
    res.json({ database: 'connected', url: process.env.DATABASE_URL });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

### 2. Endpoint Cache

```javascript
app.get('/api/cache-test', (req, res) => {
  res.json({ cache: 'ok', url: process.env.REDIS_URL });
});
```

### 3. Tests

```bash
# Tester tous les endpoints
curl http://localhost:3000/
curl http://localhost:3000/health
curl http://localhost:3000/api/users
curl http://localhost:3000/api/db-test
curl http://localhost:3000/api/cache-test
```

---

## 🎯 Défis Avancés

### Défi 1 : Variables d'Environnement Avancées

Créez un fichier `.env.production` et utilisez-le:

```bash
docker run --env-file .env.production nodejs-app:1.0
```

### Défi 2 : Logs Structurés

Ajoutez winston pour des logs JSON :

```bash
npm install winston

# Modifiez server.js pour logger en JSON
```

### Défi 3 : Graceful Shutdown

Implémentez un arrêt propre :

```javascript
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down...');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});
```

---

## 🐛 Troubleshooting

### Problème: Hot reload ne fonctionne pas

```bash
# Vérifier que les volumes sont montés
docker-compose exec app ls -la /app/src

# Redémarrer
docker-compose restart app
```

### Problème: Permission denied sur node_modules

```bash
# Utiliser un volume nommé pour node_modules
volumes:
  - node_modules:/app/node_modules
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Multi-stage builds pour optimiser la taille
- ✅ Development vs Production Dockerfiles
- ✅ Hot reload avec volumes
- ✅ Docker Compose pour développement local
- ✅ Health checks
- ✅ Security (non-root user, scanner)
- ✅ Proper signal handling avec dumb-init

---

## ➡️ Prochaine Étape

[Exercice 06 : Docker Volumes](../06-volumes/README.md)

---

## 📚 Ressources

- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)
