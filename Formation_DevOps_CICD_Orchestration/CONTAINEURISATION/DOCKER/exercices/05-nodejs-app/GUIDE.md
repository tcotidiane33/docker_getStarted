# 🚀 Exercice 05 : Application Node.js Complète

## 🎯 Objectif
Dockeriser une vraie application web avec toutes les bonnes pratiques.

## 💡 L'Analogie : L'Emballage de Boutique
*   **App non-dockerisée** = Produit en vrac (fonctionne chez vous, seulement)
*   **App dockerisée** = Produit **emballé professionnellement** (fonctionne partout)
*   **Dependencies** = Les **accessoires** fournis dans la boîte
*   **Hot reload** = La **vitre transparente** pour voir l'intérieur sans ouvrir

## 🗺️ Roadmap & Étapes

### Étape 1 : L'Application de Base
**package.json :**
```json
{
  "name": "todo-api",
  "version": "1.0.0",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
```

**server.js :**
```javascript
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

let todos = [
  { id: 1, title: 'Apprendre Docker', done: false },
  { id: 2, title: 'Maîtriser les containers', done: false }
];

app.get('/api/todos', (req, res) => {
  res.json(todos);
});

app.post('/api/todos', (req, res) => {
  const todo = { id: Date.now(), ...req.body };
  todos.push(todo);
  res.json(todo);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Étape 2 : Dockerfile Production
```dockerfile
FROM node:18-alpine

# Créer utilisateur non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copier et installer deps en tant que root
COPY package*.json ./
RUN npm ci --only=production

# Copier le code
COPY server.js ./

# Changer propriétaire
RUN chown -R appuser:appgroup /app

# Passer en non-root
USER appuser

EXPOSE 3000

CMD ["npm", "start"]
```

### Étape 3 : Dockerfile Development (Hot Reload)
```dockerfile
# Dockerfile.dev
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install  # Toutes les deps (y compris dev)

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

**Utilisation :**
```bash
# Build dev
docker build -f Dockerfile.dev -t myapp:dev .

# Run avec hot reload (volume monté)
docker run -d \
  -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  --name myapp-dev \
  myapp:dev

# Modifier server.js → L'app recharge automatiquement !
```

**Analogie :** Le volume c'est comme une vitre : vous voyez les changements sans avoir à reconstruire la boîte.

### Étape 4 : .dockerignore Optimisé
```.dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
Dockerfile
Dockerfile.dev
.dockerignore
```

### Étape 5 : Variables d'Environnement
```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY server.js ./

# Valeur par défaut
ENV PORT=3000
ENV NODE_ENV=production

EXPOSE ${PORT}

CMD ["npm", "start"]
```

**Run avec override :**
```bash
docker run -d \
  -p 8080:3000 \
  -e PORT=3000 \
  -e NODE_ENV=development \
  myapp
```

### Étape 6 : Health Check
```dockerfile
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY server.js ./

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/todos', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

CMD ["npm", "start"]
```

**Vérifier :**
```bash
docker ps
# STATUS: Up X seconds (healthy)
```

## ✅ Exercice Complet
Créez une API avec 2 environnements :

**1. Build les images :**
```bash
# Production
docker build -t todoapi:prod .

# Development
docker build -f Dockerfile.dev -t todoapi:dev .
```

**2. Test Production :**
```bash
docker run -d -p 3000:3000 --name todo-prod todoapi:prod

curl http://localhost:3000/api/todos

curl -X POST http://localhost:3000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Docker","done":false}'

docker logs todo-prod
docker rm -f todo-prod
```

**3. Test Development :**
```bash
docker run -d \
  -p 3000:3000 \
  -v $(pwd):/app \
  -v /app/node_modules \
  --name todo-dev \
  todoapi:dev

# Modifier server.js et voir le reload automatique
docker logs -f todo-dev

docker rm -f todo-dev
```

## ➡️ Prochaine Étape
[Exercice 06 : Volumes](../06-volumes/GUIDE.md)

**Ce que vous avez compris :**
Dockeriser une app c'est l'emballer proprement : toutes les dépendances incluses, configuration flexible, et deux modes (dev avec hot reload, prod optimisé) !
