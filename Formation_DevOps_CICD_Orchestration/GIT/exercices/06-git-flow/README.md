# Exercice 06 — Git Flow

## 🎯 Objectifs

- ✅ Comprendre la stratégie Git Flow et ses branches
- ✅ Implémenter un Git Flow complet (feature → develop → release → main)
- ✅ Gérer un hotfix en production
- ✅ Utiliser les tags pour les versions

## ⏱️ Durée : 3h | Niveau : Intermédiaire-Avancé

---

## 📐 Le Modèle Git Flow

```
main      ──●────────────────────────────────●──── (production stable)
              \                             / \
release/v1.0   ●─────────────────────────●      (tests finaux, fixes)
                \                       /
develop   ──●────●───────────●─────────●──── (intégration continue)
                  \         / \       /
feature/login      ●─●─●──        feature/search ●─●─●
```

### Les 5 types de branches Git Flow

| Branche | Rôle | Origine | Merge vers |
|---------|------|---------|------------|
| `main` | Code de production | — | — |
| `develop` | Intégration des features | `main` | `main` (via release) |
| `feature/*` | Nouvelles fonctionnalités | `develop` | `develop` |
| `release/*` | Préparation d'une version | `develop` | `main` + `develop` |
| `hotfix/*` | Corrections urgentes | `main` | `main` + `develop` |

---

## Partie 1 — Initialisation du workflow

```bash
mkdir ~/git-training/gitflow-lab && cd ~/git-training/gitflow-lab
git init

# Commit initial sur main
cat > README.md << 'EOF'
# Application E-Commerce
Version: 0.0.1
EOF
git add README.md && git commit -m "Initial commit"

# Créer la branche develop (base de tout le développement)
git switch -c develop

cat > app.py << 'EOF'
# Application principale
APP_VERSION = "0.0.1"
DEBUG = True
EOF
git add app.py && git commit -m "chore: Initialize develop branch with base app"

git log --oneline --all
```

---

## Partie 2 — Développer une Feature

```bash
# Feature 1 : Authentification
git switch -c feature/authentication develop

cat > auth.py << 'EOF'
def login(username, password):
    """Authentifier un utilisateur."""
    # TODO: implémenter la vraie logique
    if username == "admin" and password == "secret":
        return {"token": "jwt-token-exemple", "user": username}
    return None

def logout(token):
    """Déconnecter un utilisateur."""
    print(f"Token {token} invalidé")
    return True
EOF

git add auth.py
git commit -m "feat(auth): Add login and logout functions"

cat > tests_auth.py << 'EOF'
from auth import login, logout

def test_login_success():
    result = login("admin", "secret")
    assert result is not None
    assert "token" in result

def test_login_failure():
    result = login("admin", "wrong")
    assert result is None

def test_logout():
    assert logout("some-token") == True
EOF

git add tests_auth.py
git commit -m "test(auth): Add unit tests for auth module"

# Merger la feature dans develop (comme une PR acceptée)
git switch develop
git merge --no-ff feature/authentication -m "Merge feature/authentication into develop"
# --no-ff = force un commit de merge même si fast-forward possible (traçabilité)

git branch -d feature/authentication
```

---

## Partie 3 — Développer une seconde Feature en parallèle

```bash
git switch -c feature/product-catalog develop

cat > products.py << 'EOF'
PRODUCTS = [
    {"id": 1, "name": "Laptop Pro", "price": 1299.99, "stock": 15},
    {"id": 2, "name": "Mouse Wireless", "price": 29.99, "stock": 100},
    {"id": 3, "name": "Keyboard Mécanique", "price": 89.99, "stock": 50},
]

def get_all_products():
    return PRODUCTS

def get_product_by_id(product_id):
    return next((p for p in PRODUCTS if p["id"] == product_id), None)

def search_products(query):
    query = query.lower()
    return [p for p in PRODUCTS if query in p["name"].lower()]
EOF

git add products.py
git commit -m "feat(catalog): Add product catalog with search"

# Ajouter un fichier de config produits
cat > products.json << 'EOF'
{
  "currency": "EUR",
  "tax_rate": 0.20,
  "max_results": 50
}
EOF

git add products.json
git commit -m "feat(catalog): Add products configuration"

# Merger dans develop
git switch develop
git merge --no-ff feature/product-catalog -m "Merge feature/product-catalog into develop"
git branch -d feature/product-catalog

# Observer le graphe
git log --oneline --graph --all
```

---

## Partie 4 — Préparer une Release

```bash
# La version 1.0 est prête → créer la branche release
git switch -c release/v1.0 develop

# Sur une branche release : UNIQUEMENT des bug fixes et de la doc, PAS de nouvelles features

# Mettre à jour la version
sed -i '' 's/0.0.1/1.0.0/' README.md
sed -i '' 's/0.0.1/1.0.0/' app.py
git add README.md app.py
git commit -m "chore(release): Bump version to 1.0.0"

# Fix d'un derniere bug découvert pendant les tests
cat >> auth.py << 'EOF'

def validate_token(token):
    """Valider un token JWT."""
    if not token or len(token) < 10:
        return False
    return True
EOF

git add auth.py
git commit -m "fix(auth): Add token validation function"
```

---

## Partie 5 — Merger la Release dans main ET develop

```bash
# ── Merger dans main (mise en production) ──
git switch main
git merge --no-ff release/v1.0 -m "Release v1.0.0"

# Tagger la version de production
git tag -a v1.0.0 -m "Version 1.0.0 - First stable release
Features:
- User authentication (login/logout)
- Product catalog with search
- Token validation"

# Voir les tags
git tag -l
git show v1.0.0

# ── Merger dans develop (récupérer les fixes de la release) ──
git switch develop
git merge --no-ff release/v1.0 -m "Merge release/v1.0 back into develop"

# Supprimer la branche release
git branch -d release/v1.0

# État final
git log --oneline --graph --all
```

---

## Partie 6 — Gérer un Hotfix (bug critique en production)

```bash
# ALERTE : Bug critique découvert en production !
# Le login accepte des mots de passe vides

# Créer le hotfix DEPUIS MAIN (pas develop)
git switch main
git switch -c hotfix/fix-empty-password

# Fix du bug
cat > auth.py << 'EOF'
def login(username, password):
    """Authentifier un utilisateur."""
    # Fix : vérifier que username et password ne sont pas vides
    if not username or not password:
        return None
    if username == "admin" and password == "secret":
        return {"token": "jwt-token-exemple", "user": username}
    return None

def logout(token):
    """Déconnecter un utilisateur."""
    print(f"Token {token} invalidé")
    return True

def validate_token(token):
    """Valider un token JWT."""
    if not token or len(token) < 10:
        return False
    return True
EOF

git add auth.py
git commit -m "fix(auth): Reject empty username and password"

# Bump version patch
sed -i '' 's/1.0.0/1.0.1/' README.md app.py
git add README.md app.py
git commit -m "chore: Bump version to 1.0.1"

# ── Merger le hotfix dans main ──
git switch main
git merge --no-ff hotfix/fix-empty-password -m "Hotfix: Fix empty password authentication"
git tag -a v1.0.1 -m "Version 1.0.1 - Security hotfix: Reject empty credentials"

# ── Merger le hotfix dans develop ──
git switch develop
git merge --no-ff hotfix/fix-empty-password -m "Merge hotfix/fix-empty-password into develop"

# Supprimer le hotfix
git branch -d hotfix/fix-empty-password

# Vue finale du graphe
git log --oneline --graph --all
```

---

## ✅ Validation

```bash
# Lister tous les tags (doivent apparaître)
git tag -l
# → v1.0.0
# → v1.0.1

# Voir les branches (uniquement main et develop)
git branch
# → * develop
#     main

# Voir le graphe complet
git log --oneline --graph --all
```

Vous devez voir :
- [ ] Les merges de 2 features dans develop
- [ ] Un merge release → main avec le tag `v1.0.0`
- [ ] Un merge hotfix → main avec le tag `v1.0.1`
- [ ] Le hotfix mergé aussi dans develop

---

## 🧩 Challenge Bonus — Git Flow avec l'outil officiel

```bash
# Installer git-flow
brew install git-flow-avh  # macOS

# Initialiser
git flow init
# → répond aux questions (accepter les valeurs par défaut)

# Commencer une feature
git flow feature start user-profile

# Finir une feature (merge automatique dans develop)
git flow feature finish user-profile

# Commencer une release
git flow release start v2.0.0

# Finir une release (merge dans main + develop + tag)
git flow release finish v2.0.0
```

---

## 📚 Quand utiliser Git Flow vs GitHub Flow ?

| Critère | Git Flow | GitHub Flow |
|---------|----------|-------------|
| Releases planifiées | ✅ Idéal | ❌ Moins adapté |
| Déploiement continu | ❌ Lourd | ✅ Idéal |
| Équipe grande | ✅ Structuré | ✅ Simple |
| Applications mobiles | ✅ | ❌ |
| SaaS web | ❌ | ✅ |

---

## ➡️ Pour aller plus loin

- [CI/CD avec Git](../../CI/README.md)
- [Pro Git Book — Branching Workflows](https://git-scm.com/book/fr/v2/Les-branches-avec-Git-Travailler-avec-les-branches)
