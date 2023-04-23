# common
variable prefix {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

# dynamodb
locals {
  dynamodb_tables = [
    {
      table_name     = "users"
      hash_key       = "id"
      hash_key_type  = "S"
    }
  ]
}
