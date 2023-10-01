variable "prefix" {}
variable "region" {}
variable "profile" {}
variable "pipe_root" {}
variable "availability_zones" {}

variable "dns_name" {}
variable "app_instance_conf" {}
variable "proxy_instance_conf" {}
variable "ami_id" {}
variable "service_endpoint" {}
variable "health_check" {}
variable "network_cidr_block" {}
variable "network_cidr_database_block" {}
variable "network_cidr_private_block" {}
variable "network_cidr_public_block" {}
variable "network_cidr_bastion_block" {}
variable "network_cidr_ci_block" {}
variable "key_name" {}

variable "rds_engine" {}
variable "rds_storage_type" {}
variable "rds_engine_version" {}
variable "rds_instance_class" {}
variable "rds_allocated_storage" {}
variable "rds_storage_encrypted" {}

variable "rds_backup_retention_period" {}
variable "rds_backup_window" {}
variable "rds_family" {}
variable "rds_identifier" {}
variable "rds_name" {}
variable "rds_name_prefix" {}
variable "rds_parameters" {}
variable "rds_username" {}
variable "rds_password" {}
variable "rds_port" {}

variable "allowed_ip" {}

variable "bastion_name" {}
variable "bastion_namespace" {}
variable "bastion_ssh_user" {}
variable "bastion_stage" {}

variable "ci_name" {}
variable "ci_namespace" {}
variable "ci_ssh_user" {}
variable "ci_stage" {}



