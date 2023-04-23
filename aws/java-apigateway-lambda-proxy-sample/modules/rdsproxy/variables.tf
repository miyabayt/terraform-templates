locals {
  default_tags = {
    createdBy = "terraform"
  }
}

variable rds_proxy_name {}
variable rds_proxy_role_name {}
variable rds_proxy_policy_name {}
variable rds_proxy_security_group_id {}
variable rds_proxy_target_id {}
variable rds_engine_family {}
variable vpc_id {}
variable db_subnet_ids {}
variable secret_arn {}
