variable tags {
  default = {}
}

locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# vpc
variable vpc_id {}
variable rds_security_group_name {}

# rds
variable rds_engine {}
variable rds_cluster_identifier {}
variable rds_cluster_instance_identifier {}
variable rds_instance_class {}
variable rds_port {}
variable rds_schema {}

variable db_subnet_group_name {}
variable db_subnet_ids {}
variable cidr_blocks {}

variable rds_parameter_group_name {}
variable rds_cluster_parameter_group_family {}
variable rds_cluster_parameter_group_name {}
variable db_character_set {}
variable db_collation {}
variable db_timezone {}

# ssm
variable db_username {}
variable db_password {}
