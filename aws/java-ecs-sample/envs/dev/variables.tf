# aws credentials
variable aws_region {}

# common
variable prefix {}

# certificate
variable route53_zone_name {}
variable acm_certificate_domain_name {}
variable alb_domain_name {}

# vpc
variable vpc_cidr {}
variable public_subnet_a_cidr_block {}
variable public_subnet_c_cidr_block {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

# alb
variable alb_http_port {}
variable alb_https_port {}

# rds
variable rds_instance_class {}
variable rds_port {}
variable db_name {}
variable db_user {}
variable db_password {}

# elasticache
variable elasticache_node_type {}
variable elasticache_engine_version {}
variable elasticache_port {}
variable elasticache_parameter_group_name {}
variable elasticache_number_cache_clusters {}
variable elasticache_snapshot_retention_limit {}
variable elasticache_automatic_failover_enabled {}
