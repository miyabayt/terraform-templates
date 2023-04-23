output cloudfront_distribution_id {
  value = aws_cloudfront_distribution.cloudfront_distribution.id
}

output cloudfront_domain_name {
  value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

output s3_origin_access_identity_arn {
  value = aws_cloudfront_origin_access_identity.s3_origin_access_identity.iam_arn
}
