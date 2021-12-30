locals {
  # Assume Role ARNs used by pipeline to deploy terraform
  pipeline_role_main_arn = "arn:aws:iam::${var.account_id}:role/ciadmin"
  pipeline_role_cst_arn  = "arn:aws:iam::${var.cst_account_id}:role/ciadmin"

  hosted_zone_name      = "${var.application_name}.${var.domain}" # cs-portal.<env>.cloudservices.example.com
  cdn_domain            = local.hosted_zone_name                  # cs-portal.<env>.cloudservices.example.com
  api_gw_domain         = "api.${local.hosted_zone_name}"         # api.cs-portal.<env>.cloudservices.example.com
  cognito_custom_domain = "auth.${local.hosted_zone_name}"        # auth.cs-portal.<env>.cloudservices.example.com

  # TODO - decide how the key gets created
  # Build the Secret manager arn key used for the custom authorizer
  api_key_secret_arn = "arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:${var.api_key_secret_prefix}*"

  # S3 bucket for storing the web app's static files
  bucket = local.hosted_zone_name

  ### Cognito section
  cognito_logout_urls   = concat(["https://${local.cdn_domain}/Login"], var.cognito_additional_logout_urls)
  cognito_callback_urls = concat(["https://${local.cdn_domain}/cs"], var.cognito_additional_callback_urls)
  ###

  api_gw_cors_origins = concat(["https://${local.cdn_domain}"], var.api_gw_additional_cors_origins)

  ### Cloudfront
  s3_origin_id              = "S3Origin"
  cdn_whilelisted_countries = ["US", "GB", "IL", "IN"]
  ###

  # application_tags are a map of all resources in this application with their tag map
  application_tags = lookup(module.tag_mapping.tag_map, "cs-portal", {})

  # default_tags are used for resources where the 'role' doesn't exist in the tag map for this application
  default_tags = merge(
    lookup(local.application_tags, "default", {}),
    {
      environment      = var.env,             # env (i.e. prod/stage/dev) is not derived from tag-mapping
      application_name = var.application_name # This is to overwrite the application_name with sandbox application name i.e. cs-portal-dev
    },
    var.tags
  )

  # when application_name is cs-portal (i.e. prod or stage),
  #     {} is passed to tf-lambda so that tf-lambda module decides the tags
  # when application_name is not cs-portal (i.e. dev sandboxes),
  #     default_tags is passed to tf-lambda
  lambda_default_tags = var.application_name == "cs-portal" ? {} : local.default_tags

  lambda_default_timeout = "600"
  lambda_default_file    = "lambda"
  lambda_default_memory  = "512"

  lambda_security_group_id   = var.create_lambda_security_group ? aws_security_group.lambda_sg[*].id : null
  lambda_security_group_desc = "Security group for all Lambda part of ${var.application_name}"

  lambda_role_cloud_custodian_waivered = "cloud-custodian-waivered"
  lambda_arn_cloud_custodian_waivered  = "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:${var.application_name}-${local.lambda_role_cloud_custodian_waivered}"

  rbac_roles_datastore_name = "${var.application_name}-rbac-roles"
  rbac_roles_datastore_arn  = "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/${local.rbac_roles_datastore_name}"
  rbac_perms_datastore_name = "${var.application_name}-rbac-permissions"
  rbac_perms_datastore_arn  = "arn:aws:dynamodb:${var.aws_region}:${var.account_id}:table/${local.rbac_perms_datastore_name}"

  waf_rule_example_vpn = "${var.application_name}-example-vpn"
}
