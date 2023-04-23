variable tags {
  default = {}
}

locals {
  default_tags = {
    createdBy = "terraform"
  }
}

variable security_group_name {}

variable cluster_identifier {}

variable subnet_group_name {}

variable parameter_group_name {}

variable cluster_parameter_group_name {}

variable cluster_instance_identifier {}

variable rds_instance_class {}

variable vpc_id {}

variable rds_port {}

variable cidr_blocks {}

variable db_subnet_ids {}

variable db_name {}

variable db_user {}

variable db_password {}
