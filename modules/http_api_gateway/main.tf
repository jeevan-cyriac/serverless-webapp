resource "aws_apigatewayv2_api" "main" {
  name          = var.name
  description   = var.description
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = true
    allow_headers     = ["access-control-allow-origin", "authorization", "content-type"]
    allow_methods     = ["GET", "POST", "PUT"]
    allow_origins     = var.cors_origins
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigateway.arn
    format = jsonencode({
      "requestId"        = "$context.requestId",
      "ip"               = "$context.identity.sourceIp",
      "requestTime"      = "$context.requestTime"
      "httpMethod"       = "$context.httpMethod",
      "routeKey"         = "$context.routeKey",
      "status"           = "$context.status",
      "protocol"         = "$context.protocol",
      "responseLength"   = "$context.responseLength",
      "integrationError" = "$context.integrationErrorMessage"
      "authorizerOutput" = "$context.authorizer.message"
      "apiError"         = "$context.error.message"
    })
  }
  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.main.id
  stage       = aws_apigatewayv2_stage.main.id
}

resource "aws_apigatewayv2_integration" "main" {
  for_each = var.api_endpoints

  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  description            = var.description
  integration_method     = "POST"
  integration_uri        = each.value
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "main" {
  for_each = var.api_endpoints

  api_id    = aws_apigatewayv2_api.main.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.main[each.key].id}"

  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.custom_lambda_authorizer.id
}

#############################
# Logging
#############################
resource "aws_cloudwatch_log_group" "apigateway" {
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = 30

  tags = var.tags
}

#############################
# AWS API Gateway Authorizer
#############################
resource "aws_apigatewayv2_authorizer" "custom_lambda_authorizer" {
  api_id           = aws_apigatewayv2_api.main.id
  authorizer_type  = "REQUEST"
  identity_sources = ["$request.header.Authorization"]
  authorizer_uri   = var.custom_authorizer_lambda_invoke_arn
  name             = "lambda-custom-authorizer"

  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = "true"

  authorizer_result_ttl_in_seconds = var.authorizer_cache_ttl
}

#############################
# Domain
#############################
resource "aws_apigatewayv2_domain_name" "main" {
  domain_name = var.api_gw_domain
  domain_name_configuration {
    certificate_arn = var.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

#############################
# Permissions to invoke lambdas
#############################
resource "aws_lambda_permission" "api_gw_invoke_lambda" {
  for_each = var.api_endpoints

  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*${split(" ", each.key)[1]}"
}

resource "aws_lambda_permission" "custom_lambda_authorizer_invoke" {
  action        = "lambda:InvokeFunction"
  function_name = var.custom_authorizer_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.custom_lambda_authorizer.id}"
}
