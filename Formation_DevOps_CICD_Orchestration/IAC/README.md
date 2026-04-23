# 🏗️ IAC — Infrastructure as Code

> **Prérequis :** Notions Linux de base | **Durée totale :** ~6 semaines | **Niveau :** Intermédiaire → Avancé

---

## 🗺️ Structure du Module

```
IAC/
├── README.md                        ← Ce fichier
├── CONCEPTS-PEDAGOGIQUES.md         ← Concepts approfondis (IaC, Terraform, Ansible)
├── PARCOURS-PEDAGOGIQUE.md          ← Plan semaine par semaine
├── STRUCTURES.md                    ← Architectures de projets IaC
├── OUTILS-OPEN-SOURCE.md            ← Comparatif des outils
├── EXAMPLE/                         ← Infrastructure de référence complète
│   └── infrastructure/              ← Structure Terraform + Ansible + K8s
├── semaine-1-2-terraform-basics/    ← Exercices Terraform débutant
├── semaine-3-4-terraform-avance/    ← Exercices Terraform avancé
├── semaine-5-ansible/               ← Exercices Ansible
└── semaine-6-integration/           ← Projet intégrateur
```

---

## 🎯 Par où commencer ?

| Objectif | Aller vers |
|----------|-----------|
| Comprendre ce qu'est l'IaC | [CONCEPTS-PEDAGOGIQUES.md](./CONCEPTS-PEDAGOGIQUES.md) |
| Suivre le cursus complet | [PARCOURS-PEDAGOGIQUE.md](./PARCOURS-PEDAGOGIQUE.md) |
| Commencer Terraform | [Semaine 1-2](./semaine-1-2-terraform-basics/) |
| Voir une vraie architecture | [EXAMPLE/](./EXAMPLE/) |
| Comparer les outils | [OUTILS-OPEN-SOURCE.md](./OUTILS-OPEN-SOURCE.md) |

---

## ⚡ Référence Rapide

### Terraform
```bash
terraform init        # Initialiser le projet (télécharge providers)
terraform plan        # Prévisualiser les changements
terraform apply       # Appliquer (créer/modifier l'infra)
terraform destroy     # Détruire toute l'infra
terraform validate    # Valider la syntaxe HCL
terraform fmt         # Formater les fichiers
terraform output      # Afficher les outputs
terraform state list  # Lister les ressources trackées
```

### Ansible
```bash
ansible all -m ping -i inventory.ini          # Tester la connectivité
ansible-playbook playbook.yml -i inventory    # Lancer un playbook
ansible-playbook playbook.yml --check         # Dry-run (sans modifier)
ansible-playbook playbook.yml --diff          # Voir les changements
ansible-playbook playbook.yml -v              # Verbose
ansible-vault encrypt secrets.yml             # Chiffrer des variables
ansible-galaxy install role_name              # Installer un rôle
```

---

## 📊 Exercices — Tableau de Bord

### Terraform Basics (Semaines 1-2)

| # | Exercice | Durée | Concept |
|---|----------|-------|---------|
| 01 | [Installation](./semaine-1-2-terraform-basics/exercice-01-installation/) | 30 min | Setup Terraform |
| 02 | [Premier Provider](./semaine-1-2-terraform-basics/exercice-02-premier-provider/) | 1h | Provider Docker local |
| 03 | [Première VM](./semaine-1-2-terraform-basics/exercice-03-premiere-vm/) | 2h | Resource, plan, apply |
| 04 | [Variables & Outputs](./semaine-1-2-terraform-basics/exercice-04-variables-outputs/) | 2h | Variables, locals, outputs |
| 05 | [Multi-VMs](./semaine-1-2-terraform-basics/exercice-05-multi-vms/) | 2h | count, for_each |

### Terraform Avancé (Semaines 3-4)

| # | Exercice | Durée | Concept |
|---|----------|-------|---------|
| 06 | [Modules](./semaine-3-4-terraform-avance/exercice-06-modules/) | 3h | Modularisation |
| 07 | [Remote State](./semaine-3-4-terraform-avance/exercice-07-remote-state/) | 2h | Backend S3/GCS |
| 08 | [Workspaces](./semaine-3-4-terraform-avance/exercice-08-workspaces/) | 2h | Env dev/staging/prod |
| 09 | [Data Sources](./semaine-3-4-terraform-avance/exercice-09-data-sources/) | 2h | Données existantes |
| 10 | [Architecture 3-tiers](./semaine-3-4-terraform-avance/exercice-10-architecture-3-tiers/) | 4h | Projet complet |

### Ansible (Semaine 5)

| # | Exercice | Durée | Concept |
|---|----------|-------|---------|
| 11 | [Inventaires](./semaine-5-ansible/exercice-11-inventaires/) | 1h | Static/Dynamic |
| 12 | [Playbooks](./semaine-5-ansible/exercice-12-playbooks/) | 2h | Tasks, handlers, vars |
| 13 | [Rôles](./semaine-5-ansible/exercice-13-roles/) | 3h | Structure de rôles |
| 14 | [Templates Jinja2](./semaine-5-ansible/exercice-14-templates/) | 2h | Configuration dynamique |
| 15 | [Stack LAMP](./semaine-5-ansible/exercice-15-stack-lamp/) | 4h | Projet Apache+MySQL+PHP |

### Intégration (Semaine 6)

| # | Exercice | Durée | Concept |
|---|----------|-------|---------|
| 16 | [Terraform + Ansible](./semaine-6-integration/exercice-16-terraform-ansible/) | 4h | Provision + Configure |
| 17 | [Pipeline CI/CD IaC](./semaine-6-integration/exercice-17-cicd-pipeline/) | 4h | GitLab CI + Terraform |
| 18 | [Tests Infrastructure](./semaine-6-integration/exercice-18-tests-infrastructure/) | 3h | Terratest, Molecule |

---

## ✅ Checklist de Progression

- [ ] **Niveau 1** : Je sais écrire et appliquer un fichier Terraform basique
- [ ] **Niveau 2** : J'utilise variables, outputs et modules
- [ ] **Niveau 3** : Je gère plusieurs environnements avec Workspaces
- [ ] **Niveau 4** : Je combine Terraform + Ansible dans un pipeline CI/CD

---

*"Infrastructure as Code: Treat your infrastructure like software"*