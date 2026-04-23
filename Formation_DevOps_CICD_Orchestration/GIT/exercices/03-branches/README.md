# Exercice 03 — Branches Git

## 🎯 Objectifs

- ✅ Comprendre pourquoi les branches sont essentielles
- ✅ Créer, basculer, lister et supprimer des branches
- ✅ Réaliser un merge fast-forward et un merge 3-way
- ✅ Comprendre le résultat des merges dans le graphe d'historique

## ⏱️ Durée : 1h30 | Niveau : Débutant-Intermédiaire

---

## 📐 Visualisation des branches

```
main     : A ─── B ─────────────── F
                  \               /
feature  :         C ─── D ─── E
```

- **A, B** : commits sur main avant la branche
- **C, D, E** : commits sur feature (travail isolé)
- **F** : commit de merge (fusion dans main)

---

## Partie 1 — Préparer le terrain

> Continuez depuis le projet de l'exercice 02, ou créez en un nouveau :

```bash
mkdir ~/git-training/branches-lab && cd ~/git-training/branches-lab
git init
echo "# Projet Branches Lab" > README.md
git add README.md && git commit -m "Initial commit"
```

---

## Partie 2 — Créer et utiliser une branche

```bash
# Vérifier sur quelle branche on est
git branch
# → * main   (l'étoile = branche courante)

# Créer une branche feature (syntaxe moderne recommandée)
git switch -c feature/page-contact

# Vérifier
git branch
# → * feature/page-contact
#     main

# Créer le fichier contact
cat > contact.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><title>Contact</title></head>
<body>
    <h1>Contact</h1>
    <p>Email : formation@devops.fr</p>
</body>
</html>
EOF

git add contact.html
git commit -m "feat: Add contact page"

# Ajouter une ligne
echo "<p>Tél : 01 23 45 67 89</p>" >> contact.html
git add contact.html
git commit -m "feat: Add phone number to contact page"
```

---

## Partie 3 — Observer le graphe

```bash
# Log graphique (avant merge)
git log --oneline --graph --all

# Attendu :
# * abc123 (HEAD -> feature/page-contact) feat: Add phone number
# * def456 feat: Add contact page
# * ghi789 (main) Initial commit
```

---

## Partie 4 — Merge Fast-Forward

> **Fast-forward** : main n'a pas avancé ⟹ Git déplace simplement le pointeur

```bash
# Retourner sur main
git switch main

# Vérifier que main n'a pas bougé
git log --oneline
# → ghi789 Initial commit   (un seul commit)

# Merger la feature
git merge feature/page-contact

# Résultat
git log --oneline --graph --all
# → * abc123 (HEAD -> main, feature/page-contact) feat: Add phone number
#    * def456 feat: Add contact page
#    * ghi789 Initial commit
# Pas de commit de merge : c'est un fast-forward
```

---

## Partie 5 — Merge Three-Way (avec commit de merge)

> **Three-way** : les deux branches ont avancé ⟹ Git crée un commit de merge

```bash
# Créer une nouvelle branche depuis main
git switch -c feature/page-about

cat > about.html << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><title>À propos</title></head>
<body>
    <h1>À propos</h1>
    <p>Formation DevOps — Apprendre Git efficacement.</p>
</body>
</html>
EOF

git add about.html
git commit -m "feat: Add about page"

# PENDANT CE TEMPS : simuler un commit sur main
git switch main
echo "<!-- footer -->" >> contact.html
git add contact.html
git commit -m "style: Add footer comment to contact"

# Maintenant les DEUX branches ont avancé → three-way merge
git merge feature/page-about
# → Git ouvre l'éditeur pour le message du commit de merge
# → Accepter le message par défaut (Ctrl+X sous nano, :wq sous vim)

# Observer le graphe
git log --oneline --graph --all
# → *   xxxxxx (HEAD -> main) Merge branch 'feature/page-about'
#   |\
#   | * yyyyyy (feature/page-about) feat: Add about page
#   * | zzzzzz style: Add footer comment to contact
#   |/
#   * abc123 feat: Add phone number
```

---

## Partie 6 — Supprimer les branches mergées

```bash
# Lister les branches mergées (propres à supprimer)
git branch --merged
# → feature/page-contact
#    feature/page-about
#    * main

# Supprimer les branches locales
git branch -d feature/page-contact
git branch -d feature/page-about

# -D (force) = supprimer même si non mergée (attention !)
# git branch -D feature/wip   ← perte des commits !
```

---

## ✅ Validation

```bash
git log --oneline --graph --all
```

Vous devez voir :
- [ ] Un merge commit (Three-Way) avec les deux parents
- [ ] `main` sur le commit le plus récent
- [ ] Plus de branches `feature/*` dans la liste `git branch`

---

## 🧩 Challenge Bonus — Simuler un workflow d'équipe

```bash
# 1. Créer 3 branches simultanées depuis main
git switch -c feature/header
echo "<header>Mon Site</header>" > header.html
git add header.html && git commit -m "feat: Add header"

git switch main
git switch -c feature/footer
echo "<footer>© 2025</footer>" > footer.html
git add footer.html && git commit -m "feat: Add footer"

git switch main
git switch -c feature/nav
echo "<nav>Menu</nav>" > nav.html
git add nav.html && git commit -m "feat: Add navigation"

# 2. Merger les 3 une par une
git switch main
git merge feature/header
git merge feature/footer
git merge feature/nav

# 3. Afficher le graphe final
git log --oneline --graph --all
```

---

## ➡️ Exercice suivant

[Exercice 04 — Remote & GitHub](../04-remote-github/README.md)
