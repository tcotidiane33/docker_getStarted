# Exemple Complet d'Infrastructure as Code (IaC)

Ce répertoire contient un exemple complet de structure de projet IaC, basé sur les bonnes pratiques définies dans `../STRUCTURES.md`.

## Structure

La structure suit une organisation modulaire et professionnelle :

- **infrastructure/** : Racine du projet
  - **terraform/** : Code Terraform pour le provisionnement de l'infrastructure
    - **global/** : Ressources globales (IAM, DNS, etc.)
    - **modules/** : Modules réutilisables (VPC, Compute, K8s, etc.)
    - **environments/** : Configurations spécifiques par environnement (dev, staging, production)
    - **shared/** : Ressources et variables partagées
  - **ansible/** : Gestion de configuration
  - **kubernetes/** : Manifests Kubernetes et Helm charts
  - **docker/** : Dockerfiles
  - **ci-cd/** : Pipelines CI/CD
  - **docs/** : Documentation architecture et runbooks
  - **monitoring/** : Config Prometheus/Grafana
  - **security/** : Politiques de sécurité
  - **tests/** : Tests d'infrastructure

## Fichiers Clés Peuplés

Pour cet exemple, les fichiers de configuration Terraform pour l'environnement de développement (`infrastructure/terraform/environments/dev/`) ont été entièrement peuplés avec le code fourni dans le guide :

- `backend.tf`
- `providers.tf`
- `main.tf`
- `variables.tf`
- `locals.tf`

Les autres fichiers sont présents en tant que placeholders pour illustrer la structure complète.

## Utilisation

Vous pouvez utiliser cette structure comme point de départ pour vos propres projets. Copiez simplement le contenu de ce répertoire et adaptez-le à vos besoins.
