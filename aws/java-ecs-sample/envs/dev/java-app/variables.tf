# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}

# alb
variable alb_domain_name {}
variable alb_security_group_id {}
variable alb_listener_arn {}

locals {
  http_port                  = 8080
  target_group_name          = "${var.prefix}-tg"
  listener_rule_path_pattern = "/*"
  health_check_path          = "/admin/login"
}

# ssm
variable db_user {}
variable db_password {}
locals {
  ssm_parameters = {
    "/${var.prefix}/DB_USER" : var.db_user,
    "/${var.prefix}/DB_PASS" : var.db_password
  }
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
variable db_name {}

locals {
  db_user     = "/${var.prefix}/DB_USER"
  db_password = "/${var.prefix}/DB_PASS"
}

# elasticache
variable elasticache_endpoint {}

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
  application_autoscaling_scaleout_policy_name = "${var.prefix}-scaleout-policy"
  application_autoscaling_scalein_policy_name  = "${var.prefix}-scalein-policy"
  ecs_service_security_group_name              = "${var.prefix}-sg"
}

# waf
locals {
  # conditions
  waf_ipset_allowed_name = "${var.prefix}-waf-ipset-allowed"
  waf_ipset_descriptors = [
    {
      value = "118.238.251.170/32", # TODO
      type  = "IPV4"
    }
  ]
  waf_size_constraint_set_name     = "${var.prefix}-waf-constraintset-size"
  waf_sql_injection_match_set_name = "${var.prefix}-waf-matchset-sqli"
  waf_xss_match_set_name           = "${var.prefix}-waf-matchset-xss"

  # rules
  waf_rule_size_constraint_name        = "${var.prefix}-waf-rule-size"
  waf_rule_size_constraint_metric_name = "wafrulesizemetric"
  waf_rule_sqli_name                   = "${var.prefix}-waf-rule-sqli"
  waf_rule_sqli_metric_name            = "wafrulesqlimetric"
  waf_rule_xss_name                    = "${var.prefix}-waf-rule-xss"
  waf_rule_xss_metric_name             = "wafrulexssmetric"
  waf_rule_ipset_allowed_name          = "${var.prefix}-waf-rule-ip-allowed"
  waf_rule_ipset_allowed_metric_name   = "wafruleipallowed"

  # acl
  waf_web_acl_name        = "${var.prefix}-waf-acl"
  waf_web_acl_metric_name = "wafaclmetric"
}

# cloudfront
locals {
  alb_origin_access_identity_comment = "${var.prefix}-alb-origin-id"
  cloudfront_distribution_comment    = "${var.prefix}-cloudfront-dist"
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
