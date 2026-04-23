# Exercice 08 : Docker Compose - Orchestration Multi-Containers

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer un fichier docker-compose.yml
- ✅ Orchestrer plusieurs services
- ✅ Gérer les dépendances entre services
- ✅ Utiliser des variables d'environnement
- ✅ Scaler des services
- ✅ Déployer des stacks complètes

## ⏱️ Durée Estimée
**2 heures**

## 📋 Prérequis
- [Exercice 07 : Networks](../07-networks/README.md) complété

---

## 📚 Partie 1 : Premier docker-compose.yml

```bash
mkdir -p ~/docker-exercices/compose-intro
cd ~/docker-exercices/compose-intro

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
EOF

# Créer le contenu
mkdir html
echo "<h1>Hello Docker Compose!</h1>" > html/index.html

# Lancer
docker-compose up

# Dans un autre terminal - tester
curl http://localhost:8080

# Arrêter (Ctrl+C puis)
docker-compose down
```

---

## 📚 Partie 2 : Stack Web + Database

```bash
mkdir -p ~/docker-exercices/compose-stack
cd ~/docker-exercices/compose-stack

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/usr/share/nginx/html:ro
    depends_on:
      - db
    networks:
      - frontend

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb
    volumes:
      - db-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend

volumes:
  db-data:

networks:
  frontend:
  backend:
EOF

# Créer les fichiers
mkdir html

cat > html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>App with DB</title></head>
<body>
  <h1>🐳 Docker Compose Stack</h1>
  <p>Web + Database</p>
</body>
</html>
EOF

cat > init.sql << 'EOF'
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO users (username, email) VALUES
  ('alice', 'alice@example.com'),
  ('bob', 'bob@example.com');
EOF

# Lancer en background
docker-compose up -d

# Vérifier les services
docker-compose ps

# Voir les logs
docker-compose logs

# Logs d'un service spécifique
docker-compose logs db

# Follow logs
docker-compose logs -f web

# Tester la DB
docker-compose exec db psql -U admin -d appdb -c "SELECT * FROM users;"

# Arrêter
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v
```

---

## 📚 Partie 3 : Application Full-Stack

```bash
mkdir -p ~/docker-exercices/fullstack-app
cd ~/docker-exercices/fullstack-app

# Structure
mkdir -p frontend backend

# Backend: API Node.js
cat > backend/package.json << 'EOF'
{
  "name": "api",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.0",
    "redis": "^4.6.7"
  }
}
EOF

cat > backend/server.js << 'EOF'
const express = require('express');
const { Pool } = require('pg');
const redis = require('redis');

const app = express();
app.use(express.json());

// PostgreSQL client
const pool = new Pool({
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'secret',
  database: process.env.DB_NAME || 'appdb',
  port: 5432
});

// Redis client
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST || 'cache'}:6379`
});
redisClient.connect();

app.get('/api/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date() });
});

app.get('/api/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/visits', async (req, res) => {
  const visits = await redisClient.incr('visits');
  res.json({ visits });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`API running on port ${PORT}`);
});
EOF

cat > backend/Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY server.js ./
EXPOSE 4000
CMD ["node", "server.js"]
EOF

# Frontend: Simple HTML
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>Full Stack App</title>
  <style>
    body { font-family: Arial; max-width: 800px; margin: 50px auto; }
    button { padding: 10px 20px; margin: 10px; cursor: pointer; }
    #result { background: #f4f4f4; padding: 20px; margin: 20px 0; }
  </style>
</head>
<body>
  <h1>🚀 Full Stack Docker App</h1>
  
  <div>
    <button onclick="checkHealth()">Check API Health</button>
    <button onclick="getUsers()">Get Users</button>
    <button onclick="incrementVisits()">Increment Visits</button>
  </div>
  
  <div id="result"></div>
  
  <script>
    const API_URL = 'http://localhost:4000';
    
    async function checkHealth() {
      const res = await fetch(`${API_URL}/api/health`);
      const data = await res.json();
      document.getElementById('result').innerText = JSON.stringify(data, null, 2);
    }
    
    async function getUsers() {
      const res = await fetch(`${API_URL}/api/users`);
      const data = await res.json();
      document.getElementById('result').innerText = JSON.stringify(data, null, 2);
    }
    
    async function incrementVisits() {
      const res = await fetch(`${API_URL}/api/visits`);
      const data = await res.json();
      document.getElementById('result').innerText = JSON.stringify(data, null, 2);
    }
  </script>
</body>
</html>
EOF

cat > frontend/Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EOF

# Docker Compose
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - app-network

  backend:
    build: ./backend
    ports:
      - "4000:4000"
    environment:
      DB_HOST: db
      DB_USER: postgres
      DB_PASSWORD: secret
      DB_NAME: appdb
      REDIS_HOST: cache
    depends_on:
      - db
      - cache
    networks:
      - app-network
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
EOF

# Init SQL
cat > init.sql << 'EOF'
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(100)
);

INSERT INTO users (username, email) VALUES
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com'),
  ('Charlie', 'charlie@example.com');
EOF

# Build et lancer
docker-compose up --build -d

# Attendre que tout démarre
sleep 10

# Tester
echo "=== Frontend ==="
curl -I http://localhost

echo "=== API Health ==="
curl http://localhost:4000/api/health

echo "=== Get Users ==="
curl http://localhost:4000/api/users

echo "=== Visits ==="
for i in {1..5}; do
  curl http://localhost:4000/api/visits
done

# Voir les logs
docker-compose logs --tail=20

# Cleanup
docker-compose down -v
```

---

## 📚 Partie 4 : Variables d'Environnement

```bash
mkdir -p ~/docker-exercices/compose-env
cd ~/docker-exercices/compose-env

# .env file
cat > .env << 'EOF'
# Database
POSTGRES_USER=admin
POSTGRES_PASSWORD=supersecret
POSTGRES_DB=proddb

# Application
APP_ENV=production
APP_PORT=3000
DEBUG=false
EOF

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    image: node:18-alpine
    command: sh -c "echo Environment: $$APP_ENV && sleep 3600"
    environment:
      - APP_ENV=${APP_ENV}
      - DEBUG=${DEBUG}
    ports:
      - "${APP_PORT}:3000"

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
EOF

# Lancer
docker-compose up -d

# Vérifier les variables
docker-compose exec app env | grep APP

# Override avec fichier différent
cat > .env.dev << 'EOF'
APP_ENV=development
APP_PORT=8080
DEBUG=true
EOF

docker-compose --env-file .env.dev up -d
```

---

## 📚 Partie 5 : Scaling Services

```bash
mkdir -p ~/docker-exercices/compose-scale
cd ~/docker-exercices/compose-scale

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    depends_on:
      - api

  api:
    image: node:18-alpine
    command: sh -c "echo API instance \$\$HOSTNAME running && node -e 'require(\"http\").createServer((req,res) => res.end(\"API: \" + process.env.HOSTNAME)).listen(3000)'"
    expose:
      - "3000"
    deploy:
      replicas: 3
EOF

# Scale le service
docker-compose up -d --scale api=5

# Voir les instances
docker-compose ps

# Vérifier
for i in {1..10}; do
  docker-compose exec --index=1 api hostname
done
```

---

## 📚 Partie 6 : Override Files

```bash
# Base: docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    image: nginx:alpine
    volumes:
      - ./html:/usr/share/nginx/html:ro
EOF

# Development override
cat > docker-compose.override.yml << 'EOF'
version: '3.8'

services:
  app:
    ports:
      - "8080:80"
    environment:
      - ENV=development
EOF

# Production override
cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  app:
    ports:
      - "80:80"
    environment:
      - ENV=production
    restart: always
EOF

# Development (utilise override par défaut)
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## ✅ Exercice de Validation

Créez une stack WordPress complète :

<details>
<summary>Solution</summary>

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wp-content:/var/www/html
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: mysql:8
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - db-data:/var/lib/mysql
    restart: unless-stopped

volumes:
  wp-content:
  db-data:
```
</details>

---

## 🎯 Défis Avancés

### Défi 1 : Healthchecks

Ajoutez des healthchecks à tous les services.

### Défi 2 : Secrets

Utilisez Docker secrets au lieu de variables d'environnement.

### Défi 3 : Profiles

```yaml
services:
  app:
    profiles: ["backend"]
  
  db:
    profiles: ["backend", "full"]

# Lancer avec profil
docker-compose --profile backend up
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ docker-compose.yml structure
- ✅ Multi-services orchestration
- ✅ Networks et volumes
- ✅ Environment variables
- ✅ Scaling
- ✅ Override files

---

## ➡️ Prochaine Étape

[Exercice 09 : Multi-Stage Builds](../09-multistage/README.md)

---

## 📚 Ressources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)
