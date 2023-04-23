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

output alb_security_group_id {
  value = module.alb.alb_security_group_id
}

output alb_listener_arn {
  value = module.alb.alb_listener_arn
}

output alb_dns_name {
  value = module.alb.alb_dns_name
}

output s3_vpc_endpoint_id {
  value = aws_vpc_endpoint.s3_vpc_endpoint.id
}
