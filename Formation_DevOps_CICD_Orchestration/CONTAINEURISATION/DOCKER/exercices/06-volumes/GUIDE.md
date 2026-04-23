# 💾 Exercice 06 : Volumes - La Persistence des Données

## 🎯 Objectif
Comprendre comment sauvegarder des données même quand le container meurt.

## 💡 L'Analogie : Le Coffre-Fort vs la Poche
*   **Container sans volume** = Garder l'argent dans votre **poche**. Si vous perdez le pantalon, l'argent est perdu.
*   **Volume** = Mettre l'argent dans un **coffre-fort**. Même si vous changez de pantalon 100 fois, l'argent reste.
*   **Bind mount** = Le coffre est dans **votre maison** (dossier de l'hôte)
*   **Named volume** = Le coffre est à la **banque** (géré par Docker)

## 🗺️ Roadmap & Étapes

### Étape 1 : Le Problème (Données Perdues)
```bash
# Lancer PostgreSQL
docker run -d --name db1 \
  -e POSTGRES_PASSWORD=secret \
  postgres

# Créer une base de données
docker exec -it db1 psql -U postgres -c "CREATE DATABASE mydb;"
docker exec -it db1 psql -U postgres -c "\l"

# SUPPRIMER le container
docker rm -f db1

# Relancer
docker run -d --name db2 \
  -e POSTGRES_PASSWORD=secret \
  postgres

# La base "mydb" a DISPARU !
docker exec -it db2 psql -U postgres -c "\l"
```

**Analogie :** Vous avez perdu votre pantalon avec l'argent dedans. Drame.

### Étape 2 : La Solution (Named Volume)
```bash
# Créer un volume
docker volume create pgdata

# Lancer avec le volume
docker run -d --name db3 \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres

# Créer la base
docker exec -it db3 psql -U postgres -c "CREATE DATABASE mydb;"

# SUPPRIMER le container
docker rm -f db3

# Relancer avec le MÊME volume
docker run -d --name db4 \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  postgres

# La base "mydb" est TOUJOURS LÀ ! 🎉
docker exec -it db4 psql -U postgres -c "\l"
```

**Analogie :** L'argent est au coffre. Vous changez de pantalon, pas de problème.

### Étape 3 : Bind Mount (Dossier Local)
```bash
# Créer un dossier local
mkdir monsite
echo "<h1>Hello!</h1>" > monsite/index.html

# Monter le dossier dans Nginx
docker run -d --name web \
  -p 8080:80 \
  -v $(pwd)/monsite:/usr/share/nginx/html \
  nginx

# Tester
curl http://localhost:8080

# Modifier EN DIRECT
echo "<h1>Updated!</h1>" > monsite/index.html

# Rafraîchir le navigateur → Changement immédiat !
curl http://localhost:8080
```

**Analogie :** Le coffre est dans votre salon. Vous pouvez l'ouvrir et modifier le contenu quand vous voulez.

### Étape 4 : Volume en Lecture Seule
```bash
docker run -d --name web-readonly \
  -v $(pwd)/monsite:/usr/share/nginx/html:ro \
  nginx

# Le container NE PEUT PAS modifier le dossier
docker exec web-readonly touch /usr/share/nginx/html/test.txt
# ERROR: Read-only file system
```

**Analogie :** Coffre-fort avec une vitre : vous voyez, mais vous ne pouvez pas toucher.

### Étape 5 : Inspecter les Volumes
```bash
# Lister
docker volume ls

# Détails d'un volume
docker volume inspect pgdata

# Voir où Docker stocke vraiment les données
# Résultat: /var/lib/docker/volumes/pgdata/_data (Linux)
```

### Étape 6 : Partager un Volume Entre Containers
```bash
# Volume partagé
docker volume create shared

# Container 1 écrit
docker run -d --name writer \
  -v shared:/data \
  busybox sh -c "while true; do date >> /data/log.txt; sleep 1; done"

# Container 2 lit
docker run --rm \
  -v shared:/data \
  busybox tail -f /data/log.txt

# Les deux voient le même fichier en temps réel !
```

**Analogie :** Deux personnes avec la clé du même coffre.

### Étape 7 : Backup et Restore
```bash
# Backup d'un volume
docker run --rm \
  -v pgdata:/data \
  -v $(pwd):/backup \
  busybox tar czf /backup/pgdata-backup.tar.gz /data

# Restore
docker volume create pgdata-restored

docker run --rm \
  -v pgdata-restored:/data \
  -v $(pwd):/backup \
  busybox tar xzf /backup/pgdata-backup.tar.gz -C /data --strip 1
```

### Étape 8 : Nettoyage des Volumes
```bash
# Supprimer un volume (le container doit être arrêté)
docker volume rm pgdata

# Supprimer tous les volumes non utilisés
docker volume prune

# Voir l'espace disque
docker system df
```

## ✅ Exercice Complet
Créez un système de blog persistant :

```bash
# 1. Volume pour MySQL
docker volume create mysql_data

# 2. Lancer MySQL
docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=blog \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0

# 3. Vérifier la persistence
docker exec mysql mysql -uroot -proot -e "USE blog; CREATE TABLE posts(id INT, title VARCHAR(100));"

# 4. Détruire et recréer
docker rm -f mysql

docker run -d --name mysql2 \
  -e MYSQL_ROOT_PASSWORD=root \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0

# 5. La table est toujours là !
docker exec mysql2 mysql -uroot -proot -e "USE blog; SHOW TABLES;"

# 6. Backup
docker run --rm \
  -v mysql_data:/data \
  -v $(pwd):/backup \
  busybox tar czf /backup/blog-backup.tar.gz /data

# 7. Nettoyer
docker rm -f mysql2
docker volume rm mysql_data
```

## ➡️ Prochaine Étape
[Exercice 07 : Networks](../07-networks/GUIDE.md)

**Ce que vous avez compris :**
Les volumes sont des coffres-forts externes : vos données survivent même si le container explose. Bind mounts = coffre chez vous, Named volumes = coffre à la banque Docker !
