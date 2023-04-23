locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# cloudwatch event
variable rule_name {}
variable schedule_expression {}
variable event_target_arn {}
variable function_name {}
variable input {}
