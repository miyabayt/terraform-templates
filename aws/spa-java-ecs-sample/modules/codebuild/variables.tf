locals {
  default_tags = {
    createdBy = "terraform"
  }
}

data aws_availability_zones available {
  state = "available"
}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}

# codebuild
variable codebuild_role_name {}
variable codebuild_security_group_name {}
variable codebuild_project_name {}
variable environment_compute_type {}
variable environment_image {}
variable image_tag {}
variable buildspec {}
