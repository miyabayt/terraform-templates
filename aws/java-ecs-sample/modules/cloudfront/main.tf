resource aws_cloudfront_origin_access_identity alb_origin_access_identity {
  comment = var.alb_origin_access_identity_comment
}

resource aws_cloudfront_distribution cloudfront_distribution {
  tags = local.default_tags

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

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_distribution_comment
  default_root_object = "index.html"

  default_cache_behavior {
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
    cloudfront_default_certificate = true
  }

  # waf
  web_acl_id = var.waf_web_acl_id
}
