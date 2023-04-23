output rds_stop_lambda_arn {
  value = aws_lambda_function.rds_stop_lambda.arn
}

output rds_stop_lambda_function_name {
  value = aws_lambda_function.rds_stop_lambda.function_name
}
