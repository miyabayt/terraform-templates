output alb_dns_name {
  value = aws_alb.alb.dns_name
}

output alb_arn {
  value = aws_alb.alb.arn
}

output alb_listener_arn {
  value = aws_alb_listener.alb_listener.arn
}

output alb_security_group_id {
  value = aws_security_group.alb_security_group.id
}
