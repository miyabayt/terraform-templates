provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource aws_acm_certificate acm_certificate_northeast {
  domain_name               = var.acm_certificate_domain_name
  subject_alternative_names = ["*.${var.acm_certificate_domain_name}"]
  validation_method         = "DNS"
  tags                      = local.default_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_acm_certificate acm_certificate_virginia {
  provider                  = aws.virginia
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

resource aws_route53_record domain_validation_record_northeast {
  zone_id         = aws_route53_zone.route53_zone.zone_id
  name            = aws_acm_certificate.acm_certificate_northeast.domain_validation_options.0.resource_record_name
  type            = aws_acm_certificate.acm_certificate_northeast.domain_validation_options.0.resource_record_type
  records         = [aws_acm_certificate.acm_certificate_northeast.domain_validation_options.0.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource aws_acm_certificate_validation acm_certificate_validation_northeast {
  certificate_arn         = aws_acm_certificate.acm_certificate_northeast.arn
  validation_record_fqdns = [aws_route53_record.domain_validation_record_northeast.fqdn]
}

resource aws_route53_record domain_validation_record_virginia {
  zone_id         = aws_route53_zone.route53_zone.zone_id
  name            = aws_acm_certificate.acm_certificate_virginia.domain_validation_options.0.resource_record_name
  type            = aws_acm_certificate.acm_certificate_virginia.domain_validation_options.0.resource_record_type
  records         = [aws_acm_certificate.acm_certificate_virginia.domain_validation_options.0.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource aws_acm_certificate_validation acm_certificate_validation_virginia {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.acm_certificate_virginia.arn
  validation_record_fqdns = [aws_route53_record.domain_validation_record_virginia.fqdn]
}

resource aws_route53_record route53_record_alb_cname {
  zone_id         = aws_route53_zone.route53_zone.zone_id
  name            = var.alb_domain_name
  type            = "CNAME"
  ttl             = "7200"
  records         = [var.alb_dns_name]
  allow_overwrite = true
}
