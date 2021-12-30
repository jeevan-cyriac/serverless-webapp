resource "aws_cognito_user_pool" "main" {
  name                = var.application_name
  username_attributes = ["email"]

  schema {
    name                = "role"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true ## This allows Cognito to update user attributes after authenticating with AD
  }

  lifecycle {
    ignore_changes = [
      email_configuration,
      schema
    ]
  }
  tags = local.default_tags

}

resource "aws_cognito_user_pool_client" "main" {

  name         = "main"
  user_pool_id = aws_cognito_user_pool.main.id

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "phone", "profile"]
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  callback_urls                        = local.cognito_callback_urls
  logout_urls                          = local.cognito_logout_urls
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = [aws_cognito_identity_provider.azure.provider_name, "COGNITO"]

  access_token_validity = 60
  id_token_validity     = 60

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

}

# This custom domain is created when you set enable_cognito_custom_domain as true
resource "aws_cognito_user_pool_domain" "main" {
  count = var.enable_cognito_custom_domain ? 1 : 0

  domain          = local.cognito_custom_domain
  certificate_arn = module.acm.this_acm_certificate_arn
  user_pool_id    = aws_cognito_user_pool.main.id

  depends_on = [aws_route53_record.cloudfront]
}

# The random string is used for generating a unique cognito domain  
resource "random_string" "cognito_amazon_domain_suffix" {
  count = var.enable_cognito_custom_domain ? 0 : 1

  length  = 10
  upper   = false
  special = false
}

# The default domain is created when you set enable_cognito_custom_domain as false
# custom domain can be disabled in dev env since AWS has a max limit on number of custom domains
resource "aws_cognito_user_pool_domain" "amazon" {
  count = var.enable_cognito_custom_domain ? 0 : 1

  domain       = "${var.application_name}-${random_string.cognito_amazon_domain_suffix[0].id}"
  user_pool_id = aws_cognito_user_pool.main.id

}


resource "aws_cognito_identity_provider" "azure" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "AzureAD"
  provider_type = "SAML"
  provider_details = {
    MetadataURL           = var.saml_metadata_url
    SSORedirectBindingURI = var.saml_redirect_uri
    SLORedirectBindingURI = var.saml_redirect_uri
  }

  attribute_mapping = {
    "email"       = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    "name"        = "http://schemas.microsoft.com/identity/claims/displayname"
    "given_name"  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    "family_name" = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
    "custom:role" = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
  }
}
