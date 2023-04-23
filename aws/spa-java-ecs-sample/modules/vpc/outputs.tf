output vpc_id {
  value = aws_vpc.vpc.id
}

output vpc_cidr_block {
  value = aws_vpc.vpc.cidr_block
}

output public_subnet_a_id {
  value = aws_subnet.public_subnet_a.id
}

output public_subnet_c_id {
  value = aws_subnet.public_subnet_c.id
}

output public_subnet_a_cidr_block {
  value = aws_subnet.public_subnet_a.cidr_block
}

output public_subnet_c_cidr_block {
  value = aws_subnet.public_subnet_c.cidr_block
}

output private_subnet_a_id {
  value = aws_subnet.private_subnet_a.id
}

output private_subnet_c_id {
  value = aws_subnet.private_subnet_c.id
}

output private_subnet_a_cidr_block {
  value = aws_subnet.private_subnet_a.cidr_block
}

output private_subnet_c_cidr_block {
  value = aws_subnet.private_subnet_c.cidr_block
}

output private_route_table_id {
  value = aws_route_table.private_rtb.id
}
