# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

# rds
variable rds_instance_class {}
variable rds_port {}
variable db_name {}
variable db_user {}
variable db_password {}

locals {
  rds_cluster_identifier           = "${var.prefix}-db"
  rds_cluster_instance_identifier  = "${var.prefix}-db-instance"
  rds_security_group_name          = "${var.prefix}-db-sg"
  rds_cluster_parameter_group_name = "${var.prefix}-db-cpg"
  rds_parameter_group_name         = "${var.prefix}-db-pg"
  rds_subnet_group_name            = "${var.prefix}-db-subnet-group"
}

# elasticache
variable elasticache_parameter_group_name {}
variable elasticache_engine_version {}
variable elasticache_port {}
variable elasticache_node_type {}
variable elasticache_number_cache_clusters {}
variable elasticache_snapshot_retention_limit {}
variable elasticache_automatic_failover_enabled {}

locals {
  elasticache_name                 = "${var.prefix}-elasticache"
  elasticache_security_group_name  = "${var.prefix}-elasticache-sg"
  elasticache_subnet_group_name    = "${var.prefix}-elasticache-subnet-group"
  elasticache_replication_group_id = "${var.prefix}-elasticache-rg"
}
