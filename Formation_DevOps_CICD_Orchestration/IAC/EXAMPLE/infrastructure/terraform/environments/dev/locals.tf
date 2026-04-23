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
}
