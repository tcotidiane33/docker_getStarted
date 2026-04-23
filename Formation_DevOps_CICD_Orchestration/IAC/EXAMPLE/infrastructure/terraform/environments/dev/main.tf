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
