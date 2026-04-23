# Exercice 01 : Installation et Configuration Docker

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Installer Docker sur votre système
- ✅ Vérifier que Docker fonctionne correctement
- ✅ Comprendre les composants Docker (Docker Engine, CLI, Daemon)
- ✅ Exécuter votre premier container

## ⏱️ Durée Estimée
**45 minutes**

## 📋 Prérequis
- Aucun (exercice pour débutants absolus)
- Connexion Internet
- Droits administrateur sur votre machine

---

## 📚 Partie 1 : Installation

### macOS

**Option 1 : Docker Desktop (Recommandé)**
```bash
# Télécharger depuis https://www.docker.com/products/docker-desktop/
# Installer Docker Desktop.dmg
# Lancer Docker Desktop depuis Applications
```

**Option 2 : Homebrew**
```bash
brew install --cask docker
```

### Linux (Ubuntu/Debian)

```bash
# Mise à jour du système
sudo apt-get update

# Installation des prérequis
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Ajouter la clé GPG officielle de Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Ajouter le repository Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ajouter votre user au groupe docker (évite sudo)
sudo usermod -aG docker $USER

# Démarrer Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Linux (Fedora/RHEL)

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

### Windows

1. **Télécharger** Docker Desktop depuis [docker.com](https://www.docker.com/products/docker-desktop/)
2. **Installer** en suivant l'assistant
3. **Activer WSL 2** (Windows Subsystem for Linux) si demandé
4. **Redémarrer** votre machine
5. **Lancer** Docker Desktop

---

## 📚 Partie 2 : Vérification de l'Installation

```bash
# Vérifier la version Docker
docker --version
# Attendu: Docker version 24.x.x ou supérieur

# Vérifier Docker Compose
docker compose version
# Attendu: Docker Compose version v2.x.x

# Vérifier que le daemon tourne
docker info

# Informations système Docker
docker system info
```

**✅ Checkpoint :** Toutes les commandes doivent fonctionner sans erreur

---

## 📚 Partie 3 : Premier Container "Hello World"

```bash
# Exécuter votre premier container
docker run hello-world
```

**📖 Que se passe-t-il ?**
1. Docker cherche l'image `hello-world` localement
2. Ne la trouve pas, la télécharge depuis Docker Hub
3. Crée un container à partir de l'image
4. Exécute le container
5. Affiche un message de bienvenue
6. Le container s'arrête

**Sortie attendue :**
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

---

## 📚 Partie 4 : Comprendre les Composants

### Vérifier les Images

```bash
# Lister les images téléchargées
docker images

# Vous devriez voir hello-world
```

### Vérifier les Containers

```bash
# Lister tous les containers (même arrêtés)
docker ps -a

# Vous devriez voir le container hello-world (status: Exited)
```

---

## 📚 Partie 5 : Container Interactif

```bash
# Lancer un container Ubuntu interactif
docker run -it ubuntu bash

# Vous êtes maintenant DANS le container!
# Essayez quelques commandes:
whoami        # root
hostname      # ID du container
ls            # Système de fichiers du container
apt-get update
apt-get install -y curl
curl --version

# Quitter le container
exit
```

**💡 Explications :**
- `-it` : Mode interactif avec terminal
- `ubuntu` : Image à utiliser
- `bash` : Commande à exécuter dans le container

---

## 📚 Partie 6 : Container en Background

```bash
# Lancer nginx en background
docker run -d --name mon-nginx -p 8080:80 nginx

# Vérifier qu'il tourne
docker ps

# Tester dans votre navigateur
# Ouvrir: http://localhost:8080
# Vous devriez voir "Welcome to nginx!"
```

**💡 Explications :**
- `-d` : Mode détaché (background)
- `--name` : Donner un nom au container
- `-p 8080:80` : Mapper le port 80 du container vers le port 8080 de l'hôte

---

## 📚 Partie 7 : Gestion du Container

```bash
# Voir les logs
docker logs mon-nginx

# Voir les stats en temps réel
docker stats mon-nginx

# Arrêter le container
docker stop mon-nginx

# Redémarrer le container
docker start mon-nginx

# Supprimer le container (doit être arrêté)
docker stop mon-nginx
docker rm mon-nginx
```

---

## 📚 Partie 8 : Nettoyage

```bash
# Lister tous les containers
docker ps -a

# Supprimer tous les containers arrêtés
docker container prune -f

# Supprimer les images non utilisées
docker image prune -a -f

# Nettoyage complet (prudence!)
docker system prune -a -f --volumes
```

---

## ✅ Validation

Vérifiez que vous pouvez :

```bash
# 1. Voir la version
docker --version

# 2. Lancer un container
docker run -d --name test-nginx -p 9090:80 nginx

# 3. Vérifier qu'il tourne
docker ps | grep test-nginx

# 4. Accéder au service
curl http://localhost:9090

# 5. Nettoyer
docker stop test-nginx && docker rm test-nginx
```

**Tous ces tests doivent réussir.**

---

## 🎯 Exercice Pratique

Lancez un serveur web Apache :

```bash
# 1. Lancer Apache sur le port 8888
docker run -d --name mon-apache -p 8888:80 httpd

# 2. Vérifier les logs
docker logs mon-apache

# 3. Tester dans le navigateur
# http://localhost:8888

# 4. Exécuter une commande dans le container
docker exec mon-apache ls /usr/local/apache2/htdocs/

# 5. Arrêter et supprimer
docker stop mon-apache
docker rm mon-apache
```

---

## 🐛 Troubleshooting

### Problème : "permission denied" sur Linux

**Solution :**
```bash
# Ajouter votre user au groupe docker
sudo usermod -aG docker $USER

# Se déconnecter/reconnecter ou:
newgrp docker

# Vérifier
docker run hello-world
```

### Problème : "Cannot connect to Docker daemon"

**Solution :**
```bash
# Vérifier que Docker daemon tourne
sudo systemctl status docker

# Démarrer si nécessaire
sudo systemctl start docker

# macOS/Windows: Vérifier que Docker Desktop est lancé
```

### Problème : Port déjà utilisé

**Solution :**
```bash
# Vérifier quel processus utilise le port
# Linux/macOS
sudo lsof -i :8080

# Windows
netstat -ano | findstr :8080

# Utiliser un autre port
docker run -d -p 8081:80 nginx
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Installer Docker sur votre système
- ✅ Comprendre Docker Engine, Images, Containers
- ✅ Lancer des containers (interactif et background)
- ✅ Gérer le cycle de vie des containers
- ✅ Mapper des ports
- ✅ Voir les logs et stats
- ✅ Nettoyer votre système

---

## ➡️ Prochaine Étape

[Exercice 02 : Premiers Containers](../02-premiers-containers/README.md)

---

## 📚 Ressources

- [Docker Documentation - Get Started](https://docs.docker.com/get-started/)
- [Docker Hub](https://hub.docker.com/)
- [Play with Docker (browser)](https://labs.play-with-docker.com/)
