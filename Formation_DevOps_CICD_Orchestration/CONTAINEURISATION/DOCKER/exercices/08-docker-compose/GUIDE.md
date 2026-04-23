# 🎼 Exercice 08 : Docker Compose - L'Orchestre

## 🎯 Objectif
Gérer plusieurs containers comme une seule application avec docker-compose.yml.

## 💡 L'Analogie : Le Chef d'Orchestre
*   **docker-compose.yml** = La **partition musicale** complète
*   **Services** = Les **musiciens** (violon, piano, batterie)
*   **`docker-compose up`** = Le chef dit **"Tout le monde joue!"**
*   **`docker-compose down`** = Le chef dit **"On arrête!"**
*   **Networks/Volumes** = La **salle de concert** et les **coulisses** partagées

## 🗺️ Roadmap & Étapes

### Étape 1 : Le Problème (Trop de Commandes)
Sans Compose :
```bash
docker network create myapp
docker volume create dbdata
docker run -d --name db --network myapp -v dbdata:/data postgres
docker run -d --name api --network myapp -p 3000:3000 myapi
docker run -d --name web --network myapp -p 80:80 nginx
```

**3 commandes, facile d'oublier une option !**

### Étape 2 : La Solution (docker-compose.yml)
```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
    volumes:
      - dbdata:/var/lib/postgresql/data
    networks:
      - backend

  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://postgres:secret@db:5432/myapp
    depends_on:
      - db
    networks:
      - frontend
      - backend

  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - api
    networks:
      - frontend

volumes:
  dbdata:

networks:
  frontend:
  backend:
```

**Une seule commande :**
```bash
docker-compose up -d
```

**Analogie :** Au lieu de dire à chaque musicien quoi jouer, vous donnez la partition au chef et il s'occupe de tout.

### Étape 3 : Commandes Essentielles
```bash
# Démarrer tous les services
docker-compose up

# En background
docker-compose up -d

# Rebuild les images avant de démarrer
docker-compose up --build

# Voir les logs
docker-compose logs

# Logs d'un seul service
docker-compose logs api

# Suivre les logs en temps réel
docker-compose logs -f

# Arrêter tout
docker-compose down

# Arrêter + supprimer volumes
docker-compose down -v

# Voir les services actifs
docker-compose ps

# Exécuter une commande
docker-compose exec api bash

# Scaling
docker-compose up -d --scale api=3
```

### Étape 4 : Variables d'Environnement (.env)
**.env :**
```env
POSTGRES_PASSWORD=supersecret
API_PORT=3000
NODE_ENV=production
```

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  api:
    build: ./api
    ports:
      - "${API_PORT}:3000"
    environment:
      NODE_ENV: ${NODE_ENV}
      DB_PASS: ${POSTGRES_PASSWORD}
```

### Étape 5 : Build Context
```yaml
services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.prod
      args:
        - VERSION=1.0
    ports:
      - "3000:3000"
```

### Étape 6 : Health Checks
```yaml
services:
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  api:
    depends_on:
      db:
        condition: service_healthy
```

**Analogie :** L'API attend que la DB soit vraiment prête avant de commencer à jouer.

### Étape 7 : Profils (dev vs prod)
```yaml
services:
  debug:
    image: nicolaka/netshoot
    profiles: ["debug"]
    command: sleep infinity

  monitoring:
    image: prom/prometheus
    profiles: ["prod"]
```

```bash
# Dev (sans debug/monitoring)
docker-compose up

# Avec debug
docker-compose --profile debug up

# Prod
docker-compose --profile prod up
```

## ✅ Exercice Complet
Stack WordPress complète :

**docker-compose.yml :**
```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wp_data:/var/www/html
    depends_on:
      - mysql
    networks:
      - wpnetwork

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - wpnetwork

volumes:
  wp_data:
  mysql_data:

networks:
  wpnetwork:
```

**Utilisation :**
```bash
# Démarrer
docker-compose up -d

# Visiter http://localhost:8080

# Logs
docker-compose logs -f wordpress

# Arrêter
docker-compose down

# Tout supprimer (ATTENTION: données perdues)
docker-compose down -v
```

## ➡️ Prochaine Étape
[Exercice 09 : Multi-stage Builds](../09-multistage/GUIDE.md)

**Ce que vous avez compris :**
Docker Compose est le chef d'orchestre : un seul fichier YAML, une seule commande, et toute votre stack démarre proprement avec networks, volumes et dépendances gérées automatiquement !
