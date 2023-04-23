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
  lambda_handler       = "index.handler"
  lambda_environment_variables = {
    NODE_ENV : "dev"
    TZ : "Asia/Tokyo"
  }
  lambda_runtime     = "nodejs14.x"
  lambda_memory_size = "128"
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
