resource aws_vpc vpc {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    local.default_tags, map(
      "Name", var.vpc_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_subnet public_subnet_a {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_a_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = merge(
    local.default_tags, map(
      "Name", var.public_subnet_a_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_subnet public_subnet_c {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_c_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = merge(
    local.default_tags, map(
      "Name", var.public_subnet_c_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_subnet private_subnet_a {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(
    local.default_tags, map(
      "Name", var.private_subnet_a_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_subnet private_subnet_c {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_c_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = merge(
    local.default_tags, map(
      "Name", var.private_subnet_c_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_eip nat {
  vpc = true
  tags = merge(
    local.default_tags, map(
      "Name", var.nat_eip_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_nat_gateway natgw {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = merge(
    local.default_tags, map(
      "Name", var.nat_gateway_name
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_internet_gateway igw {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.default_tags, map(
      "Name", var.internet_gateway_name
  ))
}

resource aws_route_table public_rtb {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.default_tags, map(
      "Name", var.public_rtb_name
  ))

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource aws_route_table private_rtb {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.default_tags, map(
      "Name", var.private_rtb_name
  ))

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_route_table_association public_rtb_a {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource aws_route_table_association public_rtb_c {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_rtb.id
}

resource aws_route_table_association private_rtb_a {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rtb.id
}

resource aws_route_table_association private_rtb_c {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_rtb.id
}