# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}
variable vpc_cidr_block {}

# alb
variable alb_security_group_id {}
variable alb_listener_arn {}
variable alb_dns_name {}

locals {
  http_port                   = 8080
  target_group_name           = "${var.prefix}-tg"
  listener_rule_path_patterns = ["/api/*", "/actuator/*", "/swagger*"]
  health_check_path           = "/actuator/health"
}

# ssm
variable db_username {}
variable db_password {}

locals {
  ssm_secret_keys   = ["/dev/${var.prefix}/DB_USER", "/dev/${var.prefix}/DB_PASS"]
  ssm_secret_values = ["${var.db_username}", "${var.db_password}"]
}

# ecr
locals {
  ecr_repository_name = "${var.prefix}-ecr"
}

# cloudwatch
locals {
  cloudwatch_log_group_name         = "${var.prefix}-log-group"
  cloudwatch_log_stream_prefix      = "ecs"
  cloudwatch_logs_retention_in_days = 7
  ecs_service_alarm_high_name       = "${var.prefix}-alerm-high"
  ecs_service_alarm_low_name        = "${var.prefix}-alerm-low"
}

# rds
variable rds_cluster_endpoint {}
variable rds_port {}
variable rds_schema {}

# elasticache
variable elasticache_endpoint {}

# ecs
locals {
  host_port                                    = 8080 # TODO
  container_port                               = 8080 # TODO
  ecs_cluster_name                             = "${var.prefix}-cluster"
  ecs_service_name                             = "${var.prefix}-service"
  ecs_task_definition_family                   = "${var.prefix}-taskdef"
  container_name                               = "${var.prefix}-container"
  ecs_task_cpu                                 = "256"
  ecs_task_memory                              = "512"
  container_desired_count                      = 1
  application_autoscaling_min_capacity         = 1
  application_autoscaling_max_capacity         = 1
  ecs_task_execution_role_name                 = "${var.prefix}-ecs-task-execution-role"
  ecs_task_role_name                           = "${var.prefix}-ecs-task-role"
  application_autoscaling_scaleout_policy_name = "${var.prefix}-scaleout-policy"
  application_autoscaling_scalein_policy_name  = "${var.prefix}-scalein-policy"
  ecs_service_security_group_name              = "${var.prefix}-sg"
}

# codecommit
locals {
  codecommit_src_dir         = var.prefix
  codecommit_iam_group_name  = "${var.prefix}-codecommit-iam-group"
  codecommit_repository_name = "${var.prefix}-codecommit"
}

# s3
locals {
  artifact_s3_bucket_name = "${var.prefix}-codebuild-artifact"
}

# codebuild
locals {
  codebuild_project_name        = "${var.prefix}-codebuild"
  codebuild_role_name           = "${var.prefix}-codebuild-role"
  codebuild_security_group_name = "${var.prefix}-codebuild-sg"
}

# codepipeline
locals {
  codepipeline_name      = "${var.prefix}-codepipeline"
  codepipeline_role_name = "${var.prefix}-codepipeline-role"
  codecommit_branch_name = "master"
}
