locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# s3
variable alb_origin_access_identity_comment {}

# alb
variable alb_domain_name {}

# waf
variable waf_web_acl_id {}

# cloudfront
variable cloudfront_distribution_domain_name {}
variable cloudfront_distribution_comment {}
