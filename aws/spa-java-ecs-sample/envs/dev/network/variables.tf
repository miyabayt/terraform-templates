locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# common
variable prefix {}

# vpc
variable vpc_cidr {}
variable public_subnet_a_cidr_block {}
variable public_subnet_c_cidr_block {}
variable private_subnet_a_cidr_block {}
variable private_subnet_c_cidr_block {}

locals {
  vpc_name              = "${var.prefix}-vpc"
  public_subnet_a_name  = "${var.prefix}-public-subnet-a"
  public_subnet_c_name  = "${var.prefix}-public-subnet-c"
  private_subnet_a_name = "${var.prefix}-private-subnet-a"
  private_subnet_c_name = "${var.prefix}-private-subnet-c"
  public_rtb_name       = "${var.prefix}-public-rtb"
  private_rtb_name      = "${var.prefix}-private-rtb"
  nat_eip_name          = "${var.prefix}-nat-eip"
  nat_gateway_name      = "${var.prefix}-natgw"
  internet_gateway_name = "${var.prefix}-igw"

}

# alb
variable alb_http_port {}
variable alb_https_port {}
variable acm_certificate_arn {}

locals {
  alb_name                = "${var.prefix}-alb"
  alb_security_group_name = "${var.prefix}-alb-sg"
}

# vpc endpoint
locals {
  s3_vpc_endpoint_name = "${var.prefix}-s3-vpce"
}
