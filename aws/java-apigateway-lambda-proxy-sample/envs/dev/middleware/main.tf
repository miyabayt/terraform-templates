# secrets manager
module secretsmanager {
  source        = "../../../modules/secretsmanager"
  secret_name   = local.secret_name
  secret_string = local.secret_string
}

# ssm parameter
module ssm {
  source      = "../../../modules/ssm"
  ssm_secrets = zipmap(local.ssm_secret_keys, local.ssm_secret_values)
}

module rds {
  source = "../../../modules/rds"

  cluster_identifier           = local.rds_cluster_identifier
  cluster_instance_identifier  = local.rds_cluster_instance_identifier
  rds_instance_class           = var.rds_instance_class
  cluster_parameter_group_name = local.rds_cluster_parameter_group_name
  parameter_group_name         = local.rds_parameter_group_name
  subnet_group_name            = local.rds_subnet_group_name
  rds_security_group_id        = var.rds_security_group_id

  vpc_id        = var.vpc_id
  rds_port      = var.rds_port
  cidr_blocks   = [var.private_subnet_a_cidr_block, var.private_subnet_c_cidr_block]
  db_subnet_ids = [var.private_subnet_a_id, var.private_subnet_c_id]
  db_name       = var.db_name
  db_user       = var.db_user
  db_password   = var.db_password
}

module rdsproxy {
  source = "../../../modules/rdsproxy"

  rds_proxy_name              = local.rds_proxy_name
  rds_engine_family           = local.rds_engine_family
  rds_proxy_target_id         = module.rds.rds_cluster_identifier
  rds_proxy_role_name         = local.rds_proxy_role_name
  rds_proxy_policy_name       = local.rds_proxy_policy_name
  rds_proxy_security_group_id = var.rds_proxy_security_group_id
  secret_arn                  = module.secretsmanager.secret_arn

  vpc_id        = var.vpc_id
  db_subnet_ids = [var.private_subnet_a_id, var.private_subnet_c_id]
}
