output route53_zone_id {
  value = aws_route53_zone.route53_zone.id
}

output acm_certificate_northeast_arn {
  value = aws_acm_certificate.acm_certificate_northeast.arn
}

output acm_certificate_virginia_arn {
  value = aws_acm_certificate.acm_certificate_virginia.arn
}
