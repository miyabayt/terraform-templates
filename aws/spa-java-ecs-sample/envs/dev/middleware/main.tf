module rds {
  source = "../../../modules/rds"

  rds_engine                      = var.rds_engine
  rds_cluster_identifier          = local.rds_cluster_identifier
  rds_cluster_instance_identifier = local.rds_cluster_instance_identifier
  rds_instance_class              = var.rds_instance_class

  rds_security_group_name            = local.rds_security_group_name
  rds_cluster_parameter_group_name   = local.rds_cluster_parameter_group_name
  rds_parameter_group_name           = local.rds_parameter_group_name
  rds_cluster_parameter_group_family = var.rds_cluster_parameter_group_family

  db_character_set = var.db_character_set
  db_collation     = var.db_collation
  db_timezone      = var.db_timezone

  vpc_id               = var.vpc_id
  rds_port             = var.rds_port
  rds_schema           = var.rds_schema
  cidr_blocks          = [var.private_subnet_a_cidr_block, var.private_subnet_c_cidr_block]
  db_subnet_group_name = local.rds_subnet_group_name
  db_subnet_ids        = [var.private_subnet_a_id, var.private_subnet_c_id]
  db_username          = "root"
  db_password          = "passw0rd"
}

module elasticache {
  source = "../../../modules/elasticache"

  # vpc
  vpc_id              = var.vpc_id
  cidr_blocks         = [var.private_subnet_a_cidr_block, var.private_subnet_c_cidr_block]
  subnet_ids          = [var.private_subnet_a_id, var.private_subnet_c_id]
  security_group_name = local.elasticache_security_group_name
  subnet_group_name   = local.elasticache_subnet_group_name

  # elasticache
  name                 = local.elasticache_name
  replication_group_id = local.elasticache_replication_group_id
  parameter_group_name = var.elasticache_parameter_group_name
  engine_version       = var.elasticache_engine_version
  port                 = var.elasticache_port
  node_type            = var.elasticache_node_type

  number_cache_clusters      = var.elasticache_number_cache_clusters
  snapshot_retention_limit   = var.elasticache_snapshot_retention_limit
  automatic_failover_enabled = var.elasticache_automatic_failover_enabled
}

module sqs {
  source     = "../../../modules/sqs"
  sqs_queues = var.sqs_queues
}
