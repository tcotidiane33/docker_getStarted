# 🔄 CI/CD - Continuous Integration / Continuous Deployment

## 🎯 Qu'est-ce que le CI/CD ?

### CI (Continuous Integration)
**Objectif :** Intégrer le code fréquemment et automatiquement

**Pipeline typique :**
```
Code Push → Build → Tests → Lint → Security Scan
```

### CD (Continuous Deployment/Delivery)
**Objectif :** Déployer automatiquement en production

**Pipeline typique :**
```
CI Success → Package → Deploy Staging → Tests E2E → Deploy Prod
```

---

## 📚 Parcours 2 Semaines

### Semaine 1 : CI (Continuous Integration)

#### GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Lint
      run: npm run lint
    
    - name: Test
      run: npm test
    
    - name: Build
      run: npm run build
    
    - name: Security Scan
      run: npm audit
```

#### GitLab CI
```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - security

build:
  stage: build
  image: node:18
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

test:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm test
  coverage: '/Coverage: \d+\.\d+%/'

security:
  stage: security
  image: node:18
  script:
    - npm audit
  allow_failure: true
```

---

### Semaine 2 : CD (Continuous Deployment)

#### Déploiement Docker
```yaml
deploy:
  stage: deploy
  image: docker:latest
  services:
    - docker:dind
  script:
    # Build image
    - docker build -t myapp:$CI_COMMIT_SHA .
    
    # Push to registry
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD
    - docker tag myapp:$CI_COMMIT_SHA registry.com/myapp:latest
    - docker push registry.com/myapp:latest
    
    # Deploy
    - kubectl set image deployment/myapp app=registry.com/myapp:latest
  only:
    - main
```

#### Déploiement avec ArgoCD (GitOps)
```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: registry.com/myapp:v1.2.3  # ← ArgoCD surveille ce fichier Git
        ports:
        - containerPort: 8080
```

**Workflow GitOps :**
```
1. Dev modifie k8s/deployment.yaml (change version image)
2. Git commit + push
3. ArgoCD détecte le changement
4. ArgoCD déploie automatiquement la nouvelle version
```

---

## 🎯 Stratégies de Déploiement

### 1. Blue/Green Deployment
```
Production actuelle : Blue (v1.0)
                      ↓
Déployer : Green (v2.0) en parallèle
                      ↓
Tester Green
                      ↓
Switch traffic : Blue → Green
                      ↓
Green devient production
```

### 2. Canary Deployment
```
v1.0 : 90% traffic
v2.0 : 10% traffic (canary)
        ↓
Monitorer les métriques
        ↓
Si OK : augmenter progressivement (20%, 50%, 100%)
Si KO : rollback immédiat
```

### 3. Rolling Update (Kubernetes)
```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # 1 pod de plus pendant la mise à jour
      maxUnavailable: 0  # Zéro downtime
```

---

## 🛠️ Outils CI/CD

| Outil | Type | Hébergement |
|-------|------|-------------|
| **GitHub Actions** | CI/CD | Cloud (gratuit OSS) |
| **GitLab CI** | CI/CD | Self-hosted ou Cloud |
| **Jenkins** | CI/CD | Self-hosted |
| **CircleCI** | CI/CD | Cloud |
| **ArgoCD** | CD (GitOps) | Self-hosted sur K8s |
| **FluxCD** | CD (GitOps) | Self-hosted sur K8s |
| **Spinnaker** | CD | Self-hosted |

---

## 📊 Pipeline Complet (GitHub Actions + K8s)

```yaml
name: Full CI/CD

on:
  push:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run tests
        run: |
          npm ci
          npm test
      
      - name: Build Docker image
        run: docker build -t ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} .
      
      - name: Push to registry
        run: |
          echo "${{ secrets.GITHUB_TOKEN }}" | docker login ${{ env.REGISTRY }} -u $ --password-stdin
          docker push ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
  
  cd-staging:
    needs: ci
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Staging
        run: |
          kubectl set image deployment/myapp app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -n staging
      
      - name: Wait for rollout
        run: kubectl rollout status deployment/myapp -n staging
  
  cd-production:
    needs: cd-staging
    runs-on: ubuntu-latest
    environment: production  # ← Nécessite approbation manuelle
    steps:
      - name: Deploy to Production
        run: |
          kubectl set image deployment/myapp app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -n production
```

---

## 🚨 Best Practices

### ✅ Checklist CI/CD
- [ ] Tests automatisés (unit + integration)
- [ ] Linting et code quality
- [ ] Security scanning (dependencies + code)
- [ ] Environnements séparés (dev/staging/prod)
- [ ] Rollback automatique en cas d'échec
- [ ] Notifications (Slack, email)
- [ ] Métriques et monitoring
- [ ] Documentation du pipeline

### 🔒 Sécurité
```yaml
# Ne JAMAIS commiter de secrets
# Utiliser les secrets du CI/CD

# GitHub Actions
steps:
  - name: Deploy
    env:
      API_KEY: ${{ secrets.API_KEY }}
      DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
    run: ./deploy.sh
```

### 📊 Monitoring
```yaml
# Après déploiement : vérifier les métriques
- name: Check deployment health
  run: |
    # Attendre 30s
    sleep 30
    
    # Vérifier le health endpoint
    curl -f https://myapp.com/health || exit 1
    
    # Vérifier les métriques
    ERROR_RATE=$(curl -s https://prometheus/api/v1/query?query=error_rate | jq '.data.result[0].value[1]')
    if [ "$ERROR_RATE" -gt "0.01" ]; then
      echo "Error rate too high!"
      exit 1
    fi
```

---

## 📚 Exercices

| # | Exercice | Outil | Durée |
|---|----------|-------|-------|
| 01 | Premier Pipeline CI | GitHub Actions | 1h |
| 02 | Tests Automatisés | Jest/PyTest | 1h30 |
| 03 | Docker Build & Push | Docker + Registry | 2h |
| 04 | Déploiement K8s | kubectl | 2h |
| 05 | GitOps avec ArgoCD | ArgoCD | 3h |
| 06 | Blue/Green Deploy | K8s | 2h |
| 07 | Canary Deploy | K8s + Istio | 3h |

---

## ✅ Auto-Évaluation

### Niveau Débutant
- [ ] Je comprends CI vs CD
- [ ] Je crée un pipeline basique
- [ ] J'exécute des tests automatiquement

### Niveau Intermédiaire
- [ ] Je déploie automatiquement
- [ ] J'utilise plusieurs environnements
- [ ] Je comprends les stratégies de déploiement

### Niveau Avancé
- [ ] J'implémente GitOps
- [ ] Je fais du Blue/Green ou Canary
- [ ] J'ai un rollback automatique
- [ ] Je monitore mes déploiements

---

**Voir aussi :** [GitOps (ArgoCD)](../CD/argocd.md)

*"If it hurts, do it more often"* - DevOps Principle
