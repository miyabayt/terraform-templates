module vpc {
  source = "../../../modules/vpc"

  vpc_name = local.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnet_a_name  = local.public_subnet_a_name
  public_subnet_c_name  = local.public_subnet_c_name
  private_subnet_a_name = local.private_subnet_a_name
  private_subnet_c_name = local.private_subnet_c_name

  public_subnet_a_cidr_block  = var.public_subnet_a_cidr_block
  public_subnet_c_cidr_block  = var.public_subnet_c_cidr_block
  private_subnet_a_cidr_block = var.private_subnet_a_cidr_block
  private_subnet_c_cidr_block = var.private_subnet_c_cidr_block

  public_rtb_name  = local.public_rtb_name
  private_rtb_name = local.private_rtb_name

  nat_eip_name          = local.nat_eip_name
  nat_gateway_name      = local.nat_gateway_name
  internet_gateway_name = local.internet_gateway_name
}

module alb {
  source = "../../../modules/alb"

  alb_name                = local.alb_name
  alb_security_group_name = local.alb_security_group_name
  vpc_id                  = module.vpc.vpc_id
  cidr_blocks             = [module.vpc.public_subnet_a_cidr_block, module.vpc.public_subnet_c_cidr_block]
  public_subnet_a_id      = module.vpc.public_subnet_a_id
  public_subnet_c_id      = module.vpc.public_subnet_c_id
  http_port               = var.alb_http_port
  https_port              = var.alb_https_port
  acm_certificate_arn     = var.acm_certificate_arn
}

data aws_vpc_endpoint_service s3_vpc_endpoint_service {
  service      = "s3"
  service_type = "Gateway"
}

# S3 VPCエンドポイント
resource aws_vpc_endpoint s3_vpc_endpoint {
  vpc_id       = module.vpc.vpc_id
  service_name = data.aws_vpc_endpoint_service.s3_vpc_endpoint_service.service_name
  tags         = merge(local.default_tags, map("Name", local.s3_vpc_endpoint_name))
}

resource aws_vpc_endpoint_route_table_association private_s3_vpc_endpoint_route_table_association {
  vpc_endpoint_id = aws_vpc_endpoint.s3_vpc_endpoint.id
  route_table_id  = module.vpc.private_route_table_id
}
