# ターゲットグループ
resource aws_lb_target_group target_group {
  name                 = local.target_group_name
  port                 = local.http_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = local.health_check_path
    protocol            = "HTTP"
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = 200
  }
}

# リスナー
resource aws_lb_listener_rule lb_listener_rule {
  listener_arn = var.alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = [local.listener_rule_path_pattern]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# SSMパラメーター
module ssm {
  source         = "../../../modules/ssm"
  ssm_parameters = local.ssm_parameters
}

# ECRリポジトリ
module ecr {
  source              = "../../../modules/ecr"
  ecr_repository_name = local.ecr_repository_name
}

data aws_region current {}

# ECSタスク定義
data template_file taskdefinition {
  template = file("${path.module}/taskdefinition.tpl.json")

  vars = {
    container_name       = local.container_name
    container_image      = module.ecr.ecr_repository_url
    host_port            = local.host_port
    container_port       = local.container_port
    rds_cluster_endpoint = var.rds_cluster_endpoint
    rds_port             = var.rds_port
    elasticache_endpoint = var.elasticache_endpoint
    log_group_name       = local.cloudwatch_log_group_name
    log_stream_prefix    = local.cloudwatch_log_stream_prefix
    region               = data.aws_region.current.name
    db_name              = var.db_name
    db_user              = local.db_user
    db_password          = local.db_password
  }
}

# ECSクラスター
module ecs {
  source = "../../../modules/ecs"

  cloudwatch_log_group_name         = local.cloudwatch_log_group_name
  cloudwatch_log_stream_prefix      = local.cloudwatch_log_stream_prefix
  cloudwatch_logs_retention_in_days = local.cloudwatch_logs_retention_in_days
  ecs_service_alarm_low_name        = local.ecs_service_alarm_low_name
  ecs_service_alarm_high_name       = local.ecs_service_alarm_high_name

  ecs_cluster_name        = local.ecs_cluster_name
  ecs_service_name        = local.ecs_service_name
  container_name          = local.container_name
  container_desired_count = local.container_desired_count
  taskdefinition          = data.template_file.taskdefinition

  ecs_task_cpu                 = local.ecs_task_cpu
  ecs_task_memory              = local.ecs_task_memory
  ecs_task_definition_family   = local.ecs_task_definition_family
  ecs_task_execution_role_name = local.ecs_task_execution_role_name

  vpc_id                          = var.vpc_id
  ecs_service_subnets             = [var.private_subnet_a_id, var.private_subnet_c_id]
  ecs_service_security_group_name = local.ecs_service_security_group_name

  host_port             = local.host_port
  container_port        = local.container_port
  target_group_arn      = aws_lb_target_group.target_group.arn
  alb_security_group_id = var.alb_security_group_id

  application_autoscaling_scaleout_policy_name = local.application_autoscaling_scaleout_policy_name
  application_autoscaling_scalein_policy_name  = local.application_autoscaling_scalein_policy_name
  application_autoscaling_min_capacity         = local.application_autoscaling_min_capacity
  application_autoscaling_max_capacity         = local.application_autoscaling_max_capacity
}

# WAFルール
module waf {
  source                 = "../../../modules/waf"
  waf_ipset_allowed_name = local.waf_ipset_allowed_name
  waf_ipset_descriptors  = local.waf_ipset_descriptors

  # match set
  waf_size_constraint_set_name     = local.waf_size_constraint_set_name
  waf_sql_injection_match_set_name = local.waf_sql_injection_match_set_name
  waf_xss_match_set_name           = local.waf_xss_match_set_name

  # rule
  waf_rule_size_constraint_name        = local.waf_rule_size_constraint_name
  waf_rule_size_constraint_metric_name = local.waf_rule_size_constraint_metric_name
  waf_rule_sqli_name                   = local.waf_rule_sqli_name
  waf_rule_sqli_metric_name            = local.waf_rule_sqli_metric_name
  waf_rule_xss_name                    = local.waf_rule_xss_name
  waf_rule_xss_metric_name             = local.waf_rule_xss_metric_name
  waf_rule_ipset_allowed_name          = local.waf_rule_ipset_allowed_name
  waf_rule_ipset_allowed_metric_name   = local.waf_rule_ipset_allowed_metric_name

  # acl
  waf_web_acl_name        = local.waf_web_acl_name
  waf_web_acl_metric_name = local.waf_web_acl_metric_name
}

# CloudFront
module cloudfront {
  source = "../../../modules/cloudfront"

  # cloudfront
  alb_origin_access_identity_comment  = local.alb_origin_access_identity_comment
  cloudfront_distribution_domain_name = var.alb_domain_name
  cloudfront_distribution_comment     = local.cloudfront_distribution_comment

  # waf
  waf_web_acl_id = module.waf.waf_web_acl_id

  # alb
  alb_domain_name = var.alb_domain_name
}

# CodeCommit
module codecommit {
  source                     = "../../../modules/codecommit"
  codecommit_iam_group_name  = local.codecommit_iam_group_name
  codecommit_repository_name = local.codecommit_repository_name
}

data template_file buildspec {
  template = file("${path.module}/buildspec.tpl.yml")

  vars = {
    prefix             = var.prefix
    region             = data.aws_region.current.name
    codecommit_src_dir = local.codecommit_src_dir
    ecr_repository_url = module.ecr.ecr_repository_url
    container_name     = module.ecs.container_name
    image_tag          = "latest" # default
    ecs_service_name   = module.ecs.ecs_service_name
    ecs_taskdef_family = module.ecs.ecs_taskdef_family
  }
}

resource aws_s3_bucket artifact_s3_bucket {
  bucket = local.artifact_s3_bucket_name
  acl    = "private"
}

# CodeBuild
module codebuild {
  source = "../../../modules/codebuild"

  # vpc
  vpc_id              = var.vpc_id
  private_subnet_a_id = var.private_subnet_a_id
  private_subnet_c_id = var.private_subnet_c_id

  # codebuild
  codebuild_project_name        = local.codebuild_project_name
  codebuild_role_name           = local.codebuild_role_name
  codebuild_security_group_name = local.codebuild_security_group_name
  buildspec                     = data.template_file.buildspec.rendered
  environment_compute_type      = "BUILD_GENERAL1_SMALL"
  environment_image             = "aws/codebuild/standard:3.0"
  image_tag                     = "latest" # default
}

# CodePipeline
module codepipeline {
  source = "../../../modules/codepipeline-ecs"

  # s3
  artifact_s3_bucket_name = aws_s3_bucket.artifact_s3_bucket.bucket
  artifact_s3_bucket_arn  = aws_s3_bucket.artifact_s3_bucket.arn

  # codecommit
  codecommit_repository_name = module.codecommit.codecommit_repository_name
  codecommit_branch_name     = local.codecommit_branch_name

  # codepipeline
  codepipeline_name         = local.codepipeline_name
  codepipeline_role_name    = local.codepipeline_role_name
  codepipeline_project_name = module.codebuild.codebuild_project_name

  # ecs
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
}
