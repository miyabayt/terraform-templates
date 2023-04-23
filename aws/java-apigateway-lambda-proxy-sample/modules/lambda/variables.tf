locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# lambda
variable lambda_role_name {}
variable lambda_function_name {}
variable lambda_handler {}
variable lambda_runtime {}
variable lambda_memory_size {}
variable lambda_timeout {}
variable lambda_security_group_id {}
variable lambda_environment_variables {}

# cloudwatch
variable cloudwatch_logs_retention_in_days {}

# vpc
variable vpc_id {}
variable subnet_ids {}
