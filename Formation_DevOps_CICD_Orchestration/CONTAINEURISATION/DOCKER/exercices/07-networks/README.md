# Exercice 07 : Docker Networks - Communication entre Containers

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer et gérer des networks Docker
- ✅ Comprendre les différents drivers (bridge, host, none)
- ✅ Connecter des containers entre eux
- ✅ Isoler des containers sur des networks différents
- ✅ Débugger la connectivité réseau

## ⏱️ Durée Estimée
**1 heure 30 minutes**

## 📋 Prérequis
- [Exercice 06 : Volumes](../06-volumes/README.md) complété

---

## 📚 Partie 1 : Networks par Défaut

```bash
# Lister les networks par défaut
docker network ls

# Vous verrez 3 networks:
# - bridge (défaut pour containers)
# - host (partage le réseau de l'hôte)
# - none (pas de réseau)

# Inspecter le network bridge
docker network inspect bridge
```

---

## 📚 Partie 2 : Bridge Network (User-Defined)

### 2.1 Créer un Network Custom

```bash
# Créer un network
docker network create mon-network

# Avec options
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  --ip-range 172.20.240.0/20 \
  app-network

# Lister
docker network ls

# Inspecter
docker network inspect app-network
```

### 2.2 Connecter des Containers

```bash
# Lancer des containers sur le même network
docker run -d \
  --name web \
  --network app-network \
  nginx:alpine

docker run -d \
  --name db \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:15-alpine

# Les containers peuvent communiquer par leur nom!
docker exec web ping -c 3 db
docker exec db ping -c 3 web

# Résolution DNS automatique
docker exec web nslookup db
```

### 2.3 IP Statique

```bash
# Assigner une IP fixe
docker run -d \
  --name api \
  --network app-network \
  --ip 172.20.0.10 \
  nginx:alpine

# Vérifier
docker inspect api | grep IPAddress
```

---

## 📚 Partie 3 : Communication Multi-Containers

### 3.1 Stack Web → API → DB

```bash
# Créer les networks
docker network create frontend
docker network create backend

# Database (backend seulement)
docker run -d \
  --name database \
  --network backend \
  -e POSTGRES_PASSWORD=dbpass \
  postgres:15-alpine

# API (frontend + backend)
docker run -d \
  --name api-server \
  --network backend \
  nginx:alpine

docker network connect frontend api-server

# Web (frontend seulement)
docker run -d \
  --name web-server \
  --network frontend \
  -p 8080:80 \
  nginx:alpine

# Vérifier la connectivité
echo "Web → API"
docker exec web-server ping -c 2 api-server

echo "API → Database"
docker exec api-server ping -c 2 database

echo "Web → Database (devrait échouer)"
docker exec web-server ping -c 2 database || echo "✅ Isolation réussie!"
```

### 3.2 Application Complète

```bash
mkdir -p ~/docker-exercices/app-network
cd ~/docker-exercices/app-network

# Créer les networks
docker network create app-frontend
docker network create app-backend

# 1. PostgreSQL (backend only)
docker run -d \
  --name app-db \
  --network app-backend \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=appdb \
  postgres:15-alpine

# 2. Redis Cache (backend only)
docker run -d \
  --name app-cache \
  --network app-backend \
  redis:alpine

# 3. API Backend (both networks)
docker run -d \
  --name app-api \
  --network app-backend \
  -e DATABASE_URL=postgresql://postgres:secret@app-db:5432/appdb \
  -e REDIS_URL=redis://app-cache:6379 \
  nginx:alpine

docker network connect app-frontend app-api

# 4. Frontend (frontend only)
docker run -d \
  --name app-web \
  --network app-frontend \
  -p 80:80 \
  nginx:alpine

# Test connectivity
echo "=== Frontend → API ==="
docker exec app-web ping -c 2 app-api

echo "=== API → Database ==="
docker exec app-api ping -c 2 app-db

echo "=== API → Cache ==="
docker exec app-api ping -c 2 app-cache

echo "=== Frontend → Database (should fail) ==="
docker exec app-web ping -c 2 app-db 2>/dev/null || echo "✅ Correctly isolated!"
```

---

## 📚 Partie 4 : Drivers de Network

### 4.1 Bridge (Défaut)

```bash
# Network bridge isolé
docker network create --driver bridge isolated-net

docker run -d --name container1 --network isolated-net alpine sleep 3600
docker run -d --name container2 --network isolated-net alpine sleep 3600

# Communication interne
docker exec container1 ping -c 2 container2
```

### 4.2 Host Network

```bash
# Partage le réseau de l'hôte (pas d'isolation)
docker run -d \
  --name nginx-host \
  --network host \
  nginx:alpine

# Accessible directement sur le port 80 de l'hôte
curl http://localhost

# ⚠️ Attention: Pas de port mapping avec --network host!
```

### 4.3 None Network

```bash
# Container complètement isolé (pas de réseau)
docker run -d \
  --name isolated \
  --network none \
  alpine sleep 3600

# Pas d'interface réseau (sauf loopback)
docker exec isolated ip addr
```

---

## 📚 Partie 5 : Alias et Discovery

### 5.1 Network Aliases

```bash
docker network create alias-net

# Container avec plusieurs alias
docker run -d \
  --name server1 \
  --network alias-net \
  --network-alias api \
  --network-alias backend \
  nginx:alpine

# Accessible par tous les alias
docker run --rm \
  --network alias-net \
  alpine ping -c 2 server1

docker run --rm \
  --network alias-net \
  alpine ping -c 2 api

docker run --rm \
  --network alias-net \
  alpine ping -c 2 backend
```

### 5.2 Round-Robin DNS

```bash
# Plusieurs containers avec le même alias
docker run -d --name api1 --network alias-net --network-alias api nginx:alpine
docker run -d --name api2 --network alias-net --network-alias api nginx:alpine
docker run -d --name api3 --network alias-net --network-alias api nginx:alpine

# DNS round-robin automatique
docker run --rm --network alias-net alpine nslookup api

# Test de load balancing basique
for i in {1..10}; do
  docker run --rm --network alias-net alpine nslookup api | grep Address
done
```

---

## 📚 Partie 6 : Debugging Réseau

### 6.1 Inspection

```bash
# Voir tous les containers d'un network
docker network inspect app-backend --format='{{range .Containers}}{{.Name}} - {{.IPv4Address}}{{"\n"}}{{end}}'

# Voir les networks d'un container
docker inspect app-api --format='{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{"\n"}}{{end}}'
```

### 6.2 Test de Connectivité

```bash
# Container de debug avec outils réseau
docker run -it --rm \
  --network app-backend \
  nicolaka/netshoot

# Inside container:
# ping app-db
# nslookup app-db
# curl app-db:5432
# netstat -tulpn
```

### 6.3 Sniffer le Trafic

```bash
# Capturer le trafic
docker run -it --rm \
  --network app-backend \
  --cap-add=NET_ADMIN \
  nicolaka/netshoot \
  tcpdump -i eth0
```

---

## 📚 Partie 7 : Projet Pratique - Microservices

```bash
mkdir -p ~/docker-exercices/microservices
cd ~/docker-exercices/microservices

# Create networks
docker network create public
docker network create private

# 1. Frontend Service
cat > frontend.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Microservices</title></head>
<body>
  <h1>🔷 Frontend Service</h1>
  <p>Calls → API Gateway → Backend Services</p>
</body>
</html>
EOF

docker run -d \
  --name frontend \
  --network public \
  -p 8080:80 \
  -v $(pwd)/frontend.html:/usr/share/nginx/html/index.html:ro \
  nginx:alpine

# 2. API Gateway (public + private)
docker run -d \
  --name gateway \
  --network public \
  nginx:alpine

docker network connect private gateway

# 3. User Service (private only)
docker run -d \
  --name user-service \
  --network private \
  --network-alias users \
  nginx:alpine

# 4. Order Service (private only)
docker run -d \
  --name order-service \
  --network private \
  --network-alias orders \
  nginx:alpine

# 5. Database (private only)
docker run -d \
  --name microdb \
  --network private \
  -e POSTGRES_PASSWORD=secret \
  postgres:15-alpine

# Test architecture
echo "=== PUBLIC ACCESS ==="
curl -I http://localhost:8080

echo "=== GATEWAY → SERVICES ==="
docker exec gateway ping -c 2 users
docker exec gateway ping -c 2 orders
docker exec gateway ping -c 2 microdb

echo "=== FRONTEND → GATEWAY ==="
docker exec frontend ping -c 2 gateway

echo "=== FRONTEND → SERVICES (should fail) ==="
docker exec frontend ping -c 2 users 2>/dev/null || echo "✅ Correctly isolated!"

# Cleanup
docker stop frontend gateway user-service order-service microdb
docker rm frontend gateway user-service order-service microdb
docker network rm public private
```

---

## ✅ Exercice de Validation

Créez une architecture 3-tiers:

```
Internet (port 80)
    ↓
[ Web Server ] ← public network →
    ↓
[ API Server ] ← app network →
    ↓
[ Database ] ← data network (isolated)
```

**Contraintes:**
- Web ne peut PAS accéder à Database directement
- API doit accéder à Web ET Database
- Database complètement isolée d'Internet

<details>
<summary>Solution</summary>

```bash
docker network create web-net
docker network create app-net

docker run -d --name db --network app-net postgres:15-alpine -e POSTGRES_PASSWORD=secret
docker run -d --name api --network app-net nginx:alpine
docker network connect web-net api
docker run -d --name web --network web-net -p 80:80 nginx:alpine

# Test
docker exec web ping api     # ✅
docker exec api ping db      # ✅
docker exec web ping db      # ❌ Fail
```
</details>

---

## 🎯 Défis Avancés

### Défi 1 : Custom Subnet

```bash
docker network create \
  --subnet 10.10.0.0/16 \
  --gateway 10.10.0.1 \
  --ip-range 10.10.10.0/24 \
  custom-subnet

docker run -d --name test --network custom-subnet --ip 10.10.10.5 alpine sleep 3600
docker inspect test | grep IPAddress
```

### Défi 2 : Network Overlay (Swarm)

```bash
docker swarm init
docker network create -d overlay my-overlay
docker service create --name web --network my-overlay nginx
```

### Défi 3 : MacVLAN

```bash
# Permet aux containers d'avoir leur propre MAC
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 \
  macvlan-net
```

---

## 🐛 Troubleshooting

### Container ne peut pas résoudre les noms

```bash
# Vérifier le DNS
docker exec container cat /etc/resolv.conf

# Recréer le network
docker network rm app-net
docker network create app-net
```

### Conflit de subnet

```bash
# Lister tous les subnets
docker network inspect $(docker network ls -q) | grep Subnet

# Utiliser un subnet différent
docker network create --subnet 172.25.0.0/16 new-net
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Créer des networks custom
- ✅ Connecter des containers
- ✅ Isolation réseau multi-tiers
- ✅ Network aliases et DNS
- ✅ Debugging réseau
- ✅ Drivers (bridge, host, none)

---

## ➡️ Prochaine Étape

[Exercice 08 : Docker Compose](../08-docker-compose/README.md)

---

## 📚 Ressources

- [Docker Networking Overview](https://docs.docker.com/network/)
- [Networking with Standalone Containers](https://docs.docker.com/network/network-tutorial-standalone/)
