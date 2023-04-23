resource aws_acm_certificate acm_certificate {
  domain_name               = var.acm_certificate_domain_name
  subject_alternative_names = ["*.${var.acm_certificate_domain_name}"]
  validation_method         = "DNS"
  tags                      = local.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_route53_zone route53_zone {
  name = var.route53_zone_name
}

resource aws_route53_record domain_validation_record {
  zone_id         = aws_route53_zone.route53_zone.zone_id
  name            = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_name
  type            = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_type
  records         = [aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource aws_acm_certificate_validation acm_certificate_validation {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [aws_route53_record.domain_validation_record.fqdn]
}

resource aws_route53_record route53_record_alb_cname {
  zone_id         = aws_route53_zone.route53_zone.zone_id
  name            = var.alb_domain_name
  type            = "CNAME"
  ttl             = "7200"
  records         = [var.alb_dns_name]
  allow_overwrite = true
}
