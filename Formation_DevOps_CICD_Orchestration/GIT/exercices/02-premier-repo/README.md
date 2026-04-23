# Exercice 02 — Premier Repository Git

## 🎯 Objectifs

À la fin de cet exercice vous serez capable de :
- ✅ Initialiser un repository Git local
- ✅ Comprendre les 3 zones : Working Directory / Staging / Repository
- ✅ Créer des commits atomiques avec de bons messages
- ✅ Lire et interpréter `git log`

## ⏱️ Durée : 1 heure | Niveau : Débutant

---

## 📐 Les 3 Zones Git — Comprendre avant de pratiquer

```
┌─────────────────┐    git add    ┌──────────────┐   git commit  ┌────────────────┐
│ Working Dir     │ ────────────► │ Staging Area │ ────────────► │  Repository    │
│ (vos fichiers)  │               │ (index)      │               │  (historique)  │
└─────────────────┘               └──────────────┘               └────────────────┘
         ▲                                                                │
         └────────────────── git checkout ──────────────────────────────┘
```

---

## Partie 1 — Initialiser un projet

```bash
# Créer un dossier de travail
mkdir ~/git-training/projet-blog
cd ~/git-training/projet-blog

# Initialiser Git
git init
# → crée un dossier caché .git/ qui stocke TOUT l'historique

# Vérifier l'état (rien à commiter)
git status
```

**Attendu :**
```
On branch main
No commits yet
nothing to commit
```

---

## Partie 2 — Premier fichier et premier commit

```bash
# Créer un fichier README
cat > README.md << 'EOF'
# Mon Blog DevOps

Blog de formation pour apprendre Git.

## Auteur
Votre Nom
EOF

# Vérifier l'état (fichier non-tracké)
git status
# → README.md apparaît en rouge (Untracked)

# Ajouter au staging
git add README.md

# Vérifier l'état (fichier stagé)
git status
# → README.md apparaît en vert (Changes to be committed)

# Créer le premier commit
git commit -m "Initial commit: Add README"

# Vérifier l'historique
git log
```

**Attendu après `git log` :**
```
commit a1b2c3d... (HEAD -> main)
Author: Votre Nom <email@example.com>
Date:   ...

    Initial commit: Add README
```

---

## Partie 3 — Plusieurs commits atomiques

> **Principe :** Un commit = une modification logique. Ne pas mélanger plusieurs sujets.

```bash
# Créer la structure du blog
mkdir -p posts css

# Fichier CSS
cat > css/style.css << 'EOF'
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}
h1 { color: #333; }
EOF

# Commiter UNIQUEMENT le CSS
git add css/style.css
git commit -m "style: Add base CSS stylesheet"

# Premier article
cat > posts/2025-01-intro-git.md << 'EOF'
# Introduction à Git

Git est un système de contrôle de version distribué...

## Pourquoi Git ?
- Historique complet
- Collaboration facile
- Branches pour expérimenter
EOF

# Commiter UNIQUEMENT l'article
git add posts/2025-01-intro-git.md
git commit -m "docs: Add first blog post about Git intro"

# Page index HTML
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Blog DevOps</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Mon Blog DevOps</h1>
    <ul>
        <li><a href="posts/2025-01-intro-git.md">Introduction à Git</a></li>
    </ul>
</body>
</html>
EOF

git add index.html
git commit -m "feat: Add HTML index page"
```

---

## Partie 4 — Explorer l'historique

```bash
# Log complet
git log

# Log en une ligne (recommandé)
git log --oneline

# Log graphique
git log --oneline --graph --all

# Voir les changements d'un commit
git show HEAD         # dernier commit
git show abc123       # commit spécifique (remplacer par votre SHA)

# Voir les différences (avant staging)
echo "## Contact" >> README.md
git diff              # diff Working Dir vs Staging

# Voir les différences (après staging)
git add README.md
git diff --staged     # diff Staging vs Repository
```

---

## Partie 5 — Corriger une erreur

```bash
# Cas 1 : Modifier le message du dernier commit
git commit --amend -m "Initial commit: Add README and project structure"

# Cas 2 : Oublier un fichier dans le dernier commit
touch .gitignore
git add .gitignore
git commit --amend --no-edit   # Ajoute au dernier commit sans changer le message

# Cas 3 : Sortir un fichier du staging AVANT commit
git restore --staged README.md   # (ou: git reset HEAD README.md)
```

---

## ✅ Validation — Checklist

Avant de passer à l'exercice suivant, vérifiez :

```bash
git log --oneline
```

Vous devriez voir **au moins 4 commits** avec des messages distincts :
- [ ] `Initial commit : Add README`
- [ ] `style: Add base CSS stylesheet`
- [ ] `docs: Add first blog post about Git intro`
- [ ] `feat: Add HTML index page`

---

## 🧩 Challenge Bonus

1. Créez un fichier `.gitignore` et ignorez les fichiers `*.log` et le dossier `node_modules/`
2. Vérifiez avec `git status` que les fichiers ignorés n'apparaissent pas
3. Consultez [gitignore.io](https://www.toptal.com/developers/gitignore) pour générer un `.gitignore` adapté

```bash
cat > .gitignore << 'EOF'
# Logs
*.log
logs/

# Dépendances
node_modules/
venv/

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
EOF

# Tester
touch test.log
git status
# → test.log ne doit PAS apparaître
```

---

## ➡️ Exercice suivant

[Exercice 03 — Branches](../03-branches/README.md)
