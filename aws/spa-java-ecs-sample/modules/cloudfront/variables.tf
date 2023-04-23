locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# s3
variable s3_origin_access_identity_comment {}
variable alb_origin_access_identity_comment {}

# alb
variable alb_domain_name {}

# waf
variable waf_web_acl_id {}

# cloudfront
variable alias_domain_name {}
variable acm_certificate_arn {}
variable cloudfront_distribution_domain_name {}
variable cloudfront_distribution_comment {}
variable ordered_cache_behavior_path_pattern {}
