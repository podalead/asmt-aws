// common
region = "eu-central-1"
key_name = "test.pub"
dns_name = "testerization.cf"
ami_id = "ami-0c67b2e8311e56fb4"
allowed_ip = [ "77.47.199.232/32", "0.0.0.0/0" ]

// vpc
network_cidr_block = "10.0.0.0/16"
network_cidr_bastion_block = "10.0.240.0/24"
network_cidr_ci_block = "10.0.250.0/24"
network_cidr_database_block = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
network_cidr_private_block = [ "10.0.110.0/24", "10.0.120.0/24", "10.0.130.0/24" ]
network_cidr_public_block = [ "10.0.210.0/24", "10.0.220.0/24", "10.0.230.0/24"]
availability_zones = [ "eu-central-1a", "eu-central-1b", "eu-central-1c" ]

// bastion
bastion_name = "bastion-instance"
bastion_namespace = "bs"
bastion_ssh_user = "magnus"
bastion_stage = "dev"

// ci
ci_name = "ci-instance"
ci_namespace = "ci"
ci_ssh_user = "magnus"
ci_stage = "dev"

// rds
rds_engine = "postgres"
rds_storage_type = "standard"
rds_engine_version = "11.5"
rds_instance_class = "db.t2.micro"
rds_allocated_storage = 20
rds_storage_encrypted = false

rds_backup_retention_period = 0
rds_backup_window = "03:00-06:00"
rds_family = "postgres11"
rds_identifier = "testerization"
rds_name = "relacto"
rds_name_prefix = "alocal-db-group"

rds_parameters = []
rds_username = "macho"
rds_password = "testMatho_1"
rds_port = "5432"

// app host
app_instance_conf = {
  count = 1
  type = "t3a.small"
}

// proxy
proxy_instance_conf = {
  count = 1
  type = "t3a.small"
}

// lb
service_endpoint = "/service"
health_check = "/__healthcheck__"

