# aws credentials
aws_region     = "ap-northeast-1"

# common
prefix         = "xxxx"

# certificate
route53_zone_name           = "example.com"
acm_certificate_domain_name = "example.com"
alb_domain_name             = "api.example.com" # ALBドメイン名に対してCNAMEレコードを作成します。

# vpc
vpc_cidr                    = "10.0.0.0/16"
public_subnet_a_cidr_block  = "10.0.10.0/24"
public_subnet_c_cidr_block  = "10.0.11.0/24"
private_subnet_a_cidr_block = "10.0.20.0/24"
private_subnet_c_cidr_block = "10.0.21.0/24"

# alb
alb_http_port = 80
alb_https_port = 443

# rds
rds_instance_class = "db.t2.small"
rds_port           = 3306
db_name            = "xxxx"
db_user            = "root"
db_password        = "passw0rd"

# ecs
application_autoscaling_min_capacity = 1
application_autoscaling_max_capacity = 1

# cloudwatch
cloudwatch_log_group_name         = "xxxx-app-log-group"
cloudwatch_log_stream_prefix      = "ecs"
cloudwatch_logs_retention_in_days = 7

# elasticache
elasticache_node_type                  = "cache.t2.micro"
elasticache_port                       = 6379
elasticache_engine_version             = "5.0.6"
elasticache_parameter_group_name       = "default.redis5.0"
elasticache_automatic_failover_enabled = false
elasticache_number_cache_clusters      = 1
elasticache_snapshot_retention_limit   = 0
