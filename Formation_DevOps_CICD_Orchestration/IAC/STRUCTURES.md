# Structure Détaillée d'une Infrastructure as Code (IaC)

## 🏗️ Vue d'Ensemble

L'Infrastructure as Code (IaC) consiste à gérer et provisionner l'infrastructure via du code plutôt que des processus manuels. Voici une structure professionnelle complète.

---

## 📁 Structure de Répertoires Complète

```
infrastructure/
├── README.md                           # Documentation principale
├── .gitignore                          # Fichiers à ne pas versionner
├── .pre-commit-config.yaml            # Hooks Git pour validation
├── Makefile                            # Commandes simplifiées
│
├── terraform/                          # Code Infrastructure
│   ├── global/                        # Ressources globales
│   │   ├── iam/                       # Rôles et politiques IAM
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md
│   │   ├── network/                   # VPC, Subnets, Routes
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── vpc.tf
│   │   └── dns/                       # Route53, CloudDNS
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── modules/                       # Modules réutilisables
│   │   ├── vpc/                       # Module VPC personnalisé
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── versions.tf
│   │   │   ├── locals.tf
│   │   │   └── README.md
│   │   ├── compute/                   # EC2, VMs
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── user_data.sh
│   │   │   └── README.md
│   │   ├── database/                  # RDS, Aurora
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md
│   │   ├── kubernetes/                # EKS, AKS, GKE
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── node_groups.tf
│   │   │   └── README.md
│   │   ├── monitoring/                # CloudWatch, Prometheus
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── dashboards.tf
│   │   └── security/                  # Security Groups, NACLs
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── environments/                  # Environnements séparés
│   │   ├── dev/
│   │   │   ├── backend.tf            # Backend S3 pour état
│   │   │   ├── providers.tf          # Providers AWS/Azure/GCP
│   │   │   ├── main.tf               # Composition modules
│   │   │   ├── variables.tf          # Variables globales
│   │   │   ├── terraform.tfvars      # Valeurs dev
│   │   │   ├── outputs.tf            # Outputs environnement
│   │   │   └── locals.tf             # Variables locales
│   │   ├── staging/
│   │   │   ├── backend.tf
│   │   │   ├── providers.tf
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   ├── outputs.tf
│   │   │   └── locals.tf
│   │   └── production/
│   │       ├── backend.tf
│   │       ├── providers.tf
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── terraform.tfvars
│   │       ├── terraform.tfvars.backup  # Backup config
│   │       ├── outputs.tf
│   │       └── locals.tf
│   │
│   ├── shared/                        # Ressources partagées
│   │   ├── terraform.tfvars           # Variables communes
│   │   ├── common_tags.tf             # Tags standards
│   │   └── naming_conventions.tf      # Conventions de nommage
│   │
│   └── scripts/                       # Scripts utilitaires
│       ├── init.sh                    # Initialisation Terraform
│       ├── plan.sh                    # Terraform plan automatisé
│       ├── apply.sh                   # Terraform apply sécurisé
│       ├── destroy.sh                 # Destruction avec confirmation
│       ├── format.sh                  # Formatage code
│       └── validate.sh                # Validation syntaxe
│
├── ansible/                           # Configuration Management
│   ├── ansible.cfg                    # Config Ansible
│   ├── inventory/                     # Inventaires
│   │   ├── production.ini
│   │   ├── staging.ini
│   │   ├── dev.ini
│   │   └── dynamic/                   # Inventaires dynamiques
│   │       ├── aws_ec2.yml
│   │       └── azure_rm.yml
│   │
│   ├── group_vars/                    # Variables par groupe
│   │   ├── all.yml                    # Variables globales
│   │   ├── production.yml
│   │   ├── staging.yml
│   │   ├── webservers.yml
│   │   ├── databases.yml
│   │   └── loadbalancers.yml
│   │
│   ├── host_vars/                     # Variables par host
│   │   ├── web01.yml
│   │   └── db01.yml
│   │
│   ├── roles/                         # Rôles Ansible
│   │   ├── common/                    # Configuration commune
│   │   │   ├── tasks/
│   │   │   │   ├── main.yml
│   │   │   │   ├── users.yml
│   │   │   │   ├── packages.yml
│   │   │   │   └── security.yml
│   │   │   ├── handlers/
│   │   │   │   └── main.yml
│   │   │   ├── templates/
│   │   │   │   ├── ssh_config.j2
│   │   │   │   └── motd.j2
│   │   │   ├── files/
│   │   │   │   └── banner.txt
│   │   │   ├── vars/
│   │   │   │   └── main.yml
│   │   │   ├── defaults/
│   │   │   │   └── main.yml
│   │   │   ├── meta/
│   │   │   │   └── main.yml
│   │   │   └── README.md
│   │   ├── nginx/                     # Serveur web
│   │   ├── postgresql/                # Base de données
│   │   ├── docker/                    # Containerisation
│   │   ├── kubernetes/                # K8s client
│   │   ├── monitoring/                # Prometheus, Grafana
│   │   ├── backup/                    # Stratégies backup
│   │   └── security/                  # Hardening
│   │
│   ├── playbooks/                     # Playbooks principaux
│   │   ├── site.yml                   # Playbook master
│   │   ├── webservers.yml             # Config webservers
│   │   ├── databases.yml              # Config databases
│   │   ├── deploy.yml                 # Déploiement app
│   │   ├── rollback.yml               # Rollback
│   │   ├── backup.yml                 # Backup manuel
│   │   ├── security_audit.yml         # Audit sécurité
│   │   └── maintenance.yml            # Maintenance
│   │
│   └── collections/                   # Collections Ansible
│       └── requirements.yml
│
├── kubernetes/                        # Manifests Kubernetes
│   ├── base/                          # Configurations de base
│   │   ├── namespace.yaml
│   │   ├── configmap.yaml
│   │   ├── secret.yaml
│   │   └── kustomization.yaml
│   │
│   ├── apps/                          # Applications
│   │   ├── frontend/
│   │   │   ├── deployment.yaml
│   │   │   ├── service.yaml
│   │   │   ├── ingress.yaml
│   │   │   ├── hpa.yaml              # Horizontal Pod Autoscaler
│   │   │   └── kustomization.yaml
│   │   ├── backend/
│   │   │   ├── deployment.yaml
│   │   │   ├── service.yaml
│   │   │   ├── configmap.yaml
│   │   │   └── kustomization.yaml
│   │   └── database/
│   │       ├── statefulset.yaml
│   │       ├── service.yaml
│   │       ├── pvc.yaml               # Persistent Volume Claim
│   │       └── kustomization.yaml
│   │
│   ├── overlays/                      # Overlays par environnement
│   │   ├── dev/
│   │   │   ├── kustomization.yaml
│   │   │   └── patches/
│   │   ├── staging/
│   │   │   ├── kustomization.yaml
│   │   │   └── patches/
│   │   └── production/
│   │       ├── kustomization.yaml
│   │       ├── patches/
│   │       └── sealed-secrets/        # Secrets chiffrés
│   │
│   ├── charts/                        # Helm Charts
│   │   ├── myapp/
│   │   │   ├── Chart.yaml
│   │   │   ├── values.yaml
│   │   │   ├── values-dev.yaml
│   │   │   ├── values-staging.yaml
│   │   │   ├── values-production.yaml
│   │   │   └── templates/
│   │   │       ├── deployment.yaml
│   │   │       ├── service.yaml
│   │   │       ├── ingress.yaml
│   │   │       ├── _helpers.tpl
│   │   │       └── NOTES.txt
│   │   └── monitoring/
│   │
│   └── operators/                     # Kubernetes Operators
│       ├── prometheus-operator.yaml
│       └── cert-manager.yaml
│
├── docker/                            # Dockerfiles
│   ├── frontend/
│   │   ├── Dockerfile
│   │   ├── .dockerignore
│   │   └── nginx.conf
│   ├── backend/
│   │   ├── Dockerfile
│   │   ├── .dockerignore
│   │   └── entrypoint.sh
│   └── docker-compose.yml             # Environnement local
│
├── ci-cd/                             # Pipelines CI/CD
│   ├── gitlab-ci/
│   │   ├── .gitlab-ci.yml
│   │   ├── templates/
│   │   │   ├── terraform.yml
│   │   │   ├── ansible.yml
│   │   │   ├── docker.yml
│   │   │   └── kubernetes.yml
│   │   └── scripts/
│   ├── github-actions/
│   │   └── workflows/
│   │       ├── terraform.yml
│   │       ├── deploy.yml
│   │       └── security-scan.yml
│   ├── jenkins/
│   │   ├── Jenkinsfile
│   │   └── pipelines/
│   └── azure-devops/
│       └── azure-pipelines.yml
│
├── docs/                              # Documentation
│   ├── architecture/
│   │   ├── diagrams/
│   │   │   ├── network-diagram.png
│   │   │   ├── architecture.png
│   │   │   └── data-flow.png
│   │   ├── decisions/                 # ADRs
│   │   │   ├── 001-choice-of-cloud.md
│   │   │   ├── 002-kubernetes-vs-ecs.md
│   │   │   └── 003-database-selection.md
│   │   └── README.md
│   ├── runbooks/                      # Guides opérationnels
│   │   ├── deployment.md
│   │   ├── rollback.md
│   │   ├── disaster-recovery.md
│   │   ├── scaling.md
│   │   └── troubleshooting.md
│   ├── onboarding/                    # Nouveau dev
│   │   ├── getting-started.md
│   │   ├── local-setup.md
│   │   └── faq.md
│   └── api/                           # Documentation API
│       └── openapi.yaml
│
├── monitoring/                        # Configurations monitoring
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   ├── alerts/
│   │   │   ├── infrastructure.yml
│   │   │   ├── application.yml
│   │   │   └── business.yml
│   │   └── rules/
│   ├── grafana/
│   │   ├── dashboards/
│   │   │   ├── infrastructure.json
│   │   │   ├── application.json
│   │   │   └── business-metrics.json
│   │   └── datasources/
│   ├── alertmanager/
│   │   └── config.yml
│   └── logging/
│       ├── fluentd.conf
│       └── elasticsearch.yml
│
├── security/                          # Sécurité
│   ├── policies/                      # Politiques de sécurité
│   │   ├── opa/                       # Open Policy Agent
│   │   │   ├── kubernetes.rego
│   │   │   └── terraform.rego
│   │   └── sentinel/                  # HashiCorp Sentinel
│   ├── secrets/                       # Gestion secrets
│   │   ├── vault/
│   │   │   ├── policies/
│   │   │   └── config.hcl
│   │   └── sealed-secrets/
│   ├── compliance/                    # Conformité
│   │   ├── cis-benchmarks/
│   │   ├── pci-dss/
│   │   └── gdpr/
│   └── scanning/                      # Security scanning
│       ├── trivy.yaml
│       └── snyk.yaml
│
├── backup/                            # Stratégies backup
│   ├── policies/
│   │   ├── database-backup.yaml
│   │   ├── volume-backup.yaml
│   │   └── etcd-backup.yaml
│   └── scripts/
│       ├── backup.sh
│       └── restore.sh
│
├── disaster-recovery/                 # Plan DR
│   ├── runbooks/
│   │   ├── rto-rpo.md
│   │   ├── failover.md
│   │   └── restore.md
│   └── terraform/
│       └── dr-region/
│
├── tests/                             # Tests infrastructure
│   ├── terraform/
│   │   ├── unit/
│   │   │   └── vpc_test.go
│   │   └── integration/
│   │       └── full_stack_test.go
│   ├── ansible/
│   │   └── molecule/
│   │       ├── default/
│   │       │   ├── molecule.yml
│   │       │   ├── converge.yml
│   │       │   └── verify.yml
│   │       └── README.md
│   └── kubernetes/
│       └── e2e/
│
├── cost-optimization/                 # Optimisation coûts
│   ├── reports/
│   │   └── monthly-cost-analysis.md
│   ├── policies/
│   │   └── cost-policies.rego
│   └── scripts/
│       └── unused-resources.sh
│
└── tools/                             # Outils et scripts
    ├── cli/                           # CLI personnalisée
    ├── utilities/
    │   ├── ip-calculator.py
    │   ├── resource-tagger.sh
    │   └── cost-estimator.py
    └── templates/
        └── new-service.sh
```

---

## 📋 Détail des Fichiers Clés

### 1️⃣ **Terraform - Structure Modulaire**

#### **backend.tf** (État distant)
```hcl
terraform {
  required_version = ">= 1.5.0"
  
  # Backend S3 pour état partagé
  backend "s3" {
    bucket         = "company-terraform-state-prod"
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    
    # Tags pour le bucket d'état
    tags = {
      Name        = "Terraform State"
      Environment = "production"
      ManagedBy   = "Terraform"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}
```

#### **providers.tf** (Configuration providers)
```hcl
provider "aws" {
  region = var.aws_region
  
  # Tags par défaut sur toutes les ressources
  default_tags {
    tags = local.common_tags
  }
  
  # Assume role pour sécurité
  assume_role {
    role_arn     = var.terraform_role_arn
    session_name = "terraform-${var.environment}"
  }
}

provider "aws" {
  alias  = "dr_region"
  region = var.dr_region
  
  default_tags {
    tags = merge(
      local.common_tags,
      { Region = "DR" }
    )
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
```

#### **main.tf** (Composition de modules)
```hcl
# ===== RÉSEAU =====
module "vpc" {
  source = "../../modules/vpc"
  
  name               = "${var.project_name}-${var.environment}"
  cidr_block         = var.vpc_cidr
  availability_zones = var.availability_zones
  
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  database_subnets = var.database_subnet_cidrs
  
  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "production"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = local.resource_tags
}

# ===== COMPUTE =====
module "application_servers" {
  source = "../../modules/compute"
  
  name          = "${var.project_name}-app"
  instance_type = var.app_instance_type
  instance_count = var.app_instance_count
  
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security.app_sg_id]
  key_name           = var.ssh_key_name
  
  user_data = templatefile("${path.module}/user_data.sh", {
    environment = var.environment
    app_version = var.app_version
  })
  
  tags = merge(
    local.resource_tags,
    { Role = "Application" }
  )
}

# ===== BASE DE DONNÉES =====
module "database" {
  source = "../../modules/database"
  
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = var.db_instance_class
  
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password # Depuis AWS Secrets Manager
  
  subnet_ids         = module.vpc.database_subnet_ids
  security_group_ids = [module.security.db_sg_id]
  
  # Haute disponibilité
  multi_az               = var.environment == "production"
  backup_retention_period = var.environment == "production" ? 30 : 7
  
  # Chiffrement
  storage_encrypted = true
  kms_key_id       = module.kms.key_id
  
  tags = merge(
    local.resource_tags,
    { Role = "Database" }
  )
}

# ===== KUBERNETES =====
module "eks" {
  source = "../../modules/kubernetes"
  
  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      desired_capacity = var.eks_desired_nodes
      max_capacity     = var.eks_max_nodes
      min_capacity     = var.eks_min_nodes
      
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      
      labels = {
        role = "general"
      }
    }
    
    spot = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 0
      
      instance_types = ["t3.large", "t3a.large"]
      capacity_type  = "SPOT"
      
      labels = {
        role = "spot"
      }
      
      taints = [{
        key    = "spot"
        value  = "true"
        effect = "NoSchedule"
      }]
    }
  }
  
  tags = local.resource_tags
}

# ===== MONITORING =====
module "monitoring" {
  source = "../../modules/monitoring"
  
  cluster_name = module.eks.cluster_name
  
  enable_prometheus = true
  enable_grafana    = true
  enable_alertmanager = true
  
  alert_email = var.alert_email
  slack_webhook = var.slack_webhook_url
  
  tags = local.resource_tags
}
```

#### **variables.tf** (Déclarations variables)
```hcl
# ===== VARIABLES GLOBALES =====

variable "project_name" {
  description = "Nom du projet"
  type        = string
  
  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 20
    error_message = "Le nom du projet doit contenir entre 1 et 20 caractères."
  }
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "L'environnement doit être: dev, staging ou production."
  }
}

variable "aws_region" {
  description = "Région AWS principale"
  type        = string
  default     = "eu-west-1"
}

variable "dr_region" {
  description = "Région AWS de disaster recovery"
  type        = string
  default     = "us-west-2"
}

# ===== RÉSEAU =====

variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Le CIDR du VPC doit être valide."
  }
}

variable "availability_zones" {
  description = "Liste des zones de disponibilité"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks pour les subnets privés"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks pour les subnets publics"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# ===== COMPUTE =====

variable "app_instance_type" {
  description = "Type d'instance EC2 pour l'application"
  type        = string
  default     = "t3.medium"
}

variable "app_instance_count" {
  description = "Nombre d'instances application"
  type        = number
  default     = 3
  
  validation {
    condition     = var.app_instance_count >= 1 && var.app_instance_count <= 100
    error_message = "Le nombre d'instances doit être entre 1 et 100."
  }
}

# ===== KUBERNETES =====

variable "eks_desired_nodes" {
  description = "Nombre désiré de nodes EKS"
  type        = number
  default     = 3
}

variable "eks_min_nodes" {
  description = "Nombre minimum de nodes EKS"
  type        = number
  default     = 1
}

variable "eks_max_nodes" {
  description = "Nombre maximum de nodes EKS"
  type        = number
  default     = 10
}

# ===== BASE DE DONNÉES =====

variable "db_instance_class" {
  description = "Classe d'instance RDS"
  type        = string
  default     = "db.t3.large"
}

variable "db_allocated_storage" {
  description = "Stockage alloué pour RDS (GB)"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
  sensitive   = false
}

variable "db_username" {
  description = "Nom d'utilisateur DB"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Mot de passe DB"
  type        = string
  sensitive   = true
}

# ===== MONITORING =====

variable "alert_email" {
  description = "Email pour les alertes"
  type        = string
}

variable "slack_webhook_url" {
  description = "URL webhook Slack pour alertes"
  type        = string
  sensitive   = true
}

# ===== TAGS =====

variable "common_tags" {
  description = "Tags communs à toutes les ressources"
  type        = map(string)
  default     = {}
}
```

#### **locals.tf** (Variables calculées)
```hcl
locals {
  # Nom standardisé
  name_prefix = "${var.project_name}-${var.environment}"
  
  # Région courte
  region_short = {
    "eu-west-1"      = "ew1"
    "us-east-1"      = "ue1"
    "ap-southeast-1" = "as1"
  }
  
  # Tags enrichis automatiquement
  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "github.com/company/infrastructure"
      Timestamp   = timestamp()
      Region      = var.aws_region
    }
  )
  
  resource_tags = merge(
    local.common_tags,
    {
      Terraform   = "true"
      Workspace   = terraform.workspace
    }
  )
  
  # Calcul automatique des subnets
  subnet_count = length(var.availability_zones)
  
  private_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_cidr, 8, i + 1)
  ]
  
  public_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_cidr, 8, i + 101)
  ]
  
  database_subnets = [
    for i in range(local.subnet_count) :
    cidrsubnet(var.vpc_cidr, 8, i + 201)
  ]
  
  # Noms de ressources
  vpc_name         = "${local.name_prefix}-vpc"
  eks_cluster_name = "${local.name_prefix}-eks"
  rds_identifier   = "${local.name_prefix}-db"
  
  # Conditions basées sur l'environnement
  is_production = var.environment == "production"
  enable_ha     = local.is_production
  enable_dr     = local.is_production
  
  # Configuration conditionnelle
  instance_count = local.is_production ? 6 : 2
  enable_monitoring = local.is_production ? true : false
  backup_retention = local.is_production ? 30 : 7
}
```

#### **outputs.tf** (Sorties)
```hcl
# ===