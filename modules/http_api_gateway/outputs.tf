output "api_gw_fqdn" {
  value = var.api_gw_domain
}

output "api_gw_domain_name" {
  value = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].target_domain_name
}

output "api_gw_domain_zone_id" {
  value = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].hosted_zone_id
}
