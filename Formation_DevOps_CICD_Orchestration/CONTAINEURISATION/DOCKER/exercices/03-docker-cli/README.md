# Exercice 03 : Maîtrise de Docker CLI

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Utiliser les commandes Docker avancées
- ✅ Filtrer et formater les sorties
- ✅ Gérer les images efficacement
- ✅ Utiliser les networks de base
- ✅ Nettoyer et maintenir votre environnement Docker

## ⏱️ Durée Estimée
**1 heure 30 minutes**

## 📋 Prérequis
- [Exercice 02 : Premiers Containers](../02-premiers-containers/README.md) complété

---

## 📚 Partie 1 : Gestion Avancée des Images

### Exercice 1.1 : Recherche et Téléchargement

```bash
# Rechercher une image sur Docker Hub
docker search nginx
docker search --limit 5 nginx

# Rechercher images officielles uniquement
docker search --filter is-official=true nginx

# Télécharger une image spécifique
docker pull nginx:1.25-alpine
docker pull nginx:1.24-alpine
docker pull redis:7-alpine
docker pull postgres:15-alpine

# Lister toutes les images
docker images

# Trier par taille
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | sort -k3 -h
```

### Exercice 1.2 : Tags et Versioning

```bash
# Télécharger différentes versions
docker pull python:3.11
docker pull python:3.11-slim
docker pull python:3.11-alpine

# Comparer les tailles
docker images python

# Tagger une image
docker tag nginx:1.25-alpine mon-nginx:latest
docker tag nginx:1.25-alpine mon-nginx:v1.0
docker tag nginx:1.25-alpine mon-nginx:production

# Lister
docker images | grep mon-nginx
```

### Exercice 1.3 : Inspection des Images

```bash
# Inspecter une image
docker inspect nginx:alpine

# Extraire des infos spécifiques
docker inspect --format='{{.Architecture}}' nginx:alpine
docker inspect --format='{{.Os}}' nginx:alpine
docker inspect --format='{{.Size}}' nginx:alpine

# Voir l'historique de construction
docker history nginx:alpine

# Format lisible
docker history --no-trunc nginx:alpine
```

### Exercice 1.4 : Suppression des Images

```bash
# Supprimer une image
docker rmi python:3.11

# Supprimer plusieurs images
docker rmi python:3.11-slim python:3.11-alpine

# Supprimer toutes les images d'un repository
docker images -q nginx | xargs docker rmi

# Force (si containers existent)
docker rmi -f nginx:alpine
```

---

## 📚 Partie 2 : Filtres et Formatage

### Exercice 2.1 : Filtrer les Containers

```bash
# Lancer quelques containers de test
docker run -d --name web1 --label env=prod nginx:alpine
docker run -d --name web2 --label env=dev nginx:alpine
docker run -d --name cache1 --label env=prod redis:alpine
docker run -d --name cache2 --label env=dev redis:alpine

# Filtrer par label
docker ps --filter "label=env=prod"
docker ps --filter "label=env=dev"

# Filtrer par nom
docker ps --filter "name=web"

# Filtrer par status
docker ps -a --filter "status=exited"
docker ps --filter "status=running"

# Filtrer par image
docker ps --filter "ancestor=nginx:alpine"

# Combinaisons multiples
docker ps --filter "name=web" --filter "label=env=prod"
```

### Exercice 2.2 : Formater les Sorties

```bash
# Format tableau personnalisé
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"

# Format JSON
docker ps --format "{{json .}}" | jq

# Extraire seulement les noms
docker ps --format "{{.Names}}"

# IDs seulement
docker ps -q

# Noms et status
docker ps --format "{{.Names}}: {{.Status}}"

# Avec couleurs (via alias dans .bashrc/.zshrc)
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"'
```

### Exercice 2.3 : Filtrer les Images

```bash
# Images avant une certaine date
docker images --filter "before=nginx:1.25-alpine"

# Images depuis
docker images --filter "since=nginx:1.24-alpine"

# Images dangling (sans tag)
docker images --filter "dangling=true"

# Images avec label
docker images --filter "label=maintainer"
```

---

## 📚 Partie 3 : Networks (Introduction)

### Exercice 3.1 : Créer et Gérer des Networks

```bash
# Lister les networks par défaut
docker network ls

# Créer un network
docker network create mon-network

# Créer avec options
docker network create \
  --driver bridge \
  --subnet 172.18.0.0/16 \
  --gateway 172.18.0.1 \
  app-network

# Inspecter un network
docker network inspect mon-network
```

### Exercice 3.2 : Connecter des Containers

```bash
# Lancer containers dans le même network
docker run -d --name db --network app-network postgres:15-alpine \
  -e POSTGRES_PASSWORD=secret

docker run -d --name api --network app-network nginx:alpine

# Vérifier la connectivité
docker exec api ping -c 3 db

# Le container 'api' peut résoudre 'db' par son nom!
```

### Exercice 3.3 : Networks Multiples

```bash
# Créer deux networks
docker network create frontend-net
docker network create backend-net

# Container sur deux networks
docker run -d --name app \
  --network frontend-net \
  nginx:alpine

docker network connect backend-net app

# Vérifier
docker inspect app | grep -A 20 Networks
```

### Exercice 3.4 : Déconnecter et Supprimer

```bash
# Déconnecter un container d'un network
docker network disconnect backend-net app

# Supprimer un network
docker network rm frontend-net

# Nettoyer networks non utilisés
docker network prune
```

---

## 📚 Partie 4 : Logs Avancés

### Exercice 4.1 : Options de Logs

```bash
# Créer un container qui log
docker run -d --name logger nginx:alpine

# Générer des logs
for i in {1..10}; do curl -s http://localhost > /dev/null; done

# Dernières 5 lignes
docker logs --tail 5 logger

# Depuis les 2 dernières minutes
docker logs --since 2m logger

# Entre deux timestamps
docker logs --since "2024-01-01T00:00:00" --until "2024-12-31T23:59:59" logger

# Avec timestamps
docker logs -t logger

# Follow avec tail
docker logs -f --tail 20 logger
```

### Exercice 4.2 : Logging Drivers

```bash
# Lancer avec json-file driver (défaut)
docker run -d \
  --name app-json \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  nginx:alpine

# Voir la config
docker inspect --format='{{.HostConfig.LogConfig}}' app-json

# Lancer avec syslog driver
docker run -d \
  --name app-syslog \
  --log-driver syslog \
  --log-opt syslog-address=tcp://localhost:514 \
  nginx:alpine
```

---

## 📚 Partie 5 : Gestion des Ressources

### Exercice 5.1 : Limiter CPU et Mémoire

```bash
# Container avec limites
docker run -d \
  --name limited \
  --memory="512m" \
  --memory-swap="1g" \
  --cpus="1.5" \
  --cpu-shares=512 \
  nginx:alpine

# Vérifier
docker stats --no-stream limited

# Stress test (installer stress dans le container)
docker exec limited apk add stress
docker exec -d limited stress --cpu 4 --timeout 30s

# Observer pendant le stress
docker stats limited
```

### Exercice 5.2 : Update à Chaud

```bash
# Mettre à jour les limites sans restart
docker update --memory="1g" --cpus="2" limited

# Vérifier
docker inspect limited | grep -A 5 Memory
```

---

## 📚 Partie 6 : Nettoyage et Maintenance

### Exercice 6.1 : Nettoyage Sélectif

```bash
# Supprimer containers arrêtés
docker container prune

# Supprimer images non utilisées
docker image prune

# Supprimer images dangling
docker image prune -a

# Supprimer volumes non utilisés
docker volume prune

# Supprimer networks non utilisés
docker network prune
```

### Exercice 6.2 : Nettoyage Total

```bash
# Tout nettoyer (ATTENTION!)
docker system prune -a --volumes

# Avec confirmation interactive
docker system prune -a
```

### Exercice 6.3 : Info et Espace

```bash
# Voir l'utilisation disque
docker system df

# Détaillé
docker system df -v

# Informations système
docker system info
```

---

## 📚 Partie 7 : Commandes Pratiques Avancées

### Exercice 7.1 : Batch Operations

```bash
# Arrêter tous les containers
docker stop $(docker ps -q)

# Supprimer tous les containers
docker rm $(docker ps -aq)

# Supprimer toutes les images
docker rmi $(docker images -q)

# Arrêter les containers d'une image spécifique
docker ps -a | grep nginx | awk '{print $1}' | xargs docker stop

# Supprimer containers par pattern
docker ps -a --filter "name=test" -q | xargs docker rm
```

### Exercice 7.2 : Export et Import

```bash
# Créer un container
docker run -d --name export-test nginx:alpine

# Export container en tarball
docker export export-test > container.tar

# Import comme image
cat container.tar | docker import - mon-image:latest

# Vérifier
docker images mon-image

# Sauvegarder une image
docker save nginx:alpine > nginx-image.tar

# Charger une image
docker load < nginx-image.tar
```

### Exercice 7.3 : Commit de Containers

```bash
# Créer un container et le modifier
docker run -it --name custom ubuntu:22.04 bash

# Dans le container
apt-get update
apt-get install -y curl wget vim
echo "Custom container" > /custom.txt
exit

# Créer une image depuis le container
docker commit custom mon-ubuntu:v1

# Tester la nouvelle image
docker run --rm mon-ubuntu:v1 cat /custom.txt
```

---

## ✅ Exercice de Validation Complète

### Mini-Projet : Stack de Monitoring

```bash
# Créer un network dédié
docker network create monitoring

# 1. Container web avec limites
docker run -d \
  --name web-app \
  --network monitoring \
  --memory="256m" \
  --cpus="0.5" \
  --label type=frontend \
  -p 8080:80 \
  nginx:alpine

# 2. Container de base de données
docker run -d \
  --name db \
  --network monitoring \
  --memory="512m" \
  --label type=database \
  -e POSTGRES_PASSWORD=secret \
  postgres:15-alpine

# 3. Cache Redis
docker run -d \
  --name cache \
  --network monitoring \
  --memory="128m" \
  --label type=cache \
  redis:alpine

# Vérifications
echo "=== Containers ==="
docker ps --filter "network=monitoring" \
  --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "=== Stats ==="
docker stats --no-stream

echo "=== Network Inspect ==="
docker network inspect monitoring | grep -A 3 Containers

echo "=== Test Connectivity ==="
docker exec web-app ping -c 2 db
docker exec web-app ping -c 2 cache

# Cleanup
docker stop web-app db cache
docker rm web-app db cache
docker network rm monitoring
```

---

## 🎯 Défis Avancés

### Défi 1 : Script d'Analyse

Créez un script qui affiche:
- Nombre total de containers
- Containers en cours d'exécution
- Utilisation totale de la mémoire
- Images les plus lourdes

```bash
#!/bin/bash
echo "=== Docker Status Report ==="
echo "Total containers: $(docker ps -a -q | wc -l)"
echo "Running containers: $(docker ps -q | wc -l)"
echo ""
echo "=== Top 5 images by size ==="
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -n 6
echo ""
echo "=== Disk usage ==="
docker system df
```

### Défi 2 : Cleanup Automatique

Script de nettoyage hebdomadaire:

```bash
#!/bin/bash
# cleanup-docker.sh

echo "Starting Docker cleanup..."

# Containers de plus de 7 jours
docker ps -a --filter "until=168h" -q | xargs docker rm

# Images non utilisées
docker image prune -a -f --filter "until=168h"

# Volumes orphelins
docker volume prune -f

# Networks non utilisés
docker network prune -f

echo "Cleanup completed!"
docker system df
```

---

## 🐛 Troubleshooting

### Container ne démarre pas

```bash
# Voir les événements Docker
docker events

# Dans un autre terminal, démarrer le container
docker start problematic-container

# Inspecter l'état
docker inspect problematic-container | grep -A 20 State
```

### Problèmes de Network

```bash
# Vérifier les networks
docker network ls

# Inspecter un network
docker network inspect bridge

# Recréer le network par défaut (si nécessaire)
docker network prune
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Gestion avancée des images (pull, tag, prune)
- ✅ Filtrage et formatage des sorties
- ✅ Networks basiques
- ✅ Logs avancés
- ✅ Gestion des ressources (CPU, mémoire)
- ✅ Nettoyage et maintenance
- ✅ Batch operations

---

## ➡️ Prochaine Étape

[Exercice 04 : Premier Dockerfile](../04-dockerfile/README.md)

---

## 📚 Ressources

- [Docker CLI Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)
- [Docker Format Reference](https://docs.docker.com/config/formatting/)
- [Docker Networking](https://docs.docker.com/network/)
