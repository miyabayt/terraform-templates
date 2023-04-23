locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# common
variable prefix {}

locals {
  lambda_role_name = "ecs-service-start-labmda-role"
}
