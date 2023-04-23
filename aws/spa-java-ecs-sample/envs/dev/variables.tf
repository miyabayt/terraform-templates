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
variable rds_engine {}
variable rds_instance_class {}
variable rds_port {}
variable rds_schema {}
variable rds_cluster_parameter_group_family {}
variable db_character_set {}
variable db_collation {}
variable db_timezone {}

# elasticache
variable elasticache_node_type {}
variable elasticache_engine_version {}
variable elasticache_port {}
variable elasticache_parameter_group_name {}
variable elasticache_number_cache_clusters {}
variable elasticache_snapshot_retention_limit {}
variable elasticache_automatic_failover_enabled {}

# sqs
variable sqs_queues {}

# ssm
variable db_username {}
variable db_password {}

# cloudfront
variable front_domain_name {}
variable frontui_domain_name {}
