output vpc_id {
  value = module.vpc.vpc_id
}

output public_subnet_a_id {
  value = module.vpc.public_subnet_a_id
}

output public_subnet_c_id {
  value = module.vpc.public_subnet_c_id
}

output private_subnet_a_id {
  value = module.vpc.private_subnet_a_id
}

output private_subnet_c_id {
  value = module.vpc.private_subnet_c_id
}

output s3_vpc_endpoint_id {
  value = aws_vpc_endpoint.s3_vpc_endpoint.id
}


output codebuild_security_group_id {
  value = aws_security_group.codebuild_security_group.id
}

output lambda_security_group_id {
  value = aws_security_group.lambda_security_group.id
}

output rds_proxy_security_group_id {
  value = aws_security_group.rds_proxy_security_group.id
}

output rds_security_group_id {
  value = aws_security_group.rds_security_group.id
}
