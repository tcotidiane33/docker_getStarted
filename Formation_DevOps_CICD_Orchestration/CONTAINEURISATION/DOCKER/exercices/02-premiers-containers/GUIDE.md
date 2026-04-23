# 🐳 Exercice 02 : Premiers Containers

## 🎯 Objectif
Comprendre le cycle de vie d'un container et maîtriser les commandes de base.

## 💡 L'Analogie : Les Conteneurs de Transport
*   **Image Docker** = Le **plan de construction** d'un conteneur maritime
*   **Container** = Un **conteneur maritime réel** créé à partir du plan
*   **Docker Hub** = Le **port maritime** où sont stockés tous les plans
*   **`docker run`** = **Fabriquer** un conteneur à partir d'un plan et le mettre en route
*   **`docker stop`** = **Arrêter** le conteneur (il existe toujours, mais ne bouge plus)
*   **`docker rm`** = **Détruire** le conteneur pour de bon

## 🗺️ Roadmap & Étapes

### Étape 1 : Choisir un Plan (Pull une Image)
```bash
# Télécharger le plan "nginx" depuis le port (Docker Hub)
docker pull nginx

# Voir tous les plans que vous avez
docker images
```

**Analogie :** Vous allez chercher le plan de construction d'un conteneur à quai.

### Étape 2 : Fabriquer le Conteneur (Run)
```bash
# Créer ET démarrer un conteneur nginx
docker run nginx

# Problème : Votre terminal est bloqué !
# Ctrl+C pour arrêter
```

**Ce qui s'est passé :** Vous avez fabriqué le conteneur et l'avez mis en route, mais vous êtes resté à côté à le surveiller.

### Étape 3 : Conteneur en Autonomie (Mode Détaché)
```bash
# Lancer en arrière-plan (-d = detached)
docker run -d nginx

# Vous récupérez votre terminal !
# Docker vous donne un ID (numéro de série du conteneur)
```

**Analogie :** Le conteneur roule tout seul, vous n'avez pas besoin de rester à côté.

### Étape 4 : Surveiller les Conteneurs
```bash
# Voir les conteneurs actifs
docker ps

# Voir TOUS les conteneurs (même arrêtés)
docker ps -a
```

**Résultat :**
```
CONTAINER ID   IMAGE     STATUS    PORTS    NAMES
abc123def456   nginx     Up        80/tcp   happy_tesla
```

### Étape 5 : Nommer votre Conteneur
```bash
# Donner un nom (plutôt qu'un ID aléatoire)
docker run -d --name mon-serveur nginx

# Maintenant vous pouvez l'appeler par son nom
docker ps
```

**Analogie :** Au lieu d'appeler le conteneur "ABC123", vous l'appelez "Mon Serveur". Plus facile à retenir !

### Étape 6 : Arrêter et Redémarrer
```bash
# Arrêter le conteneur
docker stop mon-serveur

# Vérifier (STATUS = Exited)
docker ps -a

# Redémarrer le même conteneur
docker start mon-serveur

# Vérifier (STATUS = Up)
docker ps
```

### Étape 7 : Entrer dans le Conteneur (Exec)
```bash
# Ouvrir un terminal DANS le conteneur
docker exec -it mon-serveur bash

# Vous êtes à l'intérieur !
ls
whoami  # root
cat /etc/nginx/nginx.conf

# Quitter
exit
```

**Analogie :** Vous montez à bord du conteneur pour inspecter la cargaison.

### Étape 8 : Voir les Logs
```bash
# Voir ce que dit le conteneur
docker logs mon-serveur

# Suivre en temps réel (comme tail -f)
docker logs -f mon-serveur
```

### Étape 9 : Nettoyer
```bash
# Arrêter
docker stop mon-serveur

# Détruire
docker rm mon-serveur

# Ou forcer la destruction (même s'il tourne)
docker rm -f mon-serveur
```

## ✅ Validation Complète
```bash
# 1. Lancer un conteneur nommé
docker run -d --name test-apache httpd

# 2. Vérifier qu'il tourne
docker ps | grep test-apache

# 3. Voir les logs
docker logs test-apache

# 4. Entrer dedans
docker exec -it test-apache bash
ls /usr/local/apache2/htdocs
exit

# 5. Arrêter et supprimer
docker stop test-apache
docker rm test-apache
```

## 🎯 Exercice Pratique
Lancez 3 conteneurs différents simultanément :
```bash
docker run -d --name web1 nginx
docker run -d --name web2 httpd
docker run -d --name db1 postgres

# Les voir tous
docker ps

# Les arrêter tous
docker stop web1 web2 db1

# Les supprimer tous
docker rm web1 web2 db1
```

## ➡️ Prochaine Étape
[Exercice 03 : Docker CLI](../03-docker-cli/GUIDE.md)

**Ce que vous avez compris :**
Les containers sont comme des conteneurs maritimes : on les fabrique à partir d'un plan (image), on les met en route, on peut monter dedans pour inspecter, et on les détruit quand on n'en a plus besoin !
