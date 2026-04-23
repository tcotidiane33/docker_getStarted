# 🎮 Exercice 03 : Docker CLI Mastery

## 🎯 Objectif
Maîtriser les commandes Docker pour inspecter, gérer et déboguer les containers.

## 💡 L'Analogie : Le Tableau de Bord de Voiture
*   **`docker ps`** = Le **compteur de vitesse** (état actuel)
*   **`docker logs`** = La **boîte noire** (historique des événements)
*   **`docker inspect`** = Le **manuel technique** complet
*   **`docker stats`** = Les **jauges** (essence, température, etc.)
*   **`docker exec`** = Ouvrir le **capot** pour bidouiller le moteur

## 🗺️ Roadmap & Étapes

### Étape 1 : Surveillance (Inspect & Stats)
```bash
# Lancer un conteneur
docker run -d --name webapp nginx

# Voir toutes les infos techniques (JSON)
docker inspect webapp

# Voir seulement l'IP
docker inspect -f '{{.NetworkSettings.IPAddress}}' webapp

# Stats en temps réel (CPU, RAM, Réseau)
docker stats webapp

# Stats de tous les containers
docker stats
```

**Analogie :** `inspect` c'est comme lire le manuel de 500 pages de la voiture. `stats` c'est regarder les jauges en temps réel.

### Étape 2 : Filtres et Formats
```bash
# Lister avec format personnalisé
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Filtrer par status
docker ps -a --filter "status=exited"

# Filtrer par nom
docker ps --filter "name=web"

# Filtrer par image
docker ps --filter "ancestor=nginx"
```

### Étape 3 : Gestion des Ressources
```bash
# Lancer avec limites de ressources
docker run -d \
  --name limited \
  --memory="512m" \
  --cpus="0.5" \
  nginx

# Vérifier les limites
docker inspect limited | grep -i memory
docker stats limited
```

**Analogie :** Comme limiter la vitesse max de la voiture à 90 km/h et le réservoir à 10 litres.

### Étape 4 : Port Mapping (Ouvrir les Portes)
```bash
# Mapper le port 8080 de l'hôte vers le port 80 du container
docker run -d --name web -p 8080:80 nginx

# Voir les ports
docker port web

# Tester
curl http://localhost:8080
```

**Analogie :** Le conteneur est dans un entrepôt fermé. Le port mapping c'est percer un trou dans le mur et installer une porte au numéro 8080.

### Étape 5 : Volumes (Persistance des Données)
```bash
# Créer un volume
docker volume create monvolume

# Utiliser le volume
docker run -d --name db \
  -v monvolume:/var/lib/mysql \
  mysql:8.0

# Lister les volumes
docker volume ls

# Inspecter un volume
docker volume inspect monvolume
```

**Analogie :** Le volume c'est le **coffre-fort** externe. Même si le conteneur explose, les données restent dans le coffre.

### Étape 6 : Copy (Échanger des Fichiers)
```bash
# Copier un fichier DE l'hôte VERS le container
echo "Hello Docker" > test.txt
docker cp test.txt webapp:/tmp/

# Vérifier
docker exec webapp cat /tmp/test.txt

# Copier DU container VERS l'hôte
docker cp webapp:/etc/nginx/nginx.conf ./nginx-backup.conf
cat nginx-backup.conf
```

### Étape 7 : Nettoyage Intelligent
```bash
# Supprimer tous les containers arrêtés
docker container prune

# Supprimer toutes les images non utilisées
docker image prune -a

# Supprimer tous les volumes non utilisés
docker volume prune

# TOUT nettoyer (ATTENTION !)
docker system prune -a --volumes
```

**Analogie :** Le garage est plein de vieilles voitures et de pièces détachées. Le `prune` c'est la grande braderie !

### Étape 8 : Debugging Avancé
```bash
# Logs détaillés avec timestamps
docker logs --timestamps --since 10m webapp

# Suivre les logs en live
docker logs -f webapp

# Top (processus dans le container)
docker top webapp

# Événements en temps réel
docker events
```

## ✅ Exercice de Maîtrise
```bash
# 1. Lancer un container avec contraintes
docker run -d --name challenge \
  -p 9090:80 \
  --memory="256m" \
  --cpus="0.25" \
  nginx

# 2. Inspecter son IP
docker inspect -f '{{.NetworkSettings.IPAddress}}' challenge

# 3. Voir ses stats
docker stats --no-stream challenge

# 4. Copier un fichier dedans
echo "<h1>Success!</h1>" > index.html
docker cp index.html challenge:/usr/share/nginx/html/

# 5. Tester
curl http://localhost:9090

# 6. Nettoyer
docker rm -f challenge
```

## ➡️ Prochaine Étape
[Exercice 04 : Dockerfile](../04-dockerfile/GUIDE.md)

**Ce que vous avez compris :**
Docker CLI est votre tableau de bord pour piloter vos containers : vous pouvez tout surveiller, tout configurer, et tout déboguer !
