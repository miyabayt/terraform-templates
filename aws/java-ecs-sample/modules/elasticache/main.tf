resource aws_security_group elasticache_security_group {
  name   = var.security_group_name
  vpc_id = var.vpc_id
  tags   = merge(local.default_tags, map("Name", var.security_group_name))
}

resource aws_security_group_rule elasticache_security_group_rule_ingress {
  security_group_id = aws_security_group.elasticache_security_group.id
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
}

resource aws_security_group_rule elasticache_security_group_rule_egress {
  security_group_id = aws_security_group.elasticache_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_elasticache_subnet_group elasticache_subnet_group {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

resource aws_elasticache_replication_group elasticache_replication_group {
  replication_group_id          = var.replication_group_id
  replication_group_description = "Managed by Terraform"
  node_type                     = var.node_type
  port                          = var.port
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name

  security_group_ids = [aws_security_group.elasticache_security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnet_group.name

  number_cache_clusters      = var.number_cache_clusters
  snapshot_retention_limit   = var.snapshot_retention_limit
  automatic_failover_enabled = var.automatic_failover_enabled
}
