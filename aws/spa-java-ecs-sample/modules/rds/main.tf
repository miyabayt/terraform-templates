resource aws_security_group rds_security_group {
  name   = var.rds_security_group_name
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_security_group_rule rds_security_group_rule_ingress {
  security_group_id = aws_security_group.rds_security_group.id
  type              = "ingress"
  from_port         = var.rds_port
  to_port           = var.rds_port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
}

resource aws_security_group_rule rds_security_group_rule_egress {
  security_group_id = aws_security_group.rds_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_db_subnet_group db_subnet_group {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_ids
  tags       = merge(local.default_tags, map("Name", var.db_subnet_group_name))
}

resource aws_db_parameter_group db_parameter_group {
  name   = var.rds_parameter_group_name
  family = "aurora-mysql5.7"
  tags   = merge(local.default_tags, map("Name", var.rds_parameter_group_name))
}

resource aws_rds_cluster_parameter_group rds_cluster_parameter_group {
  name   = var.rds_cluster_parameter_group_name
  family = var.rds_cluster_parameter_group_family
  tags   = merge(local.default_tags, map("Name", var.rds_cluster_parameter_group_name))

  parameter {
    name         = "character_set_client"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = var.db_character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = var.db_collation
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = var.db_collation
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = var.db_timezone
    apply_method = "immediate"
  }
}

resource aws_rds_cluster db_cluster {
  cluster_identifier           = var.rds_cluster_identifier
  database_name                = var.rds_schema
  engine                       = var.rds_engine
  master_username              = var.db_username
  master_password              = var.db_password
  preferred_backup_window      = "19:30-20:00"
  preferred_maintenance_window = "sat:20:15-sat:20:45"
  port                         = 3306

  vpc_security_group_ids          = [aws_security_group.rds_security_group.id]
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name

  backup_retention_period   = 7
  skip_final_snapshot       = false
  deletion_protection       = true
  final_snapshot_identifier = "${var.rds_cluster_identifier}-final-snapshot"

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }

  tags = merge(local.default_tags, map("Name", var.rds_cluster_identifier))
}

resource aws_rds_cluster_instance rds_cluster_instance {
  identifier              = var.rds_cluster_instance_identifier
  cluster_identifier      = aws_rds_cluster.db_cluster.id
  instance_class          = var.rds_instance_class
  engine                  = var.rds_engine
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  db_parameter_group_name = aws_db_parameter_group.db_parameter_group.name

  tags = merge(local.default_tags, map("Name", var.rds_cluster_instance_identifier))
}
