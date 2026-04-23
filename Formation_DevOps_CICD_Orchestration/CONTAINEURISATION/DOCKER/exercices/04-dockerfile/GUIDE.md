# 📝 Exercice 04 : Dockerfile - Votre Première Recette

## 🎯 Objectif
Créer vos propres images Docker avec un Dockerfile.

## 💡 L'Analogie : La Recette de Cuisine
*   **Dockerfile** = Une **recette de cuisine** détaillée
*   **FROM** = L'**ingrédient de base** (farine, ou gâteau déjà fait)
*   **RUN** = Les **étapes de préparation** (mélanger, cuire)
*   **COPY** = **Ajouter des ingrédients** de votre cuisine
*   **CMD** = Ce qu'on fait **quand le plat est servi** (déguster !)
*   **docker build** = **Suivre la recette** pour créer le plat

## 🗺️ Roadmap & Étapes

### Étape 1 : La Recette la Plus Simple
```dockerfile
# Dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y cowsay

CMD ["/usr/games/cowsay", "Hello Docker!"]
```

```bash
# Suivre la recette (build)
docker build -t mon-image .

# Servir le plat (run)
docker run mon-image
```

**Analogie :** Vous partez d'Ubuntu (la farine de base), vous installez cowsay (vous ajoutez du chocolat), et quand on sert le plat, il dit "Hello Docker!".

### Étape 2 : Comprendre les Layers (Couches)
```dockerfile
FROM ubuntu:22.04

# Layer 1
RUN apt-get update

# Layer 2
RUN apt-get install -y curl

# Layer 3  
RUN apt-get install -y vim
```

**Problème :** 3 layers = 3 étapes = cache inefficace

**Solution :** Combiner !
```dockerfile
FROM ubuntu:22.04

# Un seul layer
RUN apt-get update && \
    apt-get install -y \
        curl \
        vim \
    && rm -rf /var/lib/apt/lists/*
```

**Analogie :** Au lieu de cuisiner 3 fois séparément, vous faites tout d'un coup. Plus rapide et moins de vaisselle !

### Étape 3 : Application Web Réelle (Python)
```dockerfile
# 1. Ingrédient de base
FROM python:3.11-slim

# 2. Zone de travail
WORKDIR /app

# 3. Copier la liste des courses (requirements)
COPY requirements.txt .

# 4. Faire les courses (installer dépendances)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copier le code
COPY app.py .

# 6. Ouvrir la porte 5000
EXPOSE 5000

# 7. Démarrer l'app quand on sert
CMD ["python", "app.py"]
```

**Fichier `app.py` :**
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```
 
**Fichier `requirements.txt` :**
```
flask==2.3.0
```

**Build et Run :**
```bash
docker build -t myapp .
docker run -d -p 5000:5000 --name webapp myapp
curl http://localhost:5000
```

### Étape 4 : .dockerignore (Ne Pas Tout Copier)
```.dockerignore
# Ignorer les dépendances (on les installe dans le container)
__pycache__/
*.pyc
venv/
node_modules/

# Ignorer les fichiers de config locale
.env
.git/
README.md
```

**Analogie :** Vous ne mettez pas TOUTE votre cuisine dans le plat. Juste les bons ingrédients !

### Étape 5 : Instructions Avancées

**ENV (Variables d'Environnement)**
```dockerfile
FROM python:3.11-slim

ENV APP_ENV=production
ENV PORT=5000

CMD python app.py --port $PORT
```

**ARG (Arguments de Build)**
```dockerfile
FROM python:3.11-slim

ARG VERSION=1.0
LABEL version=$VERSION

RUN echo "Building version $VERSION"
```

```bash
docker build --build-arg VERSION=2.0 -t myapp:2.0 .
```

**USER (Sécurité !)**
```dockerfile
FROM python:3.11-slim

# Créer un utilisateur non-root
RUN useradd -m -u 1000 appuser

# Changer de propriétaire
WORKDIR /app
COPY --chown=appuser:appuser . .

# Passer en utilisateur non-root
USER appuser

CMD ["python", "app.py"]
```

**Analogie :** Ne pas cuisiner en tant que root, c'est comme ne pas donner les clés de la cuisine au stagiaire !

### Étape 6 : Best Practices Checklist
```dockerfile
# ✅ Image de base légère
FROM python:3.11-slim

# ✅ Version fixe (pas :latest)
# FROM python:latest ❌

# ✅ Copier requirements AVANT le code (cache)
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# ❌ Mauvais ordre
# COPY . .
# RUN pip install -r requirements.txt

# ✅ Nettoyer le cache
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# ✅ User non-root
USER appuser

# ✅ CMD en format exec (liste)
CMD ["python", "app.py"]

# ❌ CMD en format shell
# CMD python app.py
```

## ✅ Exercice Complet
Créez une app Node.js dockerisée :

**app.js :**
```javascript
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from Node.js in Docker!');
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
```

**package.json :**
```json
{
  "name": "docker-node-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

**Dockerfile :**
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY app.js .

EXPOSE 3000

CMD ["node", "app.js"]
```

**Test :**
```bash
docker build -t nodeapp .
docker run -d -p 3000:3000 --name mynodeapp nodeapp
curl http://localhost:3000
docker logs mynodeapp
docker rm -f mynodeapp
```

## ➡️ Prochaine Étape
[Exercice 05 : Application Node.js Complète](../05-nodejs-app/GUIDE.md)

**Ce que vous avez compris :**
Un Dockerfile est une recette : vous listez les ingrédients (FROM), les étapes de préparation (RUN, COPY), et ce qu'il faut faire quand c'est prêt (CMD) !
