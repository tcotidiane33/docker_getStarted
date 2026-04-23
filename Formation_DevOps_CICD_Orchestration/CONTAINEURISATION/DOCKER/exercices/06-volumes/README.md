# Exercice 06 : Docker Volumes - Persistence des Données

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Créer et gérer des volumes Docker
- ✅Comprendre les différents types de montage (bind, volume, tmpfs)
- ✅ Partager des données entre containers
- ✅ Backup et restore des volumes
- ✅ Utiliser des volumes pour les bases de données

## ⏱️ Durée Estimée
**1 heure 30 minutes**

## 📋 Prérequis
- [Exercice 05 : Application Node.js](../05-nodejs-app/README.md) complété

---

## 📚 Partie 1 : Types de Montage

### 1.1 Volumes (Recommandé)

```bash
# Créer un volume
docker volume create mon-volume

# Lister les volumes
docker volume ls

# Inspecter un volume
docker volume inspect mon-volume

# Utiliser le volume
docker run -d \
  --name nginx-volume \
  -v mon-volume:/usr/share/nginx/html \
  nginx:alpine

# Écrire dans le volume
docker exec nginx-volume sh -c 'echo "Hello from volume!" > /usr/share/nginx/html/index.html'

# Vérifier
curl http://localhost

# Supprimer le container
docker stop nginx-volume
docker rm nginx-volume

# Le volume persiste!
docker run -d \
  --name nginx-volume-2 \
  -v mon-volume:/usr/share/nginx/html \
  nginx:alpine

curl http://localhost  # Données toujours là!
```

### 1.2 Bind Mounts

```bash
# Créer un répertoire local
mkdir -p ~/docker-data/html
echo "<h1>Local File</h1>" > ~/docker-data/html/index.html

# Monter le répertoire
docker run -d \
  --name nginx-bind \
  -p 8080:80 \
  -v ~/docker-data/html:/usr/share/nginx/html \
  nginx:alpine

# Tester
curl http://localhost:8080

# Modifier le fichier local
echo "<h1>Updated!</h1>" > ~/docker-data/html/index.html

# Changement immédiat dans le container!
curl http://localhost:8080
```

### 1.3 tmpfs Mounts (Mémoire)

```bash
# Montage en mémoire (non persistant)
docker run -d \
  --name redis-tmpfs \
  --mount type=tmpfs,destination=/data \
  redis:alpine

# Données perdues après arrêt!
```

---

## 📚 Partie 2 : Volumes avec Bases de Données

### 2.1 PostgreSQL avec Volume

```bash
# Créer un volume pour PostgreSQL
docker volume create postgres-data

# Lancer PostgreSQL
docker run -d \
  --name postgres-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=admin \
  -e POSTGRES_DB=testdb \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15-alpine

# Créer des données
docker exec -it postgres-db psql -U admin -d testdb -c "
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES 
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com');
"

# Vérifier
docker exec postgres-db psql -U admin -d testdb -c "SELECT * FROM users;"

# Supprimer le container
docker stop postgres-db
docker rm postgres-db

# Recréer avec le même volume
docker run -d \
  --name postgres-db-new \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=admin \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15-alpine

# Données toujours là!
sleep 5
docker exec postgres-db-new psql -U admin -d testdb -c "SELECT * FROM users;"
```

### 2.2 MySQL avec Volume

```bash
# Volume MySQL
docker volume create mysql-data

# Lancer MySQL
docker run -d \
  --name mysql-db \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=appdb \
  -v mysql-data:/var/lib/mysql \
  mysql:8

sleep 10

# Créer des données
docker exec mysql-db mysql -uroot -proot123 -e "
USE appdb;
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10,2)
);
INSERT INTO products (name, price) VALUES 
  ('Laptop', 999.99),
  ('Mouse', 29.99);
"

# Vérifier
docker exec mysql-db mysql -uroot -proot123 appdb -e "SELECT * FROM products;"
```

### 2.3 MongoDB avec Volume

```bash
docker volume create mongo-data

docker run -d \
  --name mongo-db \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  -v mongo-data:/data/db \
  mongo:7

# Insérer des données
docker exec mongo-db mongosh -u admin -p secret --eval '
  db = db.getSiblingDB("testdb");
  db.items.insertMany([
    { name: "Item 1", price: 10 },
    { name: "Item 2", price: 20 }
  ]);
'

# Vérifier
docker exec mongo-db mongosh -u admin -p secret --eval '
  db = db.getSiblingDB("testdb");
  db.items.find();
'
```

---

## 📚 Partie 3 : Partage de Volumes entre Containers

```bash
# Créer un volume partagé
docker volume create shared-data

# Container 1: Producteur
docker run -d \
  --name producer \
  -v shared-data:/data \
  alpine \
  sh -c 'while true; do echo "$(date): Producer data" >> /data/log.txt; sleep 2; done'

# Container 2: Consommateur
docker run -d \
  --name consumer \
  -v shared-data:/data:ro \
  alpine \
  sh -c 'while true; do cat /data/log.txt; sleep 5; done'

# Voir les logs du consommateur
docker logs -f consumer

# Cleanup
docker stop producer consumer
docker rm producer consumer
```

---

## 📚 Partie 4 : Backup et Restore

### 4.1 Backup d'un Volume

```bash
# Créer un container avec volume
docker run -d \
  --name data-source \
  -v importante-data:/data \
  alpine \
  sh -c 'echo "Important data!" > /data/important.txt'

# Backup du volume vers tar.gz
docker run --rm \
  -v importante-data:/data \
  -v $(pwd):/backup \
  alpine \
  tar czf /backup/backup-$(date +%Y%m%d-%H%M%S).tar.gz -C /data .

# Vérifier
ls -lh backup-*.tar.gz
```

### 4.2 Restore d'un Backup

```bash
# Créer un nouveau volume
docker volume create restored-data

# Restaurer le backup
docker run --rm \
  -v restored-data:/data \
  -v $(pwd):/backup \
  alpine \
  sh -c 'tar xzf /backup/backup-*.tar.gz -C /data'

# Vérifier
docker run --rm \
  -v restored-data:/data \
  alpine \
  cat /data/important.txt
```

---

## 📚 Partie 5 : Volumes en Read-Only

```bash
# Monter en lecture seule
docker run -d \
  --name nginx-ro \
  -p 8080:80 \
  -v $(pwd)/html:/usr/share/nginx/html:ro \
  nginx:alpine

# Essayer d'écrire (échouera)
docker exec nginx-ro sh -c 'echo "test" > /usr/share/nginx/html/test.txt'
# Erreur: Read-only file system
```

---

## 📚 Partie 6 : Projet Complet - Application avec Volumes

```bash
mkdir -p ~/docker-exercices/app-with-volumes
cd ~/docker-exercices/app-with-volumes

# Structure
mkdir -p app uploads logs

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./app:/usr/share/nginx/html:ro
      - nginx-logs:/var/log/nginx
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb
    volumes:
      - db-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro

  uploader:
    image: alpine
    command: sh -c "while true; do echo 'File uploaded at: $(date)' >> /uploads/log.txt; sleep 10; done"
    volumes:
      - upload-data:/uploads

volumes:
  db-data:
  upload-data:
  nginx-logs:
EOF

# Créer le fichier HTML
cat > app/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>App with Volumes</title></head>
<body>
  <h1>🐳 Docker Volumes Demo</h1>
  <p>This app uses persistent volumes!</p>
</body>
</html>
EOF

# Script SQL d'initialisation
cat > init.sql << 'EOF'
CREATE TABLE visits (
  id SERIAL PRIMARY KEY,
  visited_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO visits (visited_at) VALUES (NOW());
EOF

# Lancer
docker-compose up -d

# Tester
curl http://localhost:8080

# Vérifier les volumes
docker volume ls | grep app-with-volumes

# Voir les logs nginx
docker-compose exec web cat /var/log/nginx/access.log

# Cleanup
docker-compose down
docker-compose down -v  # Supprimer aussi les volumes
```

---

## ✅ Exercice de Validation

Créez une application complète avec:

1. **Base de données** avec volume persistant
2. **Application** avec uploads sur volume
3. **Logs** sur volume dédié
4. **Backup automatique** toutes les heures

```yaml
# Solution minimale
services:
  app:
    volumes:
      - logs:/app/logs
      - uploads:/app/uploads
  
  db:
    volumes:
      - db-data:/var/lib/postgresql/data
  
  backup:
    volumes:
      - db-data:/data:ro
      - ./backups:/backups

volumes:
  db-data:
  logs:
  uploads:
```

---

## 🎯 Défis Avancés

### Défi 1 : Volume Driver NFS

```bash
# Créer un volume NFS (si serveur NFS disponible)
docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=192.168.1.100,rw \
  --opt device=:/path/to/share \
  nfs-volume
```

### Défi 2 : Copie de Volumes

```bash
# Copier d'un volume à un autre
docker run --rm \
  -v source-vol:/from \
  -v dest-vol:/to \
  alpine \
  sh -c 'cp -av /from/. /to/'
```

### Défi 3 : Monitoring de l'Espace

```bash
# Script de monitoring
docker volume ls -q | while read vol; do
  echo "=== $vol ==="
  docker run --rm -v $vol:/data alpine du -sh /data
done
```

---

## 🐛 Troubleshooting

### Volume non supprimé

```bash
# Voir quels containers utilisent le volume
docker ps -a --filter volume=mon-volume

# Forcer la suppression
docker volume rm -f mon-volume
```

### Permissions incorrectes

```bash
# Définir l'ownership correctement
docker run --rm \
  -v mon-volume:/data \
  alpine \
  chown -R 1000:1000 /data
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Créer et gérer des volumes
- ✅ Différence entre volumes, bind mounts, tmpfs
- ✅ Volumes avec bases de données
- ✅ Partage de données entre containers
- ✅ Backup et restore
- ✅ Read-only mounts

---

## ➡️ Prochaine Étape

[Exercice 07 : Docker Networks](../07-networks/README.md)

---

## 📚 Ressources

- [Docker Volumes Documentation](https://docs.docker.com/storage/volumes/)
- [Bind Mounts](https://docs.docker.com/storage/bind-mounts/)
