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

variable "terraform_role_arn" {
  description = "ARN du rôle IAM à assumer par Terraform"
  type        = string
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

variable "database_subnet_cidrs" {
  description = "CIDR blocks pour les subnets database"
  type        = list(string)
  default     = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
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

variable "ssh_key_name" {
  description = "Nom de la clé SSH"
  type        = string
}

variable "app_version" {
  description = "Version de l'application à déployer"
  type        = string
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

variable "db_max_allocated_storage" {
  description = "Stockage maximum alloué pour RDS (GB)"
  type        = number
  default     = 200
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
