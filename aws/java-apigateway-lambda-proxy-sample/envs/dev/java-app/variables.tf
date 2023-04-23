# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}

# lambda
variable lambda_security_group_id {}

locals {
  lambda_role_name     = "${var.prefix}-lambda-role"
  lambda_function_name = "${var.prefix}-lambda"
  lambda_handler       = "io.micronaut.function.aws.proxy.MicronautLambdaHandler"
  lambda_environment_variables = {
    MICRONAUT_ENVIRONMENTS : "dev"
    DATASOURCES_DEFAULT_URL : "jdbc:mysql://${var.rds_proxy_endpoint}:${var.rds_port}/${var.db_name}?useSSL=false&characterEncoding=UTF-8"
    DATASOURCES_DEFAULT_USERNAME : "${var.db_user}"
    DATASOURCES_DEFAULT_PASSWORD : "${var.db_password}"
    TZ : "Asia/Tokyo"
  }
  lambda_runtime     = "provided.al2"
  lambda_memory_size = "512"
  lambda_timeout     = 30
}

# apigateway
locals {
  java_app_apigateway_name = "${var.prefix}-apigw"
  stage_name               = "dev"
}

# cloudwatch
locals {
  cloudwatch_logs_retention_in_days = 7
}

# rds
variable rds_port {}
variable db_name {}
variable db_user {}
variable db_password {}

# rds proxy
variable rds_proxy_endpoint {}

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
variable codebuild_security_group_id {}

locals {
  codebuild_project_name        = "${var.prefix}-codebuild"
  codebuild_role_name           = "${var.prefix}-codebuild-role"
  codebuild_security_group_name = "${var.prefix}-codebuild-sg"
  environment_compute_type      = "BUILD_GENERAL1_MEDIUM"
}

# codepipeline
locals {
  codepipeline_name      = "${var.prefix}-codepipeline"
  codepipeline_role_name = "${var.prefix}-codepipeline-role"
  codecommit_branch_name = "master"
}
