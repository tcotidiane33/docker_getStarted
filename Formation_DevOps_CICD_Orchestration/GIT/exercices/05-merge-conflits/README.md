# Exercice 05 — Merge & Résolution de Conflits

## 🎯 Objectifs

- ✅ Provoquer intentionnellement un conflit pour comprendre son mécanisme
- ✅ Lire et interpréter les marqueurs de conflit `<<<<<<< ======= >>>>>>>`
- ✅ Résoudre un conflit manuellement et avec un outil visuel
- ✅ Éviter les conflits via de bonnes pratiques

## ⏱️ Durée : 2h | Niveau : Intermédiaire

---

## 📐 Anatomie d'un Conflit

Quand Git ne peut pas fusionner automatiquement deux modifications sur la même ligne :

```
<<<<<<< HEAD (votre branche)
const PORT = 3000;
=======
const PORT = 8080;
>>>>>>> feature/new-port

Explanation :
- Tout entre <<<<<<< HEAD et ======= : votre version (branche courante)
- Tout entre ======= et >>>>>>> : la version de la branche mergeée
- Vous devez choisir l'une ou combiner les deux, puis supprimer les marqueurs
```

---

## Partie 1 — Provoquer un conflit (intentionnel)

```bash
mkdir ~/git-training/conflict-lab && cd ~/git-training/conflict-lab
git init

# Commit initial commun aux deux branches
cat > config.js << 'EOF'
const config = {
  PORT: 3000,
  HOST: "localhost",
  ENV: "development"
};
module.exports = config;
EOF

git add config.js
git commit -m "Initial config"

# ── Branche 1 : team-a modifie le PORT ──
git switch -c feature/team-a
sed -i '' 's/PORT: 3000/PORT: 8080/' config.js   # macOS
# sed -i 's/PORT: 3000/PORT: 8080/' config.js    # Linux
git add config.js
git commit -m "feat: Change PORT to 8080 (team A)"

# ── Branche 2 : team-b modifie AUSSI le PORT sur main ──
git switch main
sed -i '' 's/PORT: 3000/PORT: 4000/' config.js   # macOS
git add config.js
git commit -m "feat: Change PORT to 4000 (team B)"

# ── MERGER → CONFLIT ! ──
git merge feature/team-a
# → CONFLICT (content): Merge conflict in config.js
# → Automatic merge failed; fix conflicts and then commit the result.
```

---

## Partie 2 — Comprendre l'état en conflit

```bash
# Voir quels fichiers sont en conflit
git status
# → both modified: config.js

# Voir le contenu du fichier avec les marqueurs
cat config.js
```

**Contenu du fichier en conflit :**
```javascript
const config = {
<<<<<<< HEAD
  PORT: 4000,
=======
  PORT: 8080,
>>>>>>> feature/team-a
  HOST: "localhost",
  ENV: "development"
};
module.exports = config;
```

---

## Partie 3 — Résoudre le conflit manuellement

```bash
# Ouvrir le fichier dans votre éditeur
code config.js   # VS Code
# ou : nano config.js
```

**Choisir la résolution :**

Option A — Garder votre version (HEAD / team-b) :
```javascript
const config = {
  PORT: 4000,  // ← on garde 4000
  HOST: "localhost",
  ENV: "development"
};
```

Option B — Garder la version mergée (team-a) :
```javascript
const config = {
  PORT: 8080,  // ← on garde 8080
  HOST: "localhost",
  ENV: "development"
};
```

Option C — Combiner intelligemment (souvent la meilleure) :
```javascript
const config = {
  PORT: process.env.PORT || 8080,   // ← variable d'env avec fallback
  HOST: "localhost",
  ENV: "development"
};
```

```bash
# Après avoir édité et supprimé TOUS les marqueurs :
# Marquer comme résolu
git add config.js

# Finaliser le merge
git commit
# → Git ouvre l'éditeur avec un message de merge pré-rempli
# → Accepter ou personnaliser le message → Sauvegarder

git log --oneline --graph --all
```

---

## Partie 4 — Conflits multiples (scénario réaliste)

```bash
# Préparer un projet multi-fichiers
mkdir -p ~/git-training/multi-conflict && cd ~/git-training/multi-conflict
git init

cat > app.py << 'EOF'
DEBUG = True
DATABASE_URL = "sqlite:///db.sqlite3"
SECRET_KEY = "dev-key"
EOF

cat > requirements.txt << 'EOF'
flask==2.0.0
sqlalchemy==1.4.0
EOF

git add . && git commit -m "Initial project config"

# Branche feature
git switch -c feature/production-config
cat > app.py << 'EOF'
DEBUG = False
DATABASE_URL = "postgresql://user:pass@prod-server/mydb"
SECRET_KEY = "super-secret-prod-key-xyz"
EOF
cat > requirements.txt << 'EOF'
flask==2.3.0
sqlalchemy==2.0.0
gunicorn==20.1.0
EOF
git add . && git commit -m "feat: Production configuration"

# Main aussi modifié
git switch main
sed -i '' 's/flask==2.0.0/flask==2.1.0/' requirements.txt
git add . && git commit -m "chore: Update Flask to 2.1.0"

# Merger → 2 fichiers en conflit
git merge feature/production-config
```

```bash
# Résoudre fichier par fichier
code app.py           # résoudre app.py
git add app.py

code requirements.txt  # résoudre requirements.txt
git add requirements.txt

git commit
```

---

## Partie 5 — Outils pour résoudre les conflits

### Option 1 : VS Code (recommandé pour débutants)

VS Code détecte les conflits et affiche des boutons cliquables :
- **Accept Current Change** → garder votre version
- **Accept Incoming Change** → garder la version mergée
- **Accept Both Changes** → garder les deux
- **Compare Changes** → vue côte à côte

### Option 2 : `git mergetool`

```bash
# Configurer VS Code comme mergetool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Lancer l'outil
git mergetool
```

### Option 3 : Abandonner le merge

```bash
# Si vous voulez annuler et revenir à l'état pré-merge
git merge --abort
```

---

## Partie 6 — Bonnes pratiques pour éviter les conflits

```bash
# 1. Toujours partir d'un main à jour
git switch main
git pull origin main
git switch -c feature/ma-feature

# 2. Faire des commits fréquents et petits

# 3. Mettre à jour sa branche régulièrement
git switch feature/ma-feature
git rebase main   # ou: git merge main

# 4. Communiquer avec l'équipe
#    → Qui travaille sur quel fichier ?
#    → Éviter de modifier les mêmes zones

# 5. Découper les fichiers volumineux
#    → config-dev.js  config-prod.js   (au lieu d'un seul config.js)
```

---

## ✅ Validation

- [ ] J'ai provoqué intentionnellement un conflit
- [ ] J'ai lu et compris les marqueurs `<<<`, `===`, `>>>`
- [ ] J'ai résolu le conflit et créé le commit de merge
- [ ] `git log --oneline --graph` montre un commit de merge valide

---

## 🧩 Challenge Bonus — Conflit de rebase

```bash
cd ~/git-training/conflict-lab

git switch -c feature/rebase-test
echo "console.log('feature');" >> config.js
git add . && git commit -m "feat: Add debug log"

git switch main
echo "console.log('main update');" >> config.js
git add . && git commit -m "chore: Add main log"

git switch feature/rebase-test
git rebase main
# → Conflit pendant le rebase

# Résoudre puis :
git add config.js
git rebase --continue   # ← différent d'un merge !

# En cas d'échec total :
# git rebase --abort
```

---

## ➡️ Exercice suivant

[Exercice 06 — Git Flow](../06-git-flow/README.md)
