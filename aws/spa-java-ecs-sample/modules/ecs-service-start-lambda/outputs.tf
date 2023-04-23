output ecs_service_start_lambda_arn {
  value = aws_lambda_function.ecs_service_start_lambda.arn
}

output ecs_service_start_lambda_function_name {
  value = aws_lambda_function.ecs_service_start_lambda.function_name
}
