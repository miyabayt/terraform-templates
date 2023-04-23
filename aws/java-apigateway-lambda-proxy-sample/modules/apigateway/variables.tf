locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# apigateway
variable rest_api_name {}
variable lambda_invoke_arn {}
variable stage_name {}
