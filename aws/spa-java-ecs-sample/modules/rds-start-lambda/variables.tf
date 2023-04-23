locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# common
variable prefix {}

locals {
  lambda_role_name = "rds-start-labmda-role"
}
