# Semaine 3-4 : Terraform Avancé

## 🎯 Objectifs d'Apprentissage

À la fin de ces 2 semaines, vous serez capable de :
- ✅ Créer et utiliser des modules Terraform réutilisables
- ✅ Gérer le state de manière sécurisée avec un backend distant
- ✅ Utiliser des workspaces pour gérer plusieurs environnements
- ✅ Utiliser des data sources pour récupérer des informations existantes
- ✅ Concevoir une architecture 3-tiers complète

## 📋 Pré-requis

- Avoir complété les semaines 1-2 (Terraform Basics)
- Compte AWS/Azure actif
- Compréhension des concepts de base de Terraform

---

## 📚 Les Exercices Pratiques

Tous les exercices se déroulent dans des dossiers de travail locaux que vous pouvez créer pour l'occasion.

### Exercice 06 - Modules Terraform
**Durée estimée :** 2 heures | **Niveau :** Intermédiaire

L'objectif est de créer un module réutilisable pour déployer une instance EC2 standardisée.

```bash
mkdir -p terraform-modules-exo/modules/aws-web-server
cd terraform-modules-exo

# Créer le module enfant (modules/aws-web-server/main.tf)
cat > modules/aws-web-server/main.tf << 'EOF'
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name        = var.server_name
    Environment = var.environment
  }
}
EOF

cat > modules/aws-web-server/variables.tf << 'EOF'
variable "ami_id" { type = string }
variable "instance_type" { type = string, default = "t2.micro" }
variable "server_name" { type = string }
variable "environment" { type = string }
EOF

cat > modules/aws-web-server/outputs.tf << 'EOF'
output "public_ip" {
  value = aws_instance.web.public_ip
}
EOF

# Appeler le module dans le projet principal (main.tf racine)
cat > main.tf << 'EOF'
provider "aws" { region = "eu-west-3" }

module "web_server_dev" {
  source        = "./modules/aws-web-server"
  ami_id        = "ami-0eb260c4d5475b901"
  server_name   = "Web-Dev"
  environment   = "Development"
}

output "dev_server_ip" {
  value = module.web_server_dev.public_ip
}
EOF

terraform init # Télécharge et initialise le module
terraform plan
```

### Exercice 07 - Remote State (S3 & DynamoDB)
**Durée estimée :** 1h30 | **Niveau :** Intermédiaire

Déplacer le state de local vers un bucket S3. (Note : Le bucket S3 doit déjà exister, vous pouvez le créer via l'interface AWS).

```bash
cat > backend.tf << 'EOF'
terraform {
  backend "s3" {
    bucket         = "mon-bucket-terraform-state-12345" # Remplacez par le nom de votre bucket
    key            = "dev/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    # dynamodb_table = "terraform-locks" # Optionnel: pour le locking
  }
}
EOF

# Migrer le state existant vers le backend distant
terraform init
# Répondez 'yes' pour copier l'état existant vers S3
```

### Exercice 08 - Workspaces
**Durée estimée :** 1h30 | **Niveau :** Intermédiaire

Gérer dev et prod avec le même code mais des variables différentes.

```bash
# Gérer les workspaces
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev

cat > main.tf << 'EOF'
locals {
  # Choisir le type d'instance en fonction du workspace
  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t2.micro"
}

resource "aws_instance" "app" {
  ami           = "ami-0eb260c4d5475b901"
  instance_type = local.instance_type
  
  tags = {
    Name = "AppServer-${terraform.workspace}"
  }
}
EOF

terraform plan # En dev, ce sera t2.micro
terraform workspace select prod
terraform plan # En prod, ce sera t3.medium
```

### Exercice 09 - Data Sources
**Durée estimée :** 1 heure | **Niveau :** Intermédiaire

Trouver dynamiquement l'ID de la dernière image Ubuntu.

```bash
cat > main.tf << 'EOF'
provider "aws" { region = "eu-west-3" }

data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # ID Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t2.micro"
}

output "found_ami_id" {
  value = data.aws_ami.ubuntu_latest.id
}
EOF

terraform apply -auto-approve
```

### Exercice 10 - Projet : Architecture 3-Tiers
**Durée estimée :** 4 heures | **Niveau :** Avancé

Cet exercice consolide toutes vos connaissances. Créez un projet qui déploie :
1. Un VPC avec 2 sous-réseaux publics, 2 privés.
2. Un Application Load Balancer public.
3. Un Auto-Scaling Group d'instances Web dans les sous-réseaux privés.
4. Une base de données RDS.

*(Consultez le dossier `EXAMPLE/infrastructure` pour vous inspirer des modules).*

---

## 🏗️ Architecture 3-Tiers Conceptuelle

```
┌─────────────────────────────────────────┐
│              Internet                    │
└───────────────┬─────────────────────────┘
                │
        ┌───────▼────────┐
        │ Load Balancer  │
        └───────┬────────┘
                │
    ┌───────────┴───────────┐
    │                       │
┌───▼────┐             ┌───▼────┐
│  Web   │             │  Web   │  ← Tier 1: Présentation
│ Server │             │ Server │
└───┬────┘             └───┬────┘
    │                      │
    └──────────┬───────────┘
               │
    ┌──────────▼──────────┐
    │                     │
┌───▼────┐           ┌───▼────┐
│  App   │           │  App   │  ← Tier 2: Application
│ Server │           │ Server │
└───┬────┘           └───┬────┘
    │                    │
    └────────┬───────────┘
             │
      ┌──────▼──────┐
      │  Database   │           ← Tier 3: Données
      │   (RDS)     │
      └─────────────┘
```

---

## 🛠️ Nouvelles Commandes Importantes

```bash
terraform get                         # Télécharger/Mettre à jour les modules
terraform workspace new <name>        # Créer un workspace
terraform workspace select <name>     # Sélectionner un workspace
terraform workspace list              # Lister les workspaces
terraform state list                  # Voir toutes les ressources trackées
terraform state show <res_name>       # Examiner les attributs d'une ressource en cache
terraform state rm <res_name>         # Détacher une ressource (oublier, sans détruire)
terraform import <ressource> <id_aws> # Adopter une ressource créée à la main dans le state
```

---

## 📝 Checklist de Progression Finale

- [ ] Je sais écrire, appeler et versionner un module enfant.
- [ ] Mon `terraform.tfstate` n'est plus local mais sécurisé sur un bucket S3.
- [ ] Les locks DynamoDB sont activés pour éviter les conflits d'écritures en équipe.
- [ ] J'utilise `terraform workspace` ou la structure de dossiers pour séparer Dev, Staging et Prod.
- [ ] J'utilise `data "aws_ami"` et `data "aws_vpc"` au lieu de hardcoder les IDs.

---

## ⏭️ Prochaine Étape
Passez au module Configuration Management : [Semaine 5 : Ansible](../semaine-5-ansible)
