output rds_start_lambda_arn {
  value = aws_lambda_function.rds_start_lambda.arn
}

output rds_start_lambda_function_name {
  value = aws_lambda_function.rds_start_lambda.function_name
}
