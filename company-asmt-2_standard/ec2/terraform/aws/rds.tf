module "rds" {
  source = "modules/rds"

  availability_zone = var.availability_zones
  vpc_security_group_ids = [ aws_security_group.rds.id, aws_security_group.egress.id ]
  vpc_id = module.vpc.vpc_id

  engine = var.rds_engine
  storage_type = var.rds_storage_type
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_encrypted = var.rds_storage_encrypted
  subnet_ids = module.vpc.database_subnets

  backup_retention_period = var.rds_backup_retention_period
  backup_window = var.rds_backup_window
  family = var.rds_family
  identifier = var.rds_identifier
  name = var.rds_name
  name_prefix = var.rds_name_prefix

  parameters = var.rds_parameters
  username = var.rds_username
  password = var.rds_password
  port = var.rds_port

  tags = {
    Name = "gate"
    Environment = "test"
  }
}
