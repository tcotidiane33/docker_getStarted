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
