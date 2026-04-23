variable "identifier" { type = string }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "max_allocated_storage" { type = number }
variable "db_name" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "multi_az" { type = bool }
variable "backup_retention_period" { type = number }
variable "storage_encrypted" { type = bool }
variable "kms_key_id" { type = string }
variable "tags" { type = map(string) }

resource "aws_db_subnet_group" "default" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "default" {
  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.security_group_ids

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  skip_final_snapshot     = true # For example purposes

  tags = var.tags
}
