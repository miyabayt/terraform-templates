module rds-start-lambda {
  source = "../../../modules/rds-start-lambda"

  # common
  prefix = var.prefix
}

module rds-stop-lambda {
  source = "../../../modules/rds-stop-lambda"

  # common
  prefix = var.prefix
}

module ecs-service-start-lambda {
  source = "../../../modules/ecs-service-start-lambda"

  # common
  prefix = var.prefix
}

module ecs-service-stop-lambda {
  source = "../../../modules/ecs-service-stop-lambda"

  # common
  prefix = var.prefix
}

module rds-start-event {
  source              = "../../../modules/cloudwatch-event"
  rule_name           = "${var.prefix}-rds-start-rule"
  schedule_expression = local.start_rule_schedule_expression
  event_target_arn    = module.rds-start-lambda.rds_start_lambda_arn
  function_name       = module.rds-start-lambda.rds_start_lambda_function_name
  input = jsonencode(
    {
      db_cluster_identifier = var.rds_cluster_identifier
    }
  )
}

module rds-stop-event {
  source              = "../../../modules/cloudwatch-event"
  rule_name           = "${var.prefix}-rds-stop-rule"
  schedule_expression = local.stop_rule_schedule_expression
  event_target_arn    = module.rds-stop-lambda.rds_stop_lambda_arn
  function_name       = module.rds-stop-lambda.rds_stop_lambda_function_name
  input = jsonencode(
    {
      db_cluster_identifier = var.rds_cluster_identifier
    }
  )
}

module backend-start-event {
  source              = "../../../modules/cloudwatch-event"
  rule_name           = "${var.prefix}-backend-start-rule"
  schedule_expression = local.start_rule_schedule_expression
  event_target_arn    = module.ecs-service-start-lambda.ecs_service_start_lambda_arn
  function_name       = module.ecs-service-start-lambda.ecs_service_start_lambda_function_name
  input = jsonencode(
    {
      cluster_name = "${var.prefix}-backend-cluster"
      service_name = "${var.prefix}-backend-service"
    }
  )
}

module backend-stop-event {
  source              = "../../../modules/cloudwatch-event"
  rule_name           = "${var.prefix}-backend-stop-rule"
  schedule_expression = local.stop_rule_schedule_expression
  event_target_arn    = module.ecs-service-stop-lambda.ecs_service_stop_lambda_arn
  function_name       = module.ecs-service-stop-lambda.ecs_service_stop_lambda_function_name
  input = jsonencode(
    {
      cluster_name = "${var.prefix}-backend-cluster"
      service_name = "${var.prefix}-backend-service"
    }
  )
}
