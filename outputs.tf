output "api_gateway_fqdn" {
  value = local.api_gw_domain
}

output "cloudfront_fqdn" {
  value = local.cdn_domain
}

output "cognito_fqdn" {
  value = var.enable_cognito_custom_domain ? local.cognito_custom_domain : "${aws_cognito_user_pool_domain.amazon[0].domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_urn" {
  value = "urn:amazon:cognito:sp:${aws_cognito_user_pool.main.id}"
}

output "cs_portal_frontend_config" {
  value = map(
    "s3_bucket_website", aws_s3_bucket.website.id,
    "cloudfront_distribution_id", aws_cloudfront_distribution.main.id,
    "user_pool_id", aws_cognito_user_pool.main.id,
    "user_app_client_id", aws_cognito_user_pool_client.main.id,
    "api_gw_domain", local.api_gw_domain,
    "oauth_domain", var.enable_cognito_custom_domain ? local.cognito_custom_domain : "${aws_cognito_user_pool_domain.amazon[0].domain}.auth.${var.aws_region}.amazoncognito.com",
  )
}
