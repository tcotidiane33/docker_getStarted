# 🚀 Exercice 01 : Installation Docker

## 🎯 Objectif
Installer Docker et comprendre son fonctionnement de base.

## 💡 L'Analogie : La Machine à Photocopier
*   **Votre ordinateur** = Un bureau avec beaucoup d'espace
*   **Docker Engine** = Une **machine à photocopier industrielle**
*   **Une Image Docker** = Le **document original** que vous voulez copier
*   **Un Container** = Une **photocopie** de ce document, que vous pouvez annoter sans abîmer l'original

Quand vous installez Docker, vous installez la photocopieuse. Ensuite, vous pourrez faire autant de copies (containers) que vous voulez à partir de n'importe quel document (image).

## 🗺️ Roadmap & Étapes

### Étape 1 : Installer la Photocopieuse (Docker Desktop)
**macOS/Windows :**
1. Téléchargez Docker Desktop : https://www.docker.com/products/docker-desktop/
2. Installez comme n'importe quelle application
3. Lancez Docker Desktop
4. Attendez le whale icon 🐋 dans la barre de menu

**Linux :**
```bash
# Installation automatique
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER
newgrp docker
```

### Étape 2 : Vérifier que la Photocopieuse Fonctionne
```bash
# Version de Docker
docker --version
# Attendu : Docker version 24.x.x

# Information système
docker info
```

### Étape 3 : Première Photocopie (Hello World)
```bash
# La commande magique
docker run hello-world
```

**Ce qui se passe :**
1. Docker cherche le document original (`hello-world`) dans votre bureau
2. Ne le trouve pas, va le chercher à la bibliothèque (Docker Hub)
3. Fait une photocopie (crée un container)
4. La photocopie s'affiche, puis part à la poubelle

### Étape 4 : Photocopie Interactive (Ubuntu)
```bash
# Entrer DANS une photocopie d'Ubuntu
docker run -it ubuntu bash

# Vous êtes maintenant dans un mini-Linux !
whoami  # root
ls      # Explorez le système

# Quitter
exit
```

### Étape 5 : Photocopie Permanente (Nginx)
```bash
# Lancer un serveur web qui reste allumé
docker run -d --name mon-serveur -p 8080:80 nginx

# Vérifier qu'il tourne
docker ps

# Visiter http://localhost:8080 dans votre navigateur
# Vous voyez "Welcome to nginx!" 🎉

# Arrêter et jeter la photocopie
docker stop mon-serveur
docker rm mon-serveur
```

## ✅ Validation
Vous avez réussi si :
- ✅ `docker --version` fonctionne
- ✅ `docker run hello-world` affiche un message de bienvenue
- ✅ Vous pouvez visiter http://localhost:8080 avec Nginx

## ➡️ Prochaine Étape
[Exercice 02 : Premiers Containers](../02-premiers-containers/README.md)

**Ce que vous avez compris :**
Docker est comme une photocopieuse : vous prenez des documents originaux (images) et vous en faites des copies (containers) que vous pouvez utiliser et jeter sans abîmer l'original !
