# Semaine 1-2 : Terraform Basics

## 🎯 Objectifs d'Apprentissage

À la fin de ces 2 semaines, vous serez capable de :
- ✅ Installer et configurer Terraform
- ✅ Comprendre les concepts de base : providers, resources, variables, outputs
- ✅ Créer des ressources cloud simples
- ✅ Utiliser les commandes essentielles Terraform
- ✅ Gérer le state file

## 📋 Pré-requis

- Un compte AWS (Free Tier) ou Azure
- Un éditeur de code (VS Code recommandé)
- Connaissances basiques en ligne de commande

---

## 📚 Les Exercices Pratiques

Tous les exercices se déroulent dans des dossiers de travail locaux que vous pouvez créer pour l'occasion.

### Exercice 01 - Installation et Configuration
**Durée estimée :** 30 minutes | **Niveau :** Débutant

**1. Installation :**
```bash
# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Linux (Debian/Ubuntu)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**2. Vérification :**
```bash
terraform -version
# Attendue: Terraform v1.x.x
```

### Exercice 02 - Premier Provider
**Durée estimée :** 45 minutes | **Niveau :** Débutant

Créons un projet local qui provisionne une ressource via le provider "local" de Terraform (sans cloud pour l'instant).

```bash
mkdir mon-premier-projet && cd mon-premier-projet

cat > main.tf << 'EOF'
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

resource "local_file" "hello" {
  content  = "Bonjour DevOps!"
  filename = "${path.module}/hello.txt"
}
EOF

# Initialiser le répertoire (télécharge le provider local)
terraform init

# Planifier les modifications
terraform plan

# Appliquer (crée le fichier)
terraform apply -auto-approve
```

### Exercice 03 - Première VM (AWS)
**Durée estimée :** 1 heure | **Niveau :** Débutant

(Nécessite des identifiants AWS configurés via `aws configure` ou variables d'environnement `AWS_ACCESS_KEY_ID` et `AWS_SECRET_ACCESS_KEY`).

```bash
cat > main.tf << 'EOF'
provider "aws" {
  region = "eu-west-3" # Paris
}

resource "aws_instance" "ma_premiere_vm" {
  ami           = "ami-0eb260c4d5475b901" # Ubuntu 22.04 LTS (variable selon l'époque)
  instance_type = "t2.micro"

  tags = {
    Name = "DevOps-VM"
  }
}
EOF

terraform init
terraform plan
terraform apply
```

### Exercice 04 - Variables et Outputs
**Durée estimée :** 1 heure | **Niveau :** Débutant

Rendre le code réutilisable.
```bash
cat > variables.tf << 'EOF'
variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
EOF

cat > outputs.tf << 'EOF'
output "instance_ip_publique" {
  value = aws_instance.ma_premiere_vm.public_ip
}
EOF

# Modifier le main.tf pour utiliser var.instance_type et var.region
terraform apply
```

### Exercice 05 - Projet : Multi-VMs avec count
**Durée estimée :** 2 heures | **Niveau :** Intermédiaire

```bash
resource "aws_instance" "serveurs_web" {
  count         = 3
  ami           = "ami-0eb260c4d5475b901"
  instance_type = var.instance_type

  tags = {
    Name = "Web-Server-${count.index + 1}"
  }
}
```

---

## 🛠️ Commandes Essentielles (Référence)

```bash
terraform init       # Initialiser le projet
terraform fmt        # Formater le code
terraform validate   # Valider la syntaxe
terraform plan       # Planifier
terraform apply      # Appliquer
terraform apply -auto-approve
terraform output     # Voir les valeurs d'output
terraform show       # Afficher le state
terraform destroy    # Tout détruire !
```

## 📝 Nettoyage
N'oubliez PAS de détruire vos ressources cloud à la fin pour éviter la facturation :
```bash
terraform destroy -auto-approve
```
