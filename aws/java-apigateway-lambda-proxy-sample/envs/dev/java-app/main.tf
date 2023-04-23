# Lambda
module lambda {
  source = "../../../modules/lambda"

  lambda_role_name                  = local.lambda_role_name
  lambda_function_name              = local.lambda_function_name
  lambda_handler                    = local.lambda_handler
  lambda_runtime                    = local.lambda_runtime
  lambda_memory_size                = local.lambda_memory_size
  lambda_timeout                    = local.lambda_timeout
  lambda_security_group_id          = var.lambda_security_group_id
  lambda_environment_variables      = local.lambda_environment_variables
  cloudwatch_logs_retention_in_days = local.cloudwatch_logs_retention_in_days

  # vpc
  vpc_id     = var.vpc_id
  subnet_ids = [var.private_subnet_a_id, var.private_subnet_c_id]
}

# API Gateway
module apigateway {
  source            = "../../../modules/apigateway"
  rest_api_name     = local.java_app_apigateway_name
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  stage_name        = local.stage_name
}

resource aws_lambda_permission lambda_permission {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apigateway.api_gateway_execution_arn}/*/*"
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
    prefix               = var.prefix
    codecommit_src_dir   = local.codecommit_src_dir
    lambda_function_name = local.lambda_function_name
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
  codebuild_project_name      = local.codebuild_project_name
  codebuild_role_name         = local.codebuild_role_name
  codebuild_security_group_id = var.codebuild_security_group_id
  buildspec                   = data.template_file.buildspec.rendered
  environment_compute_type    = local.environment_compute_type
  environment_image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

# CodePipeline
module codepipeline {
  source = "../../../modules/codepipeline"

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
}
