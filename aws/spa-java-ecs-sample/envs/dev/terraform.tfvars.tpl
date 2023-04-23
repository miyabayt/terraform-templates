# aws credentials
aws_region = "ap-northeast-1"

# common
prefix = "xxxx"

# certificate
route53_zone_name           = "example.com"
acm_certificate_domain_name = "example.com"
alb_domain_name             = "api.example.com" # ALBドメイン名に対してCNAMEレコードを作成します。
front_domain_name          = "front.example.com"
frontui_domain_name         = "www.example.com"

# vpc
vpc_cidr                    = "10.0.0.0/16"
public_subnet_a_cidr_block  = "10.0.10.0/24"
public_subnet_c_cidr_block  = "10.0.11.0/24"
private_subnet_a_cidr_block = "10.0.20.0/24"
private_subnet_c_cidr_block = "10.0.21.0/24"

# alb
alb_http_port  = 80
alb_https_port = 443

# rds
rds_engine                         = "aurora-mysql"
rds_instance_class                 = "db.t2.small"
rds_port                           = 3306
rds_schema                         = "xxxx"
rds_cluster_parameter_group_family = "aurora-mysql5.7"
db_character_set                   = "utf8mb4"
db_collation                       = "utf8mb4_general_ci"
db_timezone                        = "Asia/Tokyo"

# elasticache
elasticache_node_type                  = "cache.t2.micro"
elasticache_port                       = 6379
elasticache_engine_version             = "5.0.6"
elasticache_parameter_group_name       = "default.redis5.0"
elasticache_automatic_failover_enabled = false
elasticache_number_cache_clusters      = 1
elasticache_snapshot_retention_limit   = 0

# sqs
sqs_queues = []

# ssm
db_username    = "root"
db_password    = "passw0rd"
