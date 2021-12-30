module "api_gateway" {
  source = "./modules/http_api_gateway"

  name        = var.application_name
  description = var.description

  cors_origins = local.api_gw_cors_origins

  #############################
  # Endpoints authorizers
  #############################
  # Custom lambda authorizer
  custom_authorizer_lambda_arn        = module.function_custom_apis_authorizer.lambda_function_arn
  custom_authorizer_lambda_invoke_arn = module.function_custom_apis_authorizer.lambda_function_invoke_arn
  authorizer_cache_ttl                = var.api_gw_authorizer_cache_ttl

  #############################
  # Domain
  #############################
  api_gw_domain       = local.api_gw_domain
  acm_certificate_arn = module.acm.this_acm_certificate_arn

  api_endpoints = {
    "GET /cloudAccounts"  = module.function_cloud_accounts_get.lambda_function_arn
    "POST /cloudAccounts" = module.function_cloud_accounts_post.lambda_function_arn
  }

  tags = merge(
    local.default_tags,
    lookup(local.application_tags, "api-gw", {})
  )
}
