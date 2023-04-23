provider aws {
  region     = var.aws_region
}

module network {
  source = "./network"

  # common
  prefix = var.prefix

  # vpc
  vpc_cidr                    = var.vpc_cidr
  public_subnet_a_cidr_block  = var.public_subnet_a_cidr_block
  public_subnet_c_cidr_block  = var.public_subnet_c_cidr_block
  private_subnet_a_cidr_block = var.private_subnet_a_cidr_block
  private_subnet_c_cidr_block = var.private_subnet_c_cidr_block

  # security group
  codebuild_security_group_name = "${var.prefix}-codebuild-sg"
  lambda_security_group_name    = "${var.prefix}-lambda-sg"
}

module middleware {
  source = "./middleware"

  # common
  prefix = var.prefix

  # vpc
  vpc_id                      = module.network.vpc_id
  private_subnet_a_id         = module.network.private_subnet_a_id
  private_subnet_c_id         = module.network.private_subnet_c_id
  private_subnet_a_cidr_block = var.private_subnet_a_cidr_block
  private_subnet_c_cidr_block = var.private_subnet_c_cidr_block
}

# Node.jsアプリケーション
module nodejs-app {
  source = "./nodejs-app"

  # common
  prefix = "${var.prefix}"

  # vpc
  vpc_id              = module.network.vpc_id
  private_subnet_a_id = module.network.private_subnet_a_id
  private_subnet_c_id = module.network.private_subnet_c_id

  # security group
  codebuild_security_group_id = module.network.codebuild_security_group_id
  lambda_security_group_id    = module.network.lambda_security_group_id
}
