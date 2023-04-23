# common
variable prefix {}

# route53
variable route53_zone_id {}

# vpc
variable vpc_id {}
variable private_subnet_a_id {}
variable private_subnet_c_id {}
variable vpc_cidr_block {}

# codecommit
locals {
  codecommit_src_dir         = "xxxx-front"
  codecommit_iam_group_name  = "${var.prefix}-codecommit-iam-group"
  codecommit_repository_name = "${var.prefix}-codecommit"
}

# s3
locals {
  cloudfront_s3_bucket_name = "${var.prefix}-cloudfront"
  artifact_s3_bucket_name   = "${var.prefix}-codebuild-artifact"
}

# alb
variable alb_domain_name {}

# waf
locals {
  # conditions
  waf_ipset_allowed_name = "${var.prefix}-waf-ipset-allowed"
  waf_ipset_descriptors = [
    {
      value = "118.238.251.170/32", # TODO
      type  = "IPV4"
    }
  ]
  waf_size_constraint_set_name     = "${var.prefix}-waf-constraintset-size"
  waf_sql_injection_match_set_name = "${var.prefix}-waf-matchset-sqli"
  waf_xss_match_set_name           = "${var.prefix}-waf-matchset-xss"

  # rules
  waf_rule_size_constraint_name        = "${var.prefix}-waf-rule-size"
  waf_rule_size_constraint_metric_name = "wafrulesizemetric"
  waf_rule_sqli_name                   = "${var.prefix}-waf-rule-sqli"
  waf_rule_sqli_metric_name            = "wafrulesqlimetric"
  waf_rule_xss_name                    = "${var.prefix}-waf-rule-xss"
  waf_rule_xss_metric_name             = "wafrulexssmetric"
  waf_rule_ipset_allowed_name          = "${var.prefix}-waf-rule-ip-allowed"
  waf_rule_ipset_allowed_metric_name   = "wafruleipallowed"

  # acl
  waf_web_acl_name        = "${var.prefix}-waf-acl"
  waf_web_acl_metric_name = "wafaclmetric"
}

# cloudfront
variable acm_certificate_arn {}
variable alias_domain_name {}

locals {
  s3_origin_access_identity_comment   = "${var.prefix}-s3-origin-id"
  alb_origin_access_identity_comment  = "${var.prefix}-alb-origin-id"
  cloudfront_distribution_comment     = "${var.prefix}-cloudfront-dist"
  ordered_cache_behavior_path_pattern = "/api/*"
}

# codebuild
locals {
  codebuild_project_name        = "${var.prefix}-codebuild"
  codebuild_role_name           = "${var.prefix}-codebuild-role"
  codebuild_security_group_name = "${var.prefix}-codebuild-sg"
}

# codepipeline
locals {
  codepipeline_name      = "${var.prefix}-codepipeline"
  codepipeline_role_name = "${var.prefix}-codepipeline-role"
  codecommit_branch_name = "master"
}
