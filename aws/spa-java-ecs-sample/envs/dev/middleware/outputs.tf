output rds_cluster_identifier {
  value = module.rds.rds_cluster_endpoint
}

output rds_cluster_endpoint {
  value = module.rds.rds_cluster_endpoint
}

output elasticache_endpoint {
  value = module.elasticache.elasticache_endpoint
}
