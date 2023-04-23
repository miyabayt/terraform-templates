locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# route53
variable route53_zone_name {}
variable alb_domain_name {}
variable alb_dns_name {}

# acm
variable acm_certificate_domain_name {}
