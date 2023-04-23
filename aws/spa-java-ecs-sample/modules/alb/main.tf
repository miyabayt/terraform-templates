resource aws_security_group alb_security_group {
  name   = var.alb_security_group_name
  vpc_id = var.vpc_id
}

resource aws_security_group_rule alb_security_group_rule_ingress {
  security_group_id = aws_security_group.alb_security_group.id
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_security_group_rule alb_security_group_rule_egress {
  security_group_id = aws_security_group.alb_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_alb alb {
  name            = var.alb_name
  security_groups = [aws_security_group.alb_security_group.id]
  subnets = [
    var.public_subnet_a_id,
    var.public_subnet_c_id,
  ]
  internal                   = false
  enable_deletion_protection = true
}

resource aws_alb_listener alb_listener {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}
