# Exercice 02 : Premiers Containers

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Lancer différents types de containers
- ✅ Comprendre les modes d'exécution (interactif, détaché)
- ✅ Gérer les containers (start, stop, restart)
- ✅ Inspecter l'état des containers
- ✅ Interagir avec des containers en cours d'exécution

## ⏱️ Durée Estimée
**1 heure**

## 📋 Prérequis
- [Exercice 01 : Installation](../01-installation/README.md) complété
- Docker installé et fonctionnel

---

## 📚 Partie 1 : Container en Mode Interactif

### Exercice 1.1 : Explorer Ubuntu

```bash
# Lancer Ubuntu en mode interactif
docker run -it --name mon-ubuntu ubuntu:22.04 bash

# À l'intérieur du container, exécutez:
cat /etc/os-release      # Voir la version Ubuntu
whoami                    # Vous êtes root
pwd                       # /
ls                        # Voir le système de fichiers

# Installer quelques outils
apt-get update
apt-get install -y curl wget vim

# Tester
curl https://api.github.com

# Sortir du container
exit
```

**💡 Notes :**
- Le container s'arrête quand vous tapez `exit`
- Tout ce que vous installez est PERDU après exit (nous verrons les volumes plus tard)

### Exercice 1.2 : Relancer le Même Container

```bash
# Lister tous les containers (même arrêtés)
docker ps -a

# Vous devriez voir 'mon-ubuntu' avec status Exited

# Redémarrer le container
docker start mon-ubuntu

# Se reconnecter
docker attach mon-ubuntu

# Vérifier si curl est toujours installé
curl --version  # Oui, car on a redémarré le même container!

# Sortir SANS arrêter le container: Ctrl+P puis Ctrl+Q
```

---

## 📚 Partie 2 : Container en Mode Détaché (Background)

### Exercice 2.1 : Serveur Web Nginx

```bash
# Lancer nginx en background
docker run -d \
  --name web-nginx \
  -p 8080:80 \
  nginx:alpine

# Vérifier qu'il tourne
docker ps

# Tester
curl http://localhost:8080
# ou ouvrir dans le navigateur

# Voir les logs en temps réel
docker logs -f web-nginx
# Ctrl+C pour sortir
```

### Exercice 2.2 : Base de Données Redis

```bash
# Lancer Redis
docker run -d \
  --name cache-redis \
  -p 6379:6379 \
  redis:alpine

# Se connecter au Redis CLI
docker exec -it cache-redis redis-cli

# Tester Redis (dans le CLI)
SET utilisateur:1 "Jean Dupont"
GET utilisateur:1
INCR compteur
GET compteur

# Quitter Redis CLI
exit
```

### Exercice 2.3 : Base de Données PostgreSQL

```bash
# Lancer PostgreSQL
docker run -d \
  --name db-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=monmotdepasse \
  -e POSTGRES_USER=admin \
  -e POSTGRES_DB=mabase \
  postgres:15-alpine

# Attendre que postgres démarre (quelques secondes)
sleep 5

# Se connecter à PostgreSQL
docker exec -it db-postgres psql -U admin -d mabase

# Dans PostgreSQL (commandes SQL):
CREATE TABLE utilisateurs (
  id SERIAL PRIMARY KEY,
  nom VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO utilisateurs (nom, email) VALUES ('Alice', 'alice@example.com');
INSERT INTO utilisateurs (nom, email) VALUES ('Bob', 'bob@example.com');

SELECT * FROM utilisateurs;

# Quitter PostgreSQL
\q
```

---

## 📚 Partie 3 : Gestion du Cycle de Vie

### Exercice 3.1 : Start / Stop / Restart

```bash
# Voir tous les containers en cours
docker ps

# Arrêter un container
docker stop web-nginx

# Vérifier
docker ps          # web-nginx n'apparaît plus
docker ps -a       # web-nginx apparaît avec status Exited

# Redémarrer
docker start web-nginx

# Redémarrer (stop + start)
docker restart web-nginx

# Arrêter plusieurs containers
docker stop cache-redis db-postgres web-nginx
```

### Exercice 3.2 : Pause / Unpause

```bash
# Démarrer nginx
docker start web-nginx

# Mettre en pause (fige le processus)
docker pause web-nginx

# Essayer d'accéder
curl http://localhost:8080  # Timeout!

# Reprendre
docker unpause web-nginx

# Tester à nouveau
curl http://localhost:8080  # Fonctionne!
```

---

## 📚 Partie 4 : Inspection et Monitoring

### Exercice 4.1 : Logs

```bash
# Démarrer tous les containers
docker start web-nginx cache-redis db-postgres

# Voir les derniers logs
docker logs web-nginx

# Voir avec timestamps
docker logs -t web-nginx

# Suivre en temps réel
docker logs -f web-nginx
# Faites quelques curl pendant ce temps
# Ctrl+C pour sortir

# Voir seulement les 10 dernières lignes
docker logs --tail 10 web-nginx
```

### Exercice 4.2 : Statistiques en Temps Réel

```bash
# Stats de tous les containers
docker stats

# Stats d'un container spécifique
docker stats web-nginx

# Stats sans stream (snapshot)
docker stats --no-stream
```

### Exercice 4.3 : Inspection Détaillée

```bash
# Inspecter un container (format JSON)
docker inspect web-nginx

# Extraire des infos spécifiques avec --format
docker inspect --format='{{.State.Status}}' web-nginx
docker inspect --format='{{.NetworkSettings.IPAddress}}' web-nginx
docker inspect --format='{{.Config.Image}}' web-nginx
```

### Exercice 4.4 : Processus dans un Container

```bash
# Voir les processus d'un container
docker top web-nginx

# Plus détaillé
docker top db-postgres aux
```

---

## 📚 Partie 5 : Interaction avec les Containers

### Exercice 5.1 : Exécuter des Commandes

```bash
# Exécuter une commande simple
docker exec web-nginx ls /usr/share/nginx/html

# Voir les variables d'environnement
docker exec web-nginx env

# Exécuter plusieurs commandes
docker exec web-nginx sh -c "nginx -v && cat /etc/nginx/nginx.conf | head -n 10"
```

### Exercice 5.2 : Shell Interactif

```bash
# Ouvrir un shell dans nginx
docker exec -it web-nginx sh

# À l'intérieur:
cd /usr/share/nginx/html
ls
cat index.html
exit

# Bash (si disponible)
docker exec -it db-postgres bash
```

### Exercice 5.3 : Copier des Fichiers

```bash
# Créer un fichier HTML personnalisé
cat > custom.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Mon Site</title></head>
<body>
  <h1>🐳 Docker is Awesome!</h1>
  <p>Container: web-nginx</p>
</body>
</html>
EOF

# Copier VERS le container
docker cp custom.html web-nginx:/usr/share/nginx/html/index.html

# Tester
curl http://localhost:8080

# Copier DEPUIS le container
docker cp web-nginx:/etc/nginx/nginx.conf ./nginx-backup.conf

# Vérifier
ls -la nginx-backup.conf
```

---

## 📚 Partie 6 : Variables d'Environnement

### Exercice 6.1 : Utiliser des Variables

```bash
# Lancer MySQL avec variables d'environnement
docker run -d \
  --name db-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=testdb \
  -e MYSQL_USER=testuser \
  -e MYSQL_PASSWORD=testpass \
  mysql:8

# Attendre le démarrage
sleep 10

# Vérifier les variables
docker exec db-mysql env | grep MYSQL

# Se connecter
docker exec -it db-mysql mysql -uroot -proot123

# Dans MySQL:
SHOW DATABASES;
USE testdb;
exit
```

### Exercice 6.2 : Fichier .env

```bash
# Créer un fichier .env
cat > app.env << EOF
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_PORT=5432
EOF

# Lancer avec --env-file
docker run -d \
  --name node-app \
  --env-file app.env \
  node:18-alpine \
  sh -c "env && sleep 3600"

# Vérifier
docker exec node-app env | grep NODE_ENV
```

---

## 📚 Partie 7 : Nommage et Étiquettes

### Exercice 7.1 : Containers Nommés

```bash
# Sans nom (généré automatiquement)
docker run -d nginx:alpine
docker ps  # Nom aléatoire type: silly_newton

# Avec nom
docker run -d --name mon-serveur nginx:alpine

# Facilite la gestion
docker stop mon-serveur
docker start mon-serveur
docker logs mon-serveur
```

### Exercice 7.2 : Labels

```bash
# Lancer avec labels
docker run -d \
  --name web-labeled \
  --label environment=production \
  --label team=backend \
  --label version=1.0 \
  nginx:alpine

# Filtrer par label
docker ps --filter "label=environment=production"

# Inspecter les labels
docker inspect --format='{{json .Config.Labels}}' web-labeled | jq
```

---

## ✅ Exercice de Validation

Créez une mini-infrastructure avec 3 containers :

```bash
# 1. Web Frontend (nginx)
docker run -d \
  --name frontend \
  -p 8080:80 \
  --label tier=frontend \
  nginx:alpine

# 2. Cache (Redis)
docker run -d \
  --name cache \
  -p 6379:6379 \
  --label tier=cache \
  redis:alpine

# 3. Database (PostgreSQL)
docker run -d \
  --name database \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=secretpass \
  --label tier=database \
  postgres:15-alpine

# Vérifier que tout tourne
docker ps

# Voir les stats
docker stats --no-stream

# Tester chaque service
curl http://localhost:8080
docker exec cache redis-cli PING
docker exec database pg_isready

# Nettoyer
docker stop frontend cache database
docker rm frontend cache database
```

---

## 🎯 Défi Bonus

### Défi 1 : Container Temporaire

```bash
# Container qui se supprime automatiquement après exécution
docker run --rm ubuntu:22.04 echo "Hello Docker!"
docker ps -a  # Le container n'existe plus
```

### Défi 2 : Limiter les Ressources

```bash
# Limiter CPU et mémoire
docker run -d \
  --name limited-nginx \
  --memory="256m" \
  --cpus="0.5" \
  nginx:alpine

# Vérifier
docker stats --no-stream limited-nginx
```

### Défi 3 : Mode Read-Only

```bash
# Container en lecture seule
docker run -d \
  --name readonly-nginx \
  --read-only \
  -p 8081:80 \
  nginx:alpine

# Essayer d'écrire (devrait échouer)
docker exec readonly-nginx touch /test.txt
# Erreur: Read-only file system
```

---

## 🐛 Troubleshooting

### Container s'arrête immédiatement

```bash
# Voir les logs
docker logs nom-container

# Lancer avec --rm pour debug
docker run --rm ubuntu:22.04 cat /etc/os-release
```

### Port déjà utilisé

```bash
# Trouver ce qui utilise le port
sudo lsof -i :8080

# Utiliser un autre port
docker run -d -p 8081:80 nginx
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Lancer des containers (interactif et détaché)
- ✅ Gérer le cycle de vie (start/stop/restart/pause)
- ✅ Voir les logs et statistiques
- ✅ Exécuter des commandes dans les containers
- ✅ Copier des fichiers
- ✅ Utiliser des variables d'environnement
- ✅ Nommer et étiqueter les containers

---

## ➡️ Prochaine Étape

[Exercice 03 : Docker CLI Maîtrise](../03-docker-cli/README.md)

---

## 📚 Ressources

- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker Run Reference](https://docs.docker.com/engine/reference/run/)
