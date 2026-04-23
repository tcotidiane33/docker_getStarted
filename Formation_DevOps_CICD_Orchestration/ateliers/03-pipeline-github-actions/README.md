# Atelier 3 : Pipeline CI/CD complet via GitHub Actions

**Durée estimée :** 45 minutes  
**Type :** CI/CD & Automatisation

## 🎯 Objectif
Remplacer les actions manuelles (tests, checks, build) par un pipeline automatisé qui se déclenche à chaque `Push` ou `Pull Request` sur un dépôt Git.

---

## 🛠️ Instructions

### Étape 1 : Le Workflow de base "Continuous Integration"
1. Créez un dossier de projet avec un fichier `index.js` contenant un simple `console.log("Hello CI")`.
2. Initialisez Git (`git init`).
3. Au sein de votre dépôt, créez la structure de dossiers requise par GitHub Actions :
   `mkdir -p .github/workflows`
4. Ajoutez un fichier `ci.yml` :

```yaml
name: Node.js CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js 20.x
      uses: actions/setup-node@v3
      with:
        node-version: 20.x
        cache: 'npm'
        
    - name: Installation dependencies (Simulated)
      run: echo "npm ci would run here"

    - name: Run Tests (Simulated)
      run: echo "npm test would run here"
```

### Étape 2 : Le Build & Push Docker "Continuous Deployment"
Ajoutons une étape pour créer l'image Docker de notre application et la pousser sur le Hub Docker (ou Github Container Registry).
*Attention, ne stockez jamais de mot de passe en clair dans le code ! Utilisez Github Secrets.*

Modifiez votre workflow pour inclure l'étape de build. (Ajoutez à la fin du fichier) :
```yaml
    - name: Log in to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
        
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: false # (Mettre à true pour pousser réellement l'image si Secrets sont configurés)
        tags: user/my-app:latest
```

### Étape 3 : Exécution
1. Commitez vos changements (`git add .`, `git commit -m "add workflow"`).
2. Poussez sur votre dépôt GitHub.
3. Allez sur l'onglet **"Actions"** de votre projet sur GitHub.com.
4. Observez l'exécution des `Workers` (Runners) Ubuntu provisionnés à la volée.

---

## 📝 Livrable attendu
- Un fichier de déclaration YAML d'Actions valide.
- L'apparition d'un badge de succès vert (✅) sur un dépôt GitHub témoignant de l'exécution complète du pipeline CI (Lint/Test) pour chaque nouveau commit sur la branche Main.
