output rds_cluster_identifier {
  value = aws_rds_cluster.db_cluster.cluster_identifier
}

output rds_cluster_endpoint {
  value = aws_rds_cluster.db_cluster.endpoint
}
