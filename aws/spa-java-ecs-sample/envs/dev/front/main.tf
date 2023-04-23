# 公開するS3バケット
resource aws_s3_bucket cloudfront_s3_bucket_name {
  bucket = local.cloudfront_s3_bucket_name
  acl    = "private"
}

data aws_iam_policy_document cloudfront_s3_bucket_iam_policy_document {
  statement {
    actions = ["s3:GetObject", "s3:ListBucket"]

    resources = [
      "${aws_s3_bucket.cloudfront_s3_bucket_name.arn}",
      "${aws_s3_bucket.cloudfront_s3_bucket_name.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.s3_origin_access_identity_arn]
    }
  }
}

resource aws_s3_bucket_policy cloudfront_s3_bucket_policy {
  bucket = aws_s3_bucket.cloudfront_s3_bucket_name.id
  policy = data.aws_iam_policy_document.cloudfront_s3_bucket_iam_policy_document.json
}

# WAFルール
module waf {
  source                 = "../../../modules/waf"
  waf_ipset_allowed_name = local.waf_ipset_allowed_name
  waf_ipset_descriptors  = local.waf_ipset_descriptors

  # match set
  waf_size_constraint_set_name     = local.waf_size_constraint_set_name
  waf_sql_injection_match_set_name = local.waf_sql_injection_match_set_name
  waf_xss_match_set_name           = local.waf_xss_match_set_name

  # rule
  waf_rule_size_constraint_name        = local.waf_rule_size_constraint_name
  waf_rule_size_constraint_metric_name = local.waf_rule_size_constraint_metric_name
  waf_rule_sqli_name                   = local.waf_rule_sqli_name
  waf_rule_sqli_metric_name            = local.waf_rule_sqli_metric_name
  waf_rule_xss_name                    = local.waf_rule_xss_name
  waf_rule_xss_metric_name             = local.waf_rule_xss_metric_name
  waf_rule_ipset_allowed_name          = local.waf_rule_ipset_allowed_name
  waf_rule_ipset_allowed_metric_name   = local.waf_rule_ipset_allowed_metric_name

  # acl
  waf_web_acl_name        = local.waf_web_acl_name
  waf_web_acl_metric_name = local.waf_web_acl_metric_name
}

# CloudFront
module cloudfront {
  source = "../../../modules/cloudfront"

  # cloudfront
  s3_origin_access_identity_comment   = local.s3_origin_access_identity_comment
  alb_origin_access_identity_comment  = local.alb_origin_access_identity_comment
  cloudfront_distribution_domain_name = aws_s3_bucket.cloudfront_s3_bucket_name.bucket_regional_domain_name
  cloudfront_distribution_comment     = local.cloudfront_distribution_comment
  ordered_cache_behavior_path_pattern = local.ordered_cache_behavior_path_pattern
  acm_certificate_arn                 = var.acm_certificate_arn
  alias_domain_name                   = var.alias_domain_name

  # waf
  waf_web_acl_id = module.waf.waf_web_acl_id

  # alb
  alb_domain_name = var.alb_domain_name
}

resource aws_route53_record route53_record_cloudfront_cname {
  zone_id         = var.route53_zone_id
  name            = var.alias_domain_name
  type            = "CNAME"
  ttl             = "7200"
  records         = [module.cloudfront.cloudfront_domain_name]
  allow_overwrite = true
}

# CodeCommit
module codecommit {
  source                     = "../../../modules/codecommit"
  codecommit_iam_group_name  = local.codecommit_iam_group_name
  codecommit_repository_name = local.codecommit_repository_name
}

data template_file buildspec {
  template = file("${path.module}/buildspec.tpl.yml")

  vars = {
    codecommit_src_dir         = local.codecommit_src_dir
    cloudfront_s3_bucket_name  = local.cloudfront_s3_bucket_name
    cloudfront_distribution_id = module.cloudfront.cloudfront_distribution_id
  }
}

# アーティファクトS3バケット
resource aws_s3_bucket artifact_s3_bucket {
  bucket = local.artifact_s3_bucket_name
  acl    = "private"
}

# CodeBuild
module codebuild {
  source = "../../../modules/codebuild"

  # vpc
  vpc_id              = var.vpc_id
  private_subnet_a_id = var.private_subnet_a_id
  private_subnet_c_id = var.private_subnet_c_id

  # codebuild
  codebuild_project_name        = local.codebuild_project_name
  codebuild_role_name           = local.codebuild_role_name
  codebuild_security_group_name = local.codebuild_security_group_name
  buildspec                     = data.template_file.buildspec.rendered
  environment_compute_type      = "BUILD_GENERAL1_SMALL"
  environment_image             = "aws/codebuild/standard:3.0"
  image_tag                     = "latest" # default
}

# CodePipeline
module codepipeline {
  source = "../../../modules/codepipeline-cloudfront"

  # s3
  artifact_s3_bucket_name = aws_s3_bucket.artifact_s3_bucket.bucket
  artifact_s3_bucket_arn  = aws_s3_bucket.artifact_s3_bucket.arn

  # codecommit
  codecommit_repository_name = module.codecommit.codecommit_repository_name
  codecommit_branch_name     = local.codecommit_branch_name

  # codepipeline
  codepipeline_name         = local.codepipeline_name
  codepipeline_role_name    = local.codepipeline_role_name
  codepipeline_project_name = module.codebuild.codebuild_project_name
}
