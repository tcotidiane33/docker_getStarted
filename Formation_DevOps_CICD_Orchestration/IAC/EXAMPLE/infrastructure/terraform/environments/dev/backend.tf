terraform {
  required_version = ">= 1.5.0"
  
  # Backend S3 pour état partagé
  backend "s3" {
    bucket         = "company-terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    
    # Tags pour le bucket d'état
    tags = {
      Name        = "Terraform State"
      Environment = "dev"
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
