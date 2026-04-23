# Exercice 10 : Projet Final - Application Production-Ready

## 🎯 Objectifs du Projet

Créer une application complète, production-ready avec :
- ✅ Frontend (React/Vue/Angular ou simple HTML)
- ✅ Backend API (Node.js/Python/Go)
- ✅ Base de données (PostgreSQL/MySQL/MongoDB)
- ✅ Cache (Redis)
- ✅ Reverse Proxy (Nginx)
- ✅ Monitoring & Logs
- ✅ Multi-stage builds optimisés
- ✅ Health checks
- ✅ Volumes persistants
- ✅ Networks isolés
- ✅ Docker Compose pour orchestration

## ⏱️ Durée Estimée
**3-4 heures**

## 📋 Prérequis
- Tous les exercices précédents complétés
- Connaissances de base en développement web

---

## 🏗️ Architecture du Projet

```
┌──────────────────────────────────────────────┐
│           Internet (Port 80/443)             │
└────────────────┬─────────────────────────────┘
                 │
        ┌────────▼────────┐
        │  Nginx Proxy    │  ← network: public
        │  (Load Balancer)  │
        └────────┬────────┘
                 │
                 │  ┌────────────┐
                 ├──│  Frontend  │  ← network: frontend
                 │  └────────────┘
                 │
        ┌────────▼────────┐
        │   Backend API   │  ← network: frontend + backend
        └────────┬────────┘
                 │
         ┌───────┴────────┐
         │                │
    ┌────▼─────┐    ┌────▼─────┐
    │PostgreSQL│    │  Redis   │  ← network: backend (isolé)
    └──────────┘    └──────────┘
```

---

## 📚 Partie 1 : Structure du Projet

```bash
mkdir -p ~/docker-final-project
cd ~/docker-final-project

# Créer la structure
mkdir -p {frontend,backend,nginx,monitoring}/{src,config}
mkdir -p scripts

# Structure finale:
# .
# ├── frontend/
# │   ├── Dockerfile
# │   ├── package.json
# │   └── src/
# ├── backend/
# │   ├── Dockerfile
# │   ├── package.json
# │   └── src/
# ├── nginx/
# │   ├── Dockerfile
# │   └── nginx.conf
# ├── docker-compose.yml
# ├── docker-compose.prod.yml
# ├── .env.example
# └── scripts/
```

---

## 📚 Partie 2 : Backend API (Node.js + Express)

```bash
cd ~/docker-final-project/backend

cat > package.json << 'EOF'
{
  "name": "backend-api",
  "version": "1.0.0",
  "main": "src/server.js",
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.3",
    "redis": "^4.6.10",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

cat > src/server.js << 'EOF'
require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// PostgreSQL
const pool = new Pool({
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME || 'appdb',
  port: 5432,
});

// Redis
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST || 'cache'}:6379`
});
redisClient.connect().catch(console.error);

// Health Check
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    await redisClient.ping();
    res.json({
      status: 'healthy',
      database: 'connected',
      cache: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      error: error.message
    });
  }
});

// Get all items
app.get('/api/items', async (req, res) => {
  try {
    // Check cache first
    const cached = await redisClient.get('items');
    if (cached) {
      return res.json({ source: 'cache', data: JSON.parse(cached) });
    }

    // Query database
    const result = await pool.query('SELECT * FROM items ORDER BY id');
    
    // Cache the result
    await redisClient.setEx('items', 60, JSON.stringify(result.rows));
    
    res.json({ source: 'database', data: result.rows });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create item
app.post('/api/items', async (req, res) => {
  try {
    const { name, description } = req.body;
    const result = await pool.query(
      'INSERT INTO items (name, description) VALUES ($1, $2) RETURNING *',
      [name, description]
    );
    
    // Invalidate cache
    await redisClient.del('items');
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Stats
app.get('/api/stats', async (req, res) => {
  try {
    const visits = await redisClient.incr('visits');
    const itemCount = await pool.query('SELECT COUNT(*) FROM items');
    
    res.json({
      total_visits: visits,
      total_items: parseInt(itemCount.rows[0].count)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Backend API running on port ${PORT}`);
  console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully...');
  await pool.end();
  await redisClient.quit();
  process.exit(0);
});
EOF

cat > Dockerfile << 'EOF'
# ==================== Builder Stage ====================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY src/ ./src/

# ==================== Production Stage ====================
FROM node:18-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy production dependencies
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY --chown=nodejs:nodejs src/ ./src/

USER nodejs

ENV NODE_ENV=production \
    PORT=4000

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4000/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/server.js"]
EOF

cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.env
.env.*
README.md
EOF
```

---

## 📚 Partie 3 : Frontend (React-like Static)

```bash
cd ~/docker-final-project/frontend

cat > package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0",
  "scripts": {
    "build": "echo 'Building frontend...'"
  }
}
EOF

mkdir -p build
cat > build/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Docker Final Project</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 20px;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      background: white;
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    }
    h1 {
      color: #667eea;
      margin-bottom: 30px;
      font-size: 2.5em;
    }
    .section {
      margin: 30px 0;
      padding: 20px;
      background: #f7f7f7;
      border-radius: 10px;
    }
    button {
      background: #667eea;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 16px;
      margin: 5px;
      transition: all 0.3s;
    }
    button:hover {
      background: #5568d3;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    #result {
      margin-top: 20px;
      padding: 20px;
      background: #fff;
      border-radius: 8px;
      border-left: 4px solid #667eea;
      white-space: pre-wrap;
      font-family: 'Courier New', monospace;
    }
    .input-group {
      margin: 15px 0;
    }
    input {
      padding: 10px;
      border: 2px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
      width: 200px;
      margin-right: 10px;
    }
    .status {
      display: inline-block;
      padding: 5px 10px;
      border-radius: 5px;
      font-weight: bold;
    }
    .status.healthy { background: #4caf50; color: white; }
    .status.unhealthy { background: #f44336; color: white; }
  </style>
</head>
<body>
  <div class="container">
    <h1>🐳 Docker Final Project</h1>
    
    <div class="section">
      <h2>Health Status</h2>
      <button onclick="checkHealth()">Check Backend Health</button>
      <button onclick="getStats()">Get Statistics</button>
    </div>

    <div class="section">
      <h2>Items Management</h2>
      <button onclick="getItems()">Get All Items</button>
      <div class="input-group">
        <input type="text" id="itemName" placeholder="Item name">
        <input type="text" id="itemDesc" placeholder="Description">
        <button onclick="createItem()">Create Item</button>
      </div>
    </div>

    <div id="result"></div>
  </div>

  <script>
    const API_URL = window.location.protocol + '//' + window.location.hostname + ':4000';
    
    function display(data) {
      document.getElementById('result').innerHTML = JSON.stringify(data, null, 2);
    }
    
    async function checkHealth() {
      try {
        const res = await fetch(`${API_URL}/api/health`);
        const data = await res.json();
        display(data);
      } catch (error) {
        display({ error: error.message });
      }
    }
    
    async function getStats() {
      try {
        const res = await fetch(`${API_URL}/api/stats`);
        const data = await res.json();
        display(data);
      } catch (error) {
        display({ error: error.message });
      }
    }
    
    async function getItems() {
      try {
        const res = await fetch(`${API_URL}/api/items`);
        const data = await res.json();
        display(data);
      } catch (error) {
        display({ error: error.message });
      }
    }
    
    async function createItem() {
      const name = document.getElementById('itemName').value;
      const description = document.getElementById('itemDesc').value;
      
      try {
        const res = await fetch(`${API_URL}/api/items`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, description })
        });
        const data = await res.json();
        display(data);
        document.getElementById('itemName').value = '';
        document.getElementById('itemDesc').value = '';
      } catch (error) {
        display({ error: error.message });
      }
    }
  </script>
</body>
</html>
EOF

cat > Dockerfile << 'EOF'
# ==================== Build Stage ====================
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci 2>/dev/null || true

COPY . .
RUN npm run build 2>/dev/null || true

# ==================== Production Stage ====================
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files
COPY --from=build /app/build /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
```

---

## 📚 Partie 4 : Nginx Reverse Proxy

```bash
cd ~/docker-final-project/nginx

cat > nginx.conf << 'EOF'
upstream frontend {
    server frontend:80;
}

upstream backend {
    server backend:4000;
}

server {
    listen 80;
    server_name localhost;

    # Frontend
    location / {
        proxy_pass http://frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Backend API
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        # CORS headers
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
    }
}
EOF

cat > Dockerfile << 'EOF'
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=10s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF
```

---

## 📚 Partie 5 : Docker Compose

```bash
cd ~/docker-final-project

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Reverse Proxy
  proxy:
    build: ./nginx
    ports:
      - "80:80"
    depends_on:
      - frontend
      - backend
    networks:
      - public
    restart: unless-stopped

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    networks:
      - public
    restart: unless-stopped

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      DB_HOST: db
      DB_USER: ${DB_USER:-postgres}
      DB_PASSWORD: ${DB_PASSWORD:-secret}
      DB_NAME: ${DB_NAME:-appdb}
      REDIS_HOST: cache
      NODE_ENV: production
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_healthy
    networks:
      - public
      - backend
    restart: unless-stopped

  # PostgreSQL Database
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secret}
      POSTGRES_DB: ${DB_NAME:-appdb}
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  # Redis Cache
  cache:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    restart: unless-stopped

volumes:
  postgres-data:
  redis-data:

networks:
  public:
    driver: bridge
  backend:
    driver: bridge
    internal: true
EOF

# init.sql
cat > init.sql << 'EOF'
CREATE TABLE IF NOT EXISTS items (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO items (name, description) VALUES
  ('Docker', 'Containerization platform'),
  ('Kubernetes', 'Container orchestration'),
  ('DevOps', 'Development and Operations methodology');
EOF

# .env.example
cat > .env.example << 'EOF'
DB_USER=postgres
DB_PASSWORD=supersecret
DB_NAME=appdb
NODE_ENV=production
EOF

# .env (pour dev)
cat > .env << 'EOF'
DB_USER=postgres
DB_PASSWORD=secret
DB_NAME=appdb
NODE_ENV=development
EOF
```

---

## 📚 Partie 6 : Scripts Utilitaires

```bash
cd ~/docker-final-project

# Script de backup
cat > scripts/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p $BACKUP_DIR

echo "🔄 Backing up database..."
docker-compose exec -T db pg_dump -U postgres appdb > $BACKUP_DIR/db-$DATE.sql

echo "✅ Backup completed: $BACKUP_DIR/db-$DATE.sql"
EOF

chmod +x scripts/backup.sh

# Script de monitoring
cat > scripts/monitor.sh << 'EOF'
#!/bin/bash

echo "=== Docker Compose Services ==="
docker-compose ps

echo -e "\n=== Health Checks ==="
docker-compose ps --format json | jq -r '.[] | "\(.Service): \(.Health)"'

echo -e "\n=== Resource Usage ==="
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
EOF

chmod +x scripts/monitor.sh
```

---

## 📚 Partie 7 : Lancement et Tests

```bash
cd ~/docker-final-project

# Build et lancer
docker-compose up --build -d

# Attendre le démarrage
echo "⏳ Waiting for services to be healthy..."
sleep 15

# Vérifier les services
docker-compose ps

# Tester le backend directement
curl http://localhost:4000/api/health

# Tester via le proxy
curl http://localhost/api/health

# Tester le frontend
curl -I http://localhost/

# Voir les logs
docker-compose logs --tail=50

# Monitoring
./scripts/monitor.sh

# Backup
./scripts/backup.sh

# Ouvrir dans le navigateur: http://localhost
```

---

## ✅ Checklist de Validation

- [ ] Tous les services démarrent sans erreur
- [ ] Health checks sont verts
- [ ] Frontend accessible sur port 80
- [ ] Backend répond aux requêtes API
- [ ] Base de données persistante (survit au redémarrage)
- [ ] Cache Redis fonctionne
- [ ] Reverse proxy route correctement
- [ ] Multi-stage builds utilisés
- [ ] Images optimisées (< 200MB total)
- [ ] Volumes pour persistence
- [ ] Networks isolés correctement
- [ ] Logs accessibles
- [ ] Graceful shutdown fonctionne

---

## 🎯 Améliorations Avancées (Bonus)

### 1. HTTPS avec Let's Encrypt

```yaml
# Ajouter certbot
certbot:
  image: certbot/certbot
  volumes:
    - ./certbot/conf:/etc/letsencrypt
    - ./certbot/www:/var/www/certbot
```

### 2. Monitoring avec Prometheus

### 3. CI/CD avec GitHub Actions

### 4. Secrets Management

---

## 🎓 Ce Que Vous Avez Accompli

🎉 Félicitations ! Vous avez créé:
- ✅ Application full-stack production-ready
- ✅ Multi-stage optimized builds
- ✅ Reverse proxy avec Nginx
- ✅ Base de données persistante
- ✅ Cache Redis
- ✅ Docker Compose orchestration
- ✅ Health checks
- ✅ Networks isolés
- ✅ Scripts de backup/monitoring

---

## 📚 Ressources Complémentaires

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)
- [12-Factor App](https://12factor.net/)
