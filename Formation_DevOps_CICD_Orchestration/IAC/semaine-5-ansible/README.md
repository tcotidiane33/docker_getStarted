# Semaine 5 : Ansible - Configuration Management

## 🎯 Objectifs d'Apprentissage

À la fin de cette semaine, vous serez capable de :
- ✅ Comprendre les concepts de base d'Ansible, l'inventaire et les facts
- ✅ Créer et exécuter des playbooks déclaratifs (YAML)
- ✅ Utiliser les modules courants (apt, service, copy, template)
- ✅ Créer, utiliser et héberger des rôles (Ansible Galaxy)
- ✅ Déployer une stack LAMP complète automatisée

## 📋 Pré-requis

- Connaissances Linux de base
- Accès SSH à au moins 1 serveur
- Python 3 installé sur le serveur "Control Node" et les serveurs cibles

---

## 📚 Les Exercices Pratiques

### Exercice 11 - Inventaires et Ping Ad-Hoc
**Durée estimée :** 1 heure | **Niveau :** Débutant

```bash
mkdir ansible-lab && cd ansible-lab

# 1. Créer un inventaire de test (hosts.ini)
cat > hosts.ini << 'EOF'
[webservers]
localhost ansible_connection=local
# Remplacer par des IPs distantes si vous avez des VMs
# web1 ansible_host=192.168.1.10 ansible_user=ubuntu
EOF

# 2. Lancer la commande Ad-Hoc de validation
ansible webservers -i hosts.ini -m ping

# 3. Récupérer des informations système (facts) de la cible
ansible webservers -i hosts.ini -m setup | grep ansible_distribution
```

### Exercice 12 - Votre Premier Playbook
**Durée estimée :** 2 heures | **Niveau :** Débutant

Nous allons installer Nginx, le démarrer automatiquement, et uploader un fichier.
*(Ce playbook s'exécute sur le localhost avec les droits root pour l'exercice).*

```bash
cat > install_nginx.yml << 'EOF'
---
- name: Installation et configuration de Nginx
  hosts: webservers
  become: yes  # Utilise sudo

  tasks:
    - name: Garantir que Nginx est installé
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Copier la page d'accueil personnalisée
      copy:
        content: "<h1>Serveur configuré par Ansible !</h1>"
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
      notify: Restart Nginx

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
EOF

# Lancer le playbook (dry-run d'abord)
ansible-playbook -i hosts.ini install_nginx.yml --check

# Lancer pour de vrai (demande le mot de passe sudo pour le localhost)
ansible-playbook -i hosts.ini install_nginx.yml -K
```

### Exercice 13 - Créer et Utiliser des Rôles
**Durée estimée :** 2 heures | **Niveau :** Intermédiaire

Les rôles permettent de structurer et réutiliser du code Ansible.

```bash
# Créer l'architecture de base d'un rôle
ansible-galaxy init roles/mon-serveur-web

# Inspecter l'architecture générée :
# roles/mon-serveur-web/tasks, handlers, defaults, vars, template, etc.

# Déplacer vos tâches "apt" et "copy" vues précédemment
# vers roles/mon-serveur-web/tasks/main.yml
# Déplacer le handler vers roles/mon-serveur-web/handlers/main.yml

# Utiliser le rôle dans le playbook principal
cat > site.yml << 'EOF'
---
- hosts: webservers
  become: yes
  roles:
    - mon-serveur-web
EOF

ansible-playbook -i hosts.ini site.yml
```

### Exercice 14 - Templates Jinja2
**Durée estimée :** 1h30 | **Niveau :** Intermédiaire

Les templates rendent la configuration dynamique selon la cible.

```bash
mkdir -p roles/mon-serveur-web/templates
cat > roles/mon-serveur-web/templates/index.html.j2 << 'EOF'
<html>
<body>
    <h1>Bienvenue sur {{ ansible_hostname }}</h1>
    <p>Ce serveur tourne sous {{ ansible_distribution }} {{ ansible_distribution_version }}</p>
    <p>Mémoire totale : {{ ansible_memtotal_mb }} MB</p>
</body>
</html>
EOF

# Remplacer la tâche "copy" par "template" dans tasks/main.yml :
# - name: Templating accueil
#   template:
#     src: index.html.j2
#     dest: /var/www/html/index.html
```

### Exercice 15 - Projet Complet : Stack LAMP
**Durée estimée :** 3 heures | **Niveau :** Avancé

Vous devez déployer LInux, Apache, MySQL, et PHP.
1. Écrivez un rôle `apache`
2. Écrivez un rôle `mysql`, qui paramètre un root password généré
3. Écrivez un rôle `php`
4. Assemblez-les dans `lamp.yml`
5. *(Requis)* Le mot de passe MySQL doit être centralisé dans un fichier secret chiffré par **Ansible Vault**.

```bash
ansible-vault create group_vars/all/vault.yml
# Ajoutez: mysql_root_password: "MonMotDePasseSuperSecret123!"

# Pour lancer le tout :
ansible-playbook -i hosts.ini lamp.yml --ask-vault-pass
```

---

## 🛠️ Syntaxe YAML & Astuces clés

```yaml
# Boucles (avec with_items ou loop)
- name: Installer plusieurs paquets
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - vim
    - curl
    - htop

# Conditions (when)
- name: Exécuter uniquement si la machine est Debian
  apt: name=apache2
  when: ansible_os_family == "Debian"

# Variables
- debug:
    msg: "Le port est {{ nginx_port }}"
```

## 📝 Checklist de Progression Finale

- [ ] L'inventaire est clair, hiérarchisé par groupes (web, db, etc.).
- [ ] Mes tâches sont déclaratives et **idempotentes** (les lancer 10 fois ne casse rien).
- [ ] Ma logique est découpée dans des `roles`.
- [ ] La configuration intègre des variables via `templates (.j2)`.
- [ ] Les données sensibles sont chiffrées (`ansible-vault`).

---

## ⏭️ Prochaine Étape
Passez à l'intégration continue Infrastructure as Code : [Semaine 6 : Intégration](../semaine-6-integration)
