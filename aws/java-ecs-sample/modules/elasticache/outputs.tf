output elasticache_endpoint {
  value = aws_elasticache_replication_group.elasticache_replication_group.primary_endpoint_address
}
