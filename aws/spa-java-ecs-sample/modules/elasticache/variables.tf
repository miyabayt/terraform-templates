locals {
  default_tags = {
    createdBy = "terraform"
  }
}

variable security_group_name {}
variable subnet_group_name {}
variable replication_group_id {}

variable vpc_id {}

variable cidr_blocks {}

variable name {}

variable parameter_group_name {}

variable engine_version {}

variable port {}

variable node_type {}

variable snapshot_retention_limit {}

variable automatic_failover_enabled {}

variable number_cache_clusters {}

variable subnet_ids {}
