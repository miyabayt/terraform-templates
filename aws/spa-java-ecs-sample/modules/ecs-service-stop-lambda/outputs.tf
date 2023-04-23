output ecs_service_stop_lambda_arn {
  value = aws_lambda_function.ecs_service_stop_lambda.arn
}

output ecs_service_stop_lambda_function_name {
  value = aws_lambda_function.ecs_service_stop_lambda.function_name
}
