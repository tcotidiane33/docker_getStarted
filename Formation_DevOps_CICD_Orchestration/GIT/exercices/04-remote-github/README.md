# Exercice 04 — Remote & GitHub

## 🎯 Objectifs

- ✅ Connecter un repo local à GitHub/GitLab
- ✅ Comprendre `origin`, `push`, `pull`, `fetch`
- ✅ Cloner un repository existant
- ✅ Gérer les clés SSH

## ⏱️ Durée : 1h30 | Niveau : Débutant-Intermédiaire

---

## 📐 Architecture Remote

```
┌──────────────────┐              ┌──────────────────┐
│  Votre Machine   │              │     GitHub       │
│  (local)         │              │    (remote)      │
│                  │   git push   │                  │
│  git commit ─────┼─────────────►│  origin/main     │
│                  │              │                  │
│  ◄───────────────┼──────────────┤                  │
│       git pull   │              │                  │
└──────────────────┘              └──────────────────┘
           ▲
    git clone (première fois)
```

---

## Partie 1 — Authentification SSH (recommandé)

> L'authentification SSH évite de saisir votre mot de passe à chaque push.

```bash
# 1. Générer une clé SSH
ssh-keygen -t ed25519 -C "votre.email@example.com"
# → Appuyer Entrée pour tout mettre par défaut

# 2. Afficher la clé publique
cat ~/.ssh/id_ed25519.pub
# → Copier tout ce texte

# 3. Sur GitHub :
#    Settings → SSH and GPG keys → New SSH key → Coller

# 4. Tester la connexion
ssh -T git@github.com
# → Hi username! You've successfully authenticated...
```

---

## Partie 2 — Pousser un repo local vers GitHub

```bash
# 1. Créer un nouveau repo sur GitHub
#    → github.com → New repository
#    → Nom : "git-training"
#    → Public, sans README (on en a déjà un)

# 2. Reprendre le projet de l'exercice 02 ou 03
cd ~/git-training/projet-blog

# 3. Ajouter le remote
git remote add origin git@github.com:VOTRE_USERNAME/git-training.git

# 4. Vérifier
git remote -v
# → origin  git@github.com:VOTRE_USERNAME/git-training.git (fetch)
# → origin  git@github.com:VOTRE_USERNAME/git-training.git (push)

# 5. Pousser (premier push)
git push -u origin main
# -u = --set-upstream : lie la branche locale à origin/main
# Désormais, "git push" suffit

# 6. Vérifier sur GitHub
#    → Votre code est visible !
```

---

## Partie 3 — Simuler un collaborateur (fetch vs pull)

```bash
# SIMULATION : Un collègue a poussé du code
# (sur GitHub, modifier un fichier manuellement via l'interface web)
# → Éditer README.md → Ajouter "Édité par GitHub" → Commit

# Vérifier en local
git fetch origin
# → Download les changements SANS les appliquer

git status
# → Your branch is behind 'origin/main' by 1 commit

git log --oneline --all
# → * abc123 (origin/main) Update README.md via GitHub
#    * def456 (HEAD -> main) feat: Add HTML index page

# Appliquer les changements
git merge origin/main
# → Fast-forward

# Raccourci : fetch + merge en une commande
git pull origin main
```

**Différence clé :**
| Commande | Ce qu'elle fait |
|----------|----------------|
| `git fetch` | Télécharge sans modifier vos fichiers |
| `git pull` | Télécharge ET applique (fetch + merge) |

---

## Partie 4 — Cloner un projet existant

```bash
# Cloner un repo public (exemple : un projet open source)
cd ~/git-training
git clone https://github.com/github/gitignore.git

# Explorer
cd gitignore
git log --oneline -10   # 10 derniers commits
git branch -a           # toutes les branches (locales + remote)
git remote -v           # url du remote
```

---

## Partie 5 — Workflow collaboratif complet

```bash
# Scénario : Vous travaillez en équipe sur un projet commun

# 1. Récupérer les dernières modifications
git pull origin main

# 2. Créer votre branche de travail
git switch -c feature/mon-amelioration

# 3. Travailler + commit
echo "## Nouvelle section" >> README.md
git add README.md
git commit -m "docs: Add new section to README"

# 4. Pousser votre branche
git push origin feature/mon-amelioration

# 5. Créer une Pull Request sur GitHub
#    → "Compare & pull request" apparaît automatiquement
#    → Décrire les changements
#    → Assigner un reviewer

# 6. Après review : merger via GitHub
#    → "Merge pull request" → Confirm

# 7. Mettre à jour votre main local
git switch main
git pull origin main
git branch -d feature/mon-amelioration
```

---

## Partie 6 — Gérer les remotes multiples

```bash
# Cas fork d'un projet open source
git clone git@github.com:VOUS/projet-forke.git
cd projet-forke

# Ajouter le repo original comme "upstream"
git remote add upstream git@github.com:ORIGINAL/projet.git

# Voir tous les remotes
git remote -v
# → origin    git@github.com:VOUS/projet-forke.git
# → upstream  git@github.com:ORIGINAL/projet.git

# Mettre à jour votre fork depuis l'original
git fetch upstream
git switch main
git merge upstream/main
git push origin main
```

---

## ✅ Validation

- [ ] `git remote -v` affiche votre URL GitHub
- [ ] `git push -u origin main` a fonctionné
- [ ] Votre code est visible sur GitHub dans le navigateur
- [ ] `git pull` a rapatrié les changements faits sur GitHub

---

## 🧩 Challenge Bonus

1. Créez un **deuxième clone** du même repo dans un autre dossier (simuler un collègue) :
```bash
cd ~/git-training
git clone git@github.com:VOUS/git-training.git clone-collegue
```

2. Faites un commit dans `clone-collegue` et poussez

3. Dans votre dossier original, faites `git pull` et constatez la mise à jour

---

## ➡️ Exercice suivant

[Exercice 05 — Merge & Conflits](../05-merge-conflits/README.md)
