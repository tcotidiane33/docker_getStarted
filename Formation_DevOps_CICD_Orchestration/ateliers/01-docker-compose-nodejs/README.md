# Atelier 1 : Conteneurisation d'une App Node.js avec Docker Compose

**Durée estimée :** 45 minutes  
**Type :** Docker & Docker Compose

## 🎯 Objectif
Savoir isoler une application dans un conteneur reproductible grâce à un `Dockerfile` optimisé (multi-stage) et la faire communiquer avec une base de données locale via `docker-compose.yml`.

---

## 🛠️ Instructions

### Étape 1 : Le code de l'application
Créez un dossier de travail. Dedans, créez un fichier `server.js` rudimentaire (Node.js) :
```javascript
const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello DevOps World!\n');
});

server.listen(port, () => {
  console.log(`Server running at port ${port}/`);
});
```

### Étape 2 : Le Dockerfile
Créez un fichier nommé `Dockerfile` au même niveau :
1. Utilisez une image de base officielle Node.js légère (ex: `node:20-alpine`).
2. Définissez le répertoire de travail (`WORKDIR`).
3. Copiez vos fichiers source (`COPY`).
4. (S'il y avait un `package.json`, vous feriez un `RUN npm install` ici).
5. Exposez le port 3000.
6. Définissez la commande de démarrage (`CMD ["node", "server.js"]`).

*Testez votre image :*
```bash
docker build -t my-node-app:1.0 .
docker run -p 3000:3000 my-node-app:1.0
```

### Étape 3 : Docker Compose (Microservices)
Nous voulons ajouter une base de données Redis à côté de notre application.
Plutôt que lancer les requêtes manuellement, utilisons Docker Compose.

Créez un fichier `docker-compose.yml` :
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
  
  cache:
    image: redis:alpine
    ports:
      - "6379:6379"
```

*Démarrez la stack :*
```bash
docker-compose up -d
```
Vérifiez que les deux conteneurs tournent avec `docker-compose ps`.

---

## 📝 Livrable attendu
- Un `Dockerfile` fonctionnel basé sur Alpine.
- Un `docker-compose.yml` déclenchant simultanément l'app et une base Redis isolées mais capables de communiquer sur le même réseau virtuel (par défaut).
