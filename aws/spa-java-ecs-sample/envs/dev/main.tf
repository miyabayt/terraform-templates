provider aws {
  region = var.aws_region
}

# 独自ドメインSSL証明書
# ※別途ドメインを取得した上で、ネームサーバーをRoute53に変更しておくこと
# module certificate {
#   source = "./certificate"

#   # route53
#   route53_zone_name = var.route53_zone_name
#   alb_domain_name   = var.alb_domain_name
#   alb_dns_name      = module.network.alb_dns_name

#   # acm
#   acm_certificate_domain_name = var.acm_certificate_domain_name
# }

module network {
  source = "./network"

  # common
  prefix = var.prefix

  # vpc
  vpc_cidr                    = var.vpc_cidr
  public_subnet_a_cidr_block  = var.public_subnet_a_cidr_block
  public_subnet_c_cidr_block  = var.public_subnet_c_cidr_block
  private_subnet_a_cidr_block = var.private_subnet_a_cidr_block
  private_subnet_c_cidr_block = var.private_subnet_c_cidr_block

  # alb
  alb_http_port       = var.alb_http_port
  alb_https_port      = var.alb_https_port
  acm_certificate_arn = module.certificate.acm_certificate_northeast_arn
}

module middleware {
  source = "./middleware"

  # common
  prefix = var.prefix

  # vpc
  vpc_id                      = module.network.vpc_id
  private_subnet_a_id         = module.network.private_subnet_a_id
  private_subnet_c_id         = module.network.private_subnet_c_id
  private_subnet_a_cidr_block = var.private_subnet_a_cidr_block
  private_subnet_c_cidr_block = var.private_subnet_c_cidr_block

  # rds
  rds_engine                         = var.rds_engine
  rds_instance_class                 = var.rds_instance_class
  rds_port                           = var.rds_port
  rds_schema                         = var.rds_schema
  rds_cluster_parameter_group_family = var.rds_cluster_parameter_group_family
  db_character_set                   = var.db_character_set
  db_collation                       = var.db_collation
  db_timezone                        = var.db_timezone

  # elasticache
  elasticache_node_type                  = var.elasticache_node_type
  elasticache_engine_version             = var.elasticache_engine_version
  elasticache_port                       = var.elasticache_port
  elasticache_parameter_group_name       = var.elasticache_parameter_group_name
  elasticache_number_cache_clusters      = var.elasticache_number_cache_clusters
  elasticache_snapshot_retention_limit   = var.elasticache_snapshot_retention_limit
  elasticache_automatic_failover_enabled = var.elasticache_automatic_failover_enabled

  # sqs
  sqs_queues = var.sqs_queues
}

module devtools {
  source = "./devtools"

  # common
  prefix = var.prefix

  # rds
  rds_cluster_identifier = module.middleware.rds_cluster_identifier
}

# Javaアプリケーション
module backend {
  source = "./backend"

  # common
  prefix = "${var.prefix}-backend"

  # vpc
  vpc_id              = module.network.vpc_id
  vpc_cidr_block      = module.network.vpc_cidr_block
  private_subnet_a_id = module.network.private_subnet_a_id
  private_subnet_c_id = module.network.private_subnet_c_id

  # alb
  alb_security_group_id = module.network.alb_security_group_id
  alb_listener_arn      = module.network.alb_listener_arn
  alb_dns_name          = module.network.alb_dns_name

  # rds
  rds_cluster_endpoint = module.middleware.rds_cluster_endpoint
  rds_port             = var.rds_port
  rds_schema           = var.rds_schema

  # elasticache
  elasticache_endpoint = module.middleware.elasticache_endpoint

  # ssm
  db_username = var.db_username
  db_password = var.db_password
}

# SPAアプリケーション
module front {
  source = "./front"

  # common
  prefix = "${var.prefix}-front"

  # vpc
  vpc_id              = module.network.vpc_id
  vpc_cidr_block      = module.network.vpc_cidr_block
  private_subnet_a_id = module.network.private_subnet_a_id
  private_subnet_c_id = module.network.private_subnet_c_id

  # alb
  alb_domain_name = var.alb_domain_name

  # cloudfront
  acm_certificate_arn = module.certificate.acm_certificate_virginia_arn
  route53_zone_id     = module.certificate.route53_zone_id
  alias_domain_name   = var.front_domain_name
}
