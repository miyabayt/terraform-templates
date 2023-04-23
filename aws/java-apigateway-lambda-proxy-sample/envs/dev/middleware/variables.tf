# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

# secrets manager
locals {
  secret_name = "${var.prefix}-db-secret"
  secret_string = {
    username : var.db_user
    password : var.db_password
  }
}

# ssm parameter
locals {
  ssm_secret_keys   = ["/${var.prefix}/dev/rds/username", "/${var.prefix}/dev/rds/password"]
  ssm_secret_values = ["${var.db_user}", "${var.db_password}"]
}

# rds
variable rds_instance_class {}
variable rds_port {}
variable db_name {}
variable db_user {}
variable db_password {}
variable rds_security_group_id {}

locals {
  rds_cluster_identifier           = "${var.prefix}-db"
  rds_cluster_instance_identifier  = "${var.prefix}-db-instance"
  rds_security_group_name          = "${var.prefix}-db-sg"
  rds_cluster_parameter_group_name = "${var.prefix}-db-cpg"
  rds_parameter_group_name         = "${var.prefix}-db-pg"
  rds_subnet_group_name            = "${var.prefix}-db-subnet-group"
}

# rdsproxy
variable rds_proxy_security_group_id {}

locals {
  rds_proxy_name        = "${var.prefix}-db-proxy"
  rds_engine_family     = "MYSQL"
  rds_proxy_role_name   = "${var.prefix}-db-proxy-role"
  rds_proxy_policy_name = "${var.prefix}-db-proxy-policy"
}
