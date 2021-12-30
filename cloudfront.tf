resource "aws_cloudfront_origin_access_identity" "main" {
  comment = var.description
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = local.cdn_whilelisted_countries
      # TODO: make a var for locations and enable more countries in prod
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.acm.this_acm_certificate_arn
    ssl_support_method  = "sni-only"
  }


  custom_error_response {
    error_caching_min_ttl = "1"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = var.description
  aliases             = [local.cdn_domain]
  price_class         = "PriceClass_200"
  web_acl_id          = aws_wafv2_web_acl.main.arn
  tags                = local.default_tags
}
