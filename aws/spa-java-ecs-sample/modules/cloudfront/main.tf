resource aws_cloudfront_origin_access_identity s3_origin_access_identity {
  comment = var.s3_origin_access_identity_comment
}

resource aws_cloudfront_origin_access_identity alb_origin_access_identity {
  comment = var.alb_origin_access_identity_comment
}

resource aws_cloudfront_distribution cloudfront_distribution {
  aliases = [var.alias_domain_name]
  tags    = local.default_tags

  origin {
    domain_name = var.alb_domain_name
    origin_id   = aws_cloudfront_origin_access_identity.alb_origin_access_identity.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  origin {
    domain_name = var.cloudfront_distribution_domain_name
    origin_id   = aws_cloudfront_origin_access_identity.s3_origin_access_identity.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_distribution_comment
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_cloudfront_origin_access_identity.s3_origin_access_identity.id

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = var.ordered_cache_behavior_path_pattern
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_cloudfront_origin_access_identity.alb_origin_access_identity.id

    forwarded_values {
      query_string = true
      headers = [
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Origin",
        "Authorization"
      ]
      cookies {
        forward = "all"
      }
    }

    default_ttl            = 0
    min_ttl                = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"] # ["US", "CA", "GB", "DE", "JP"]
    }
  }

  price_class         = "PriceClass_200"
  wait_for_deployment = false

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  # waf
  web_acl_id = var.waf_web_acl_id
}
