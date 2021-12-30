variable "name" {}
variable "description" {}
variable "cors_origins" {}
variable "custom_authorizer_lambda_arn" {}
variable "custom_authorizer_lambda_invoke_arn" {}
variable "api_gw_domain" {}
variable "acm_certificate_arn" {}
variable "api_endpoints" {}
variable "tags" {}

variable "authorizer_cache_ttl" {
  type        = number
  default     = 300
  description = "Authorizer Cache TTL in seconds"
}