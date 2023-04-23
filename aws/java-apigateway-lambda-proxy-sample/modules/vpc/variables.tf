locals {
  default_tags = {
    createdBy = "terraform"
  }
}

variable vpc_name {}
variable vpc_cidr {}

variable public_subnet_a_name {}
variable public_subnet_c_name {}
variable private_subnet_a_name {}
variable private_subnet_c_name {}

variable public_subnet_a_cidr_block {}
variable public_subnet_c_cidr_block {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

variable public_rtb_name {}
variable private_rtb_name {}

data aws_availability_zones available {
  state = "available"
}

variable nat_eip_name {}
variable nat_gateway_name {}
variable internet_gateway_name {}
