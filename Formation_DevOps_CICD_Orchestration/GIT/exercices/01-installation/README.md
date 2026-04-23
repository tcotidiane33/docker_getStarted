# Exercice 01 : Installation et Configuration Git

## 🎯 Objectifs

À la fin de cet exercice, vous saurez :
- ✅ Installer Git sur votre système
- ✅ Configurer votre identité Git
- ✅ Vérifier votre installation
- ✅ Configurer votre éditeur par défaut

## ⏱️ Durée Estimée
**30 minutes**

## 📋 Prérequis
- Aucun (exercice pour débutants absolus)
- Accès terminal/command line

---

## 📚 Partie 1 : Installation

### macOS
```bash
# Option 1: Homebrew (recommandé)
brew install git

# Option 2: Xcode Command Line Tools
xcode-select --install
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install git
```

### Linux (Fedora/RHEL)
```bash
sudo dnf install git
```

### Windows
1. Télécharger depuis [git-scm.com](https://git-scm.com/download/win)
2. Lancer l'installateur
3. Options recommandées :
   - ✅ Git from the command line and also from 3rd-party software
   - ✅ Use Git and optional Unix tools from Windows Command Prompt

---

## 📚 Partie 2 : Vérification

```bash
# Vérifier version (should be 2.30+)
git --version

# Exemple output:
# git version 2.39.1
```

**✅ Checkpoint :** La commande doit afficher une version de Git

---

## 📚 Partie 3 : Configuration Identité

```bash
# Configurer nom (remplacer par votre nom)
git config --global user.name "Votre Nom"

# Configurer email (remplacer par votre email)
git config --global user.email "votre.email@example.com"

# Vérifier configuration
git config --global user.name
git config --global user.email
```

**💡 Pourquoi c'est important ?**  
Chaque commit Git sera signé avec ces informations. Utilisez le même email que votre compte GitHub/GitLab.

---

## 📚 Partie 4 : Configuration Éditeur

```bash
# Option 1: VS Code (recommandé)
git config --global core.editor "code --wait"

# Option 2: Vim
git config --global core.editor "vim"

# Option 3: Nano
git config --global core.editor "nano"

# Option 4: Sublime Text
git config --global core.editor "subl -w"
```

---

## 📚 Partie 5 : Autres Configurations Utiles

```bash
# Couleurs automatiques (facilite lecture)
git config --global color.ui auto

# Branche par défaut 'main' au lieu de 'master'
git config --global init.defaultBranch main

# Afficher état complet dans status
git config --global status.showUntrackedFiles all

# Cache credentials (15 min)
git config --global credential.helper cache
```

---

## 📚 Partie 6 : Vérifier Toute la Configuration

```bash
# Voir toute la config
git config --list

# Voir config globale seulement
git config --global --list

# Exemple output:
# user.name=John Doe
# user.email=john@example.com
# core.editor=code --wait
# color.ui=auto
# init.defaultbranch=main
```

---

## ✅ Validation

Vérifiez que vous avez tout configuré :

```bash
# Test complet
git config --global user.name
git config --global user.email
git config --global core.editor
git config --global init.defaultBranch
```

**Tous ces commands doivent retourner une valeur.**

---

## 🎯 Exercice Bonus

### Créer des Alias Git

```bash
# Alias pour status court
git config --global alias.st status

# Alias pour log graphique
git config --global alias.lg "log --graph --oneline --all --decorate"

# Alias pour commit avec message
git config --global alias.cm "commit -m"

# Alias pour checkout
git config --global alias.co checkout

# Tester
git st        # équivalent à: git status
git lg        # log graphique
```

---

## 📖 Fichier de Configuration

Votre configuration est stockée dans `~/.gitconfig` :

```bash
# Voir le fichier
cat ~/.gitconfig

# Éditer manuellement
code ~/.gitconfig
```

**Exemple de ~/.gitconfig :**
```ini
[user]
    name = John Doe
    email = john@example.com
[core]
    editor = code --wait
[color]
    ui = auto
[init]
    defaultBranch = main
[alias]
    st = status
    lg = log --graph --oneline --all --decorate
```

---

## 🐛 Troubleshooting

### Problème : `git: command not found`

**Solution :**
```bash
# Vérifier PATH
echo $PATH

# Relancer terminal
# Ou ajouter Git au PATH dans ~/.zshrc ou ~/.bashrc
export PATH="/usr/local/bin:$PATH"
```

### Problème : Credentials demandés à chaque push

**Solution :**
```bash
# macOS
git config --global credential.helper osxkeychain

# Linux
git config --global credential.helper store

# Windows
git config --global credential.helper wincred
```

---

## 🎓 Ce Que Vous Avez Appris

- ✅ Installer Git
- ✅ Configurer identité (name, email)
- ✅ Choisir éditeur par défaut
- ✅ Personnaliser avec alias
- ✅ Où est stockée la configuration

---

## ➡️ Prochaine Étape

[Exercice 02 : Premier Repository](../02-premier-repo/README.md)

---

## 📚 Ressources

- [Git Documentation - Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- [GitHub: Set up Git](https://docs.github.com/en/get-started/quickstart/set-up-git)
