# 🎓 Parcours d'Apprentissage Pédagogique Git

## 🎯 Approche Pédagogique

Ce parcours suit la méthode **progressive et pratique** :

1. **Comprendre le POURQUOI** avant le comment
2. **Pratiquer** avec des exemples concrets
3. **Expérimenter** en cassant et réparant
4. **Maîtriser** en formant d'autres

---

## 📚 Étape 1 : Comprendre les Fondamentaux (Jours 1-3)

### Jour 1 : Le Problème que Git Résout

**AVANT de toucher Git, comprendre :**

**Scénario sans Git :**
```
projet_v1/
projet_v2/
projet_v2_final/
projet_v2_final_FINAL/
projet_v2_final_FINAL_vraiment/

❌ Cauchemar de versioning
❌ Impossible de collaborer
❌ Pas d'historique
```

**Scénario avec Git :**
```
projet/
  .git/ (tout l'historique)

✅ Historique complet
✅ Collaboration facile
✅ Branches pour expérimenter
```

**📖 À lire :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) - Section "Pourquoi Git"

**💡 Questions à se poser :**
- Pourquoi ai-je besoin de Git ?
- Comment travaillait-on avant Git ?
- Qu'est-ce qu'un système de contrôle de version ?

**✅ Validation :** Vous pouvez expliquer à quelqu'un pourquoi Git existe

---

### Jour 2-3 : Concepts de Base

**Concepts clés à maîtriser :**
1. **Repository** : Container du projet + historique
2. **Commit** : Snapshot du code à un moment T
3. **Branch** : Ligne de développement parallèle
4. **Remote** : Repository distant (GitHub/GitLab)

**📖 À lire :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) - Concepts 1-5

**🎯 Exercice Mental :**

Dessinez sur papier :
```
1. L'historique de commits comme une timeline
2. Des branches comme des lignes parallèles
3. Un merge comme une fusion de lignes
```

**✅ Validation :** Vous pouvez dessiner et expliquer commit, branch, merge

---

## 🛠️ Étape 2 : Premiers Pas Pratiques (Jours 4-7)

### Jour 4 : Installation et Configuration

**📂 Exercice :**
- [exercices/01-installation](./exercices/01-installation)

**Objectifs :**
```bash
# 1. Installer Git
brew install git  # ou apt-get, yum selon OS

# 2. Configurer identité
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"

# 3. Vérifier
git config --list
```

**💡 Mini-projet :** Créer un compte GitHub/GitLab

**⏱️ Durée :** 30 minutes

---

### Jour 5 : Premier Repository Local

**📂 Exercice :**
- [exercices/02-premier-repo](./exercices/02-premier-repo)

**Workflow :**
```bash
# 1. Créer un dossier
mkdir mon-premier-projet
cd mon-premier-projet

# 2. Initialiser Git
git init

# 3. Créer un fichier
echo "# Mon Premier Projet" > README.md

# 4. Ajouter au staging
git add README.md

# 5. Créer le commit
git commit -m "Initial commit"

# 6. Voir l'historique
git log
```

**🎯 Expérimentation :**
```bash
# Modifier README.md
echo "Description du projet" >> README.md

# Voir les changements
git status
git diff

# Commiter
git add README.md
git commit -m "docs: Add project description"
```

**⏱️ Durée :** 1 heure

---

### Jour 6 : Remote Repository (GitHub)

**📂 Exercice :**
- [exercices/03-remote-github](./exercices/03-remote-github)

**Workflow :**
```bash
# 1. Créer repo sur GitHub (via interface web)

# 2. Ajouter le remote
git remote add origin https://github.com/username/repo.git

# 3. Push
git push -u origin main

# 4. Vérifier sur GitHub
```

**🎯 Expérimentation :**
```bash
# Cloner un autre repo
git clone https://github.com/username/autre-repo.git

# Modifier + push
cd autre-repo
echo "test" >> file.txt
git add file.txt
git commit -m "test"
git push
```

**⏱️ Durée :** 1h30

---

### Jour 7 : Pratique Intensive

**🎯 Mini-Projet : Blog Personnel**

Créer un repo avec :
```
blog/
├── README.md
├── index.html
├── style.css
└── posts/
    ├── 2025-01-01-premier-post.md
    └── 2025-01-02-deuxieme-post.md
```

**Objectifs :**
1. Créer le repo localement
2. Créer les fichiers un par un
3. Faire 1 commit par fichier
4. Push vers GitHub
5. Consulter l'historique

**⏱️ Durée :** 2 heures

---

## 🌿 Étape 3 : Branches et Collaboration (Jours 8-14)

### Jour 8-9 : Comprendre les Branches

**📖 Théorie :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) - Concept 3 (Branches)

**📂 Exercice :**
- [exercices/04-branches](./exercices/04-branches)

**Workflow :**
```bash
# 1. Créer une branche
git checkout -b feature/ajout-contact

# 2. Travailler
touch contact.html
git add contact.html
git commit -m "feat: Add contact page"

# 3. Revenir sur main
git checkout main

# 4. Voir toutes les branches
git branch

# 5. Supprimer une branche
git branch -d feature/ajout-contact
```

**🎯 Expérimentation :**
Créer 3 branches :
- `feature/header`
- `feature/footer`
- `feature/sidebar`

Travailler sur chacune, puis merger dans `main`

**⏱️ Durée :** 2-3 heures

---

### Jour 10-11 : Merge et Conflits

**📂 Exercice :**
- [exercices/05-merge-conflits](./exercices/05-merge-conflits)

**Scénario de Conflit :**
```bash
# 1. Créer branche + modifier fichier
git checkout -b feature/theme
echo "color: blue" >> style.css
git commit -am "style: Blue theme"

# 2. Revenir sur main + modifier MÊME fichier
git checkout main
echo "color: red" >> style.css
git commit -am "style: Red theme"

# 3. Merger → CONFLIT!
git merge feature/theme

# 4. Résoudre
# Éditer style.css
# Choisir couleur finale
git add style.css
git commit
```

**💡 Journal d'apprentissage :**
- Qu'est-ce qui cause un conflit ?
- Comment ai-je résolu le conflit ?
- Comment éviter les conflits ?

**⏱️ Durée :** 3 heures

---

### Jour 12-13 : Pull Requests et Code Review

**📂 Exercice :**
- [exercices/06-pull-requests](./exercices/06-pull-requests)

**Workflow GitHub Flow :**
```bash
# 1. Créer branche
git checkout -b feature/new-feature

# 2. Travailler + commit
git add .
git commit -m "feat: Add new feature"

# 3. Push
git push origin feature/new-feature

# 4. Créer Pull Request sur GitHub
# → Interface web GitHub
# → "New Pull Request"
# → Décrire les changements
# → Assigner reviewers

# 5. Après review → Merge
```

**🎯 Projet Collaboratif :**
- Trouver un projet open source sur GitHub
- Fork le projet
- Créer une amélioration (fix typo dans docs)
- Soumettre une Pull Request

**⏱️ Durée :** 3 heures

---

### Jour 14 : Git Flow

**📖 Théorie :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) - Concept 7 (Git Flow)

**📂 Exercice :**
- [exercices/07-git-flow](./exercices/07-git-flow)

**Structure :**
```bash
# 1. Créer develop
git checkout -b develop

# 2. Feature depuis develop
git checkout -b feature/login develop
# ... travailler
git checkout develop
git merge feature/login

# 3. Release
git checkout -b release/v1.0 develop
# ... tests
git checkout main
git merge release/v1.0
git tag v1.0

# 4. Hotfix (urgent!)
git checkout -b hotfix/security main
# ... fix
git checkout main
git merge hotfix/security
git checkout develop
git merge hotfix/security
```

**⏱️ Durée :** 4 heures

---

## 🚀 Étape 4 : Commandes Avancées (Semaine 3)

### Jour 15-16 : Rebase

**📖 Théorie :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) - Concept 6 (Rebase vs Merge)

**📂 Exercice :**
- [exercices/08-rebase](./exercices/08-rebase)

**Scénario :**
```bash
# 1. Créer feature branch
git checkout -b feature/ui

# 2. Main avance (simuler)
git checkout main
echo "update" >> README.md
git commit -am "Update README"

# 3. Feature branch veut ces updates
git checkout feature/ui
git rebase main  # ← Réapplique commits de feature/ui sur main

# VS merge:
git merge main  # ← Crée un commit de merge
```

**⚠️ Règle d'Or :**
> Ne jamais rebaser des commits déjà pushés et partagés !

**⏱️ Durée :** 3 heures

---

### Jour 17 : Stash, Cherry-Pick, Reset

**📂 Exercice :**
- [exercices/09-commandes-avancees](./exercices/09-commandes-avancees)

**Stash (mettre de côté) :**
```bash
# Travail en cours, besoin de changer de branche
git stash

# Revenir plus tard
git stash pop
```

**Cherry-pick (copier un commit) :**
```bash
# Copier commit abc123 vers branche actuelle
git cherry-pick abc123
```

**Reset (annuler) :**
```bash
# Annuler dernier commit (garde changements)
git reset --soft HEAD~1

# Annuler dernier commit (SUPPRIME changements)
git reset --hard HEAD~1  # ⚠️ DANGER
```

**⏱️ Durée :** 2 heures

---

### Jour 18-19 : Git Hooks

**📂 Exercice :**
- [exercices/10-git-hooks](./exercices/10-git-hooks)

**Créer un pre-commit hook :**
```bash
# 1. Créer fichier
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
echo "Running pre-commit checks..."

# Linter
npm run lint || exit 1

# Tests
npm test || exit 1

echo "✅ All checks passed"
EOF

# 2. Rendre exécutable
chmod +x .git/hooks/pre-commit

# 3. Tester
git commit -m "test"
# → Hook s'exécute automatiquement
```

**🎯 Projet :**
Créer hooks pour :
- `pre-commit` : Lint + tests
- `commit-msg` : Valider format du message
- `pre-push` : Tests complets

**⏱️ Durée :** 3 heures

---

### Jour 20-21 : Rebase Interactif (Nettoyage Historique)

**📂 Exercice :**
- [exercices/11-rebase-interactif](./exercices/11-rebase-interactif)

**Use Case : Nettoyer commits avant PR**
```bash
# Historique désordonné:
abc123 - "WIP"
def456 - "fix typo"
ghi789 - "actually add feature"
jkl012 - "oops forgot file"

# Rebase interactif (4 derniers commits)
git rebase -i HEAD~4

# Éditeur s'ouvre:
pick abc123 WIP
squash def456 fix typo       # ← Fusionner avec précédent
squash ghi789 add feature
squash jkl012 forgot file

# Résultat: 1 seul commit propre
mno345 - "feat: Add new feature"
```

**⚠️ Seulement sur branches NON pushées !**

**⏱️ Durée:** 3 heures

---

## 🏆 Étape 5 : Projets Intégrateurs (Semaine 4)

### Projet 1 : Portfolio Personnel avec Git

**Objectif :** Site web statique versionné

**Structure :**
```
portfolio/
├── .gitignore
├── README.md
├── index.html
├── css/
│   └── style.css
├── js/
│   └── main.js
└── images/
```

**Workflow Git :**
```bash
# 1. Init + remote
git init
git remote add origin https://github.com/you/portfolio.git

# 2. Branches par feature
git checkout -b feature/header
git checkout -b feature/projects
git checkout -b feature/contact

# 3. GitHub Pages deployment
git checkout -b gh-pages
git push origin gh-pages
# → Site live sur https://you.github.io/portfolio
```

**⏱️ Durée :** 1 weekend

---

### Projet 2 : Contribution Open Source

**Objectif :** Contribuer à un vrai projet

**Étapes :**
```bash
# 1. Fork projet sur GitHub

# 2. Clone votre fork
git clone https://github.com/YOU/projet.git

# 3. Ajouter upstream (repo original)
git remote add upstream https://github.com/ORIGINAL/projet.git

# 4. Créer branche
git checkout -b fix/documentation

# 5. Travailler + commit
git commit -m "docs: Fix typo in README"

# 6. Push + PR
git push origin fix/documentation
# → Créer PR sur GitHub

# 7. Rester à jour avec upstream
git fetch upstream
git rebase upstream/main
```

**💡 Suggestions de projets pour débutants :**
- First Timers Only
- Good First Issue (label GitHub)
- Up For Grabs

**⏱️ Durée :** 1 semaine

---

## 📊 Évaluation de la Progression

### Auto-Évaluation par Niveau

**🌱 Niveau 1 - Débutant (Jours 1-7)**

Je peux :
- [ ] Expliquer ce qu'est Git
- [ ] Faire init, add, commit, push
- [ ] Cloner un repository
- [ ] Voir l'historique avec `git log`
- [ ] Utiliser GitHub basique

**🌿 Niveau 2 - Intermédiaire (Jours 8-14)**

Je peux :
- [ ] Créer et gérer des branches
- [ ] Merger des branches
- [ ] Résoudre des conflits
- [ ] Faire des Pull Requests
- [ ] Travailler en équipe

**🌳 Niveau 3 - Avancé (Jours 15-21)**

Je peux :
- [ ] Utiliser rebase efficacement
- [ ] Nettoyer l'historique (rebase interactif)
- [ ] Configurer des hooks
- [ ] Utiliser cherry-pick et stash
- [ ] Appliquer Git Flow

**🚀 Niveau 4 - Expert**

Je peux :
- [ ] Former d'autres personnes
- [ ] Résoudre des situations complexes
- [ ] Optimiser workflows Git
- [ ] Contribuer à l'open source régulièrement

---

## 💡 Méthodologie d'Apprentissage

### La Règle des 3C

**Comprendre** → **Coder** → **Consolider**

1. **Comprendre** (20%) : Lire concepts
2. **Coder** (60%) : Pratiquer exercices
3. **Consolider** (20%) : Expliquer à quelqu'un

### Routine Quotidienne Recommandée

**🌅 Matin (30 min) :**
- Lire un concept dans CONCEPTS-PEDAGOGIQUES.md
- Regarder un git log d'un projet open source

**🏗️ Pratique (1-2h) :**
- Suivre un exercice
- Expérimenter : modifier, casser, réparer

**🌙 Soir (15 min) :**
- Mettre à jour journal : `git-learning.md`
- Noter ce qui a été appris
- Identifier blocages

### Apprentissage par l'Erreur

**Les erreurs sont vos amies !**

```bash
# Exercice volontaire:
# 1. Créer conflit intentionnel → Résoudre
# 2. Faire mauvais merge → Annuler avec reset
# 3. Oublier de pull → Résoudre divergence
```

**Journal d'erreurs :**
```markdown
## Erreur rencontrée
`error: Your local changes would be overwritten by merge`

## Solution trouvée
git stash → git pull → git stash pop

## Leçon apprise
Toujours stash/commit avant de pull
```

---

## 📚 Ressources Complémentaires

### Par Type d'Apprentissage

**Lecture :**
- [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md)
- [Pro Git Book](https://git-scm.com/book/fr/v2) (gratuit)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)

**Pratique Interactive :**
- [Learn Git Branching](https://learngitbranching.js.org/?locale=fr_FR) ⭐
- [Git Kata](https://github.com/eficode-academy/git-katas)
- [Oh My Git!](https://ohmygit.org/) (jeu)

**Vidéo :**
- [Git & GitHub Crash Course - Traversy Media](https://www.youtube.com/watch?v=SWYqp7iY_Tc)
- [Git for Professionals - FreeCodeCamp](https://www.youtube.com/watch?v=Uszj_k0DGsg)

**Communauté :**
- [r/git](https://reddit.com/r/git)
- [Stack Overflow - git tag](https://stackoverflow.com/questions/tagged/git)

---

## 🎯 Objectifs d'Apprentissage SMART

### Exemple d'objectifs par semaine

**Semaine 1 :**
- **S**pécifique : Maîtriser add, commit, push, pull
- **M**esurable : Faire 20 commits répartis sur 3 repos
- **A**tteignable : 4-6h de pratique
- **R**éaliste : Niveau débutant
- **T**emporel : 7 jours

**Semaine 2 :**
- **S**pécifique : Créer et merger 5 branches différentes
- **M**esurable : Résoudre 3 conflits intentionnels
- **A**tteignable : 6-8h de pratique
- **R**éaliste : Après semaine 1
- **T**emporel : 7 jours

---

## 🎉 Le Mot de la Fin

> "Git est comme un superpouvoir : il faut pratiquer pour le maîtriser, mais une fois acquis, on ne peut plus s'en passer."

**Principes clés :**
1. 🧠 **Comprendre** avant de mémoriser
2. 🛠️ **Pratiquer** tous les jours
3. 💥 **Casser** des choses (en dev !)
4. 📝 **Documenter** votre parcours
5. 🤝 **Partager** avec la communauté

**Prochain module :** [CONTAINER/DOCKER](../CONTAINER/DOCKER/PARCOURS-PEDAGOGIQUE.md) 🐳

---

**Bon apprentissage !** 💪
