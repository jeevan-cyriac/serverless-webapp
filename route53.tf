resource "aws_route53_zone" "cs_portal" {
  name = local.hosted_zone_name

  tags = local.default_tags
}

resource "aws_route53_record" "cs_portal_nameservers" {

  provider = aws.cst

  zone_id = var.parent_zone_id
  name    = local.hosted_zone_name
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.cs_portal.name_servers
}

resource "aws_route53_record" "cognito" {
  count = var.enable_cognito_custom_domain ? 1 : 0

  name    = aws_cognito_user_pool_domain.main[0].domain
  type    = "A"
  zone_id = aws_route53_zone.cs_portal.id
  alias {
    name = aws_cognito_user_pool_domain.main[0].cloudfront_distribution_arn
    # Every Cognito custom domain created requires CloudFront distribution's
    # zone ID Z2FDTNDATAQYW2
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront" {
  name    = local.cdn_domain
  type    = "A"
  zone_id = aws_route53_zone.cs_portal.id

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_gateway" {
  name    = local.api_gw_domain
  type    = "A"
  zone_id = aws_route53_zone.cs_portal.id

  alias {
    name                   = module.api_gateway.api_gw_domain_name
    zone_id                = module.api_gateway.api_gw_domain_zone_id
    evaluate_target_health = false
  }
}
