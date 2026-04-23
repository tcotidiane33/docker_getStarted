# 🌿 GIT — Contrôle de Version

> **Prérequis :** Aucun | **Durée totale :** ~3 semaines | **Niveau :** Débutant → Avancé

---

## 🗺️ Structure du Module

```
GIT/
├── README.md                  ← Ce fichier (navigation + référence rapide)
├── CONCEPTS-PEDAGOGIQUES.md   ← Comprendre les concepts en profondeur
├── PARCOURS-PEDAGOGIQUE.md    ← Plan jour par jour (3 semaines)
├── CI/
│   └── README.md              ← CI/CD : GitHub Actions, GitLab CI
└── exercices/
    ├── 01-installation/       ← Installer et configurer Git
    ├── 02-premier-repo/       ← init, add, commit, log
    ├── 03-branches/           ← branch, checkout, merge
    ├── 04-remote-github/      ← clone, push, pull, remote
    ├── 05-merge-conflits/     ← Résoudre les conflits
    └── 06-git-flow/           ← Workflow professionnel
```

---

## 🎯 Par où commencer ?

| Objectif | Aller vers |
|----------|-----------|
| Je débute Git | [Exercice 01](./exercices/01-installation/) |
| Je veux comprendre les concepts | [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) |
| Je cherche un plan structuré | [PARCOURS-PEDAGOGIQUE.md](./PARCOURS-PEDAGOGIQUE.md) |
| Je veux apprendre CI/CD | [CI/README.md](./CI/README.md) |

---

## ⚡ Référence Rapide — Commandes Essentielles

### Setup initial
```bash
git config --global user.name  "Prénom Nom"
git config --global user.email "email@example.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
```

### Workflow quotidien
```bash
git status                     # État des fichiers
git add .                      # Stager tout
git add fichier.txt            # Stager un fichier
git commit -m "feat: message"  # Créer un commit
git push origin main           # Envoyer sur remote
git pull origin main           # Récupérer depuis remote
git log --oneline --graph      # Voir l'historique
```

### Branches
```bash
git branch                     # Lister les branches locales
git checkout -b feature/nom    # Créer + basculer (ancienne syntaxe)
git switch -c feature/nom      # Créer + basculer (moderne)
git switch main                # Basculer sur main
git merge feature/nom          # Merger dans la branche courante
git branch -d feature/nom      # Supprimer branche (local)
git push origin --delete nom   # Supprimer branche (remote)
```

### Avancé
```bash
git stash                      # Mettre de côté les modifs
git stash pop                  # Récupérer les modifs
git rebase main                # Rebaser sur main
git rebase -i HEAD~3           # Rebase interactif (3 derniers commits)
git cherry-pick abc123         # Copier un commit
git reset --soft HEAD~1        # Annuler dernier commit (garde modifs)
git revert abc123              # Annuler un commit (crée un nouveau commit)
```

### Convention des messages de commit
```
feat:      Nouvelle fonctionnalité
fix:       Correction de bug
docs:      Documentation uniquement
refactor:  Refactoring sans changement fonctionnel
test:      Ajout/modification de tests
chore:     Tâches de maintenance
style:     Formatage (pas de logique changée)

Exemple : feat(auth): Add JWT token validation
```

---

## 📊 Exercices — Tableau de Bord

| # | Exercice | Durée | Compétences |
|---|----------|-------|-------------|
| 01 | [Installation & Config](./exercices/01-installation/) | 30 min | Setup |
| 02 | [Premier Repository](./exercices/02-premier-repo/) | 1h | init, add, commit, log |
| 03 | [Branches](./exercices/03-branches/) | 1h30 | branch, switch, merge |
| 04 | [Remote & GitHub](./exercices/04-remote-github/) | 1h30 | clone, push, pull |
| 05 | [Merge & Conflits](./exercices/05-merge-conflits/) | 2h | résolution de conflits |
| 06 | [Git Flow](./exercices/06-git-flow/) | 3h | Workflow professionnel |

---

## ✅ Checklist de Progression

- [ ] **Niveau 1** : Je sais faire `add` / `commit` / `push`
- [ ] **Niveau 2** : Je crée et merge des branches, je résous les conflits
- [ ] **Niveau 3** : Je fais des Pull Requests et utilise Git Flow
- [ ] **Niveau 4** : Je maîtrise rebase, stash, cherry-pick et les hooks

---

*"Git is not a replacement for thinking."* — Linus Torvalds
