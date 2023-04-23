locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# vpc
variable vpc_id {}
variable cidr_blocks {}
variable public_subnet_a_id {}
variable public_subnet_c_id {}

# alb
variable alb_name {}
variable http_port {}
variable https_port {}
variable alb_security_group_name {}
variable acm_certificate_arn {}
