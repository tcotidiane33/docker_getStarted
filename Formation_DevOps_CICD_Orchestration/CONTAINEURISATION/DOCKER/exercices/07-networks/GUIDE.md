# 🌐 Exercice 07 : Networks - La Communication

## 🎯 Objectif
Faire communiquer les containers entre eux de manière sécurisée.

## 💡 L'Analogie : Les Bâtiments et les Quartiers
*   **Network bridge** = Un **quartier résidentiel**. Les maisons peuvent se parler.
*   **Container** = Une **maison** dans le quartier
*   **Network name** = L'**adresse du quartier** (vous pouvez appeler "maison-db" au lieu de "192.168.1.54")
*   **Network isolé** = **Mur entre quartiers**. Le quartier A ne voit pas le quartier B.
*   **Port exposure** = **Ouvrir une fenêtre** vers l'extérieur du quartier

## 🗺️ Roadmap & Étapes

### Étape 1 : Le Problème (Isolation par Défaut)
```bash
# Container 1
docker run -d --name db1 postgres

# Container 2 essaie de ping db1
docker run --rm busybox ping db1
# ERROR: bad address 'db1'
```

**Pourquoi ?** Ils sont dans des quartiers différents (networks différents).

### Étape 2 : Créer un Quartier (Network)
```bash
# Créer un network
docker network create mon-reseau

# Lister les networks
docker network ls

# Détails
docker network inspect mon-reseau
```

### Étape 3 : Mettre les Containers dans le Même Quartier
```bash
# Container 1 dans mon-reseau
docker run -d --name db \
  --network mon-reseau \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0

# Container 2 dans mon-reseau
docker run --rm \
  --network mon-reseau \
  busybox ping db

# ✅ ÇA MARCHE ! Ils se voient par leur nom.
```

**Analogie :** Les deux maisons sont dans le même quartier. Elles peuvent se parler.

### Étape 4 : App + Database (Exemple Réel)
```bash
# Network
docker network create app-network

# Database
docker run -d --name postgres \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=myapp \
  postgres

# App (connecte à "postgres" pas à une IP !)
docker run -d --name backend \
  --network app-network \
  -e DATABASE_URL=postgresql://postgres:secret@postgres:5432/myapp \
  -p 3000:3000 \
  myapp

# L'app peut parler à la DB via le nom "postgres" !
```

**Analogie :** L'app demande "Où habite postgres ?" et Docker répond automatiquement.

### Étape 5 : Connecter un Container à Plusieurs Networks
```bash
docker network create frontend
docker network create backend

# Base de données (seulement backend)
docker run -d --name db \
  --network backend \
  postgres

# API (frontend ET backend)
docker run -d --name api \
  --network backend \
  myapi

docker network connect frontend api

# Frontend (seulement frontend)
docker run -d --name web \
  --network frontend \
  -p 80:80 \
  nginx

# Résultat :
# - web peut parler à api (frontend)
# - api peut parler à db (backend)
# - web NE PEUT PAS parler à db directement ✅ Sécurité !
```

**Analogie :** L'API a une maison dans deux quartiers. Elle peut aller de l'un à l'autre. Le frontend et la DB ne se voient jamais.

### Étape 6 : Type de Networks

**Bridge (Par défaut) :**
```bash
docker network create --driver bridge mon-bridge
# Containers sur la même machine
```

**Host (Pas d'isolation) :**
```bash
docker run --network host nginx
# Le container utilise DIRECTEMENT le réseau de l'hôte
# Port 80 du container = Port 80 de l'hôte
```

**None (Aucun réseau) :**
```bash
docker run --network none busybox
# Container isolé totalement (pas d'internet)
```

### Étape 7 : DNS Automatique
```bash
docker network create mynet

docker run -d --name server1 --network mynet nginx
docker run -d --name server2 --network mynet nginx

# Depuis server1, ping server2
docker exec server1 ping server2
# ✅ Fonctionne ! Docker fait le DNS automatiquement.
```

### Étape 8 : Inspecter la Communication
```bash
# Voir quels containers sont dans le network
docker network inspect mon-reseau

# Voir les networks d'un container
docker inspect db | grep -A 10 Networks
```

## ✅ Exercice Complet
Architecture 3-tiers complète :

```bash
# 1. Créer les quartiers
docker network create frontend-net
docker network create backend-net

# 2. Base de données (seulement backend)
docker run -d --name postgres \
  --network backend-net \
  -e POSTGRES_PASSWORD=secret \
  postgres

# 3. API (backend ET frontend)
docker run -d --name api \
  --network backend-net \
  -e DB_HOST=postgres \
  myapi

docker network connect frontend-net api

# 4. Frontend (seulement frontend)
docker run -d --name nginx \
  --network frontend-net \
  -p 80:80 \
  mynginx

# 5. Test isolation
docker exec nginx ping api        # ✅ Fonctionne
docker exec nginx ping postgres   # ❌ Ne fonctionne PAS (sécurité)

# 6. Nettoyer
docker rm -f postgres api nginx
docker network rm frontend-net backend-net
```

## ➡️ Prochaine Étape
[Exercice 08 : Docker Compose](../08-docker-compose/GUIDE.md)

**Ce que vous avez compris :**
Les networks sont des quartiers : les containers dans le même quartier peuvent se parler par leur nom. Vous pouvez créer plusieurs quartiers pour isoler (frontend/backend) et sécuriser votre architecture !
