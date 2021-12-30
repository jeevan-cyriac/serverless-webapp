variable "application_name" {
  type        = string
  default     = "cs-portal"
  description = "Name of application"
}

variable "description" {
  type        = string
  default     = "Cloud Services Portal"
  description = "Description of the application to add on the AWS resources"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "airbrake_api_key" {
  type        = string
  default     = "1405b7050ef3c564eabe0f89e38f9262"
  description = "Airbrake API key for the airbrake project"
}

variable "airbrake_project_id" {
  type        = string
  default     = "359718"
  description = "Airbrake Project id for the airbrake project"
}

# TODO - decide how the key gets created
variable "api_key_secret_prefix" {
  type        = string
  default     = "api_gateway/cs-portal/"
  description = "Prefix of the secret name. This is used for storing the API key in AWS Secrets Manager"
}

variable "domain" {
  type        = string
  description = "The R53 sub-domain hosted zone"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID to deploy the cs-portal application"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region the application is deployed to"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the resoures will be deployed"
}

variable "create_lambda_security_group" {
  type        = bool
  default     = false
  description = "Flag to trigger the creation of the SG used by the Lambdas"
}

variable "whitelisted_cidr_list" {
  type = list(any)
  default = [
    "54.221.249.108/32", #CST GitHub Actions Runner for running the pytests
    "125.18.117.2/32",   #Bangalore
    "14.143.245.190/32", #Bangalore
    "203.21.7.0/24",     #Bangalore
    # "98.110.179.31/24",   #Boxborough-MA-CE  => not valid CIDR from AWS WAF pov
    # "98.110.179.1/24",    #Boxborough-MA-PE  => not valid CIDR from AWS WAF pov
    "212.221.11.136/29",  #Chandlers-Ford
    "213.104.147.136/30", #Chandlers-Ford
    "208.116.162.176/29", #Costa-Mesa
    "208.116.166.96/29",  #Costa-Mesa
    "64.58.173.0/24",     #Costa-Mesa
    "45.149.66.0/23",     #Datum
    "91.212.94.0/24",     #Datum
    # "69.174.127.201/30",  #Hong-Kong  => not valid CIDR from AWS WAF pov
    # "98.124.135.214/29",  #Hong-Kong  => not valid CIDR from AWS WAF pov
    "192.118.32.0/22",   #Jerusalem
    "212.222.124.16/29", #Kortrijk
    "45.149.64.0/23",    #Kortrijk
    # "81.188.161.9/29",    #Kortrijk => not valid CIDR from AWS WAF pov
    "208.116.159.224/30", #Lawrenceville
    "208.116.174.24/29",  #Lawrenceville
    "23.129.240.0/24",    #Lawrenceville
    "208.116.212.240/30", #London-Ontario
    "77.77.173.240/29",   #Maidenhead
    "95.152.246.184/29",  #Maidenhead
    "103.139.39.0/24",    #Singapore
    "98.124.138.80/29",   #Singapore
    "98.124.138.88/29",   #Singapore
    "212.221.11.56/29",   #Staines
    "217.137.161.80/29",  #Staines
    "86.53.14.120/29",    #Staines
    "208.116.162.160/29", #Toronto
    "208.116.162.168/29", #Toronto
    "23.134.240.0/24"     #Toronto
  ]
  description = "A CIDR IPs list used by the AWS AWS WAF and by the Custom lambda authorizer"
}

variable "parent_zone_id" {
  type        = string
  description = "Zone ID of the root hosted zone in CST"
}

variable "cst_account_id" {
  type        = string
  description = "Remote CST account ID where the R53 hosted zone will be created"
}

variable "rds_cluster_name" {
  type        = string
  default     = "cloudservices"
  description = "Name of AWS RDS Cluster to connect to"
}

variable "rds_db_operational" {
  type        = string
  default     = "cloud_services"
  description = "Name of operational RDS logical database"
}

variable "rds_db_reporting" {
  type        = string
  default     = "reporting"
  description = "Name of reporting RDS logical database"
}

variable "rds_table_compl_waiver_reqs" {
  type        = string
  default     = "compliance_waiver_request"
  description = "Name of compliance waiver request RDS table"
}

variable "rds_table_compl_waiver_reqs_history" {
  type        = string
  default     = "compliance_waiver_request_history"
  description = "Name of compliance waiver request history RDS table"
}

variable "rds_table_cc_history" {
  type        = string
  default     = "cloud_custodian_history"
  description = "Name of cloud custodian history RDS table"
}

variable "rds_table_cc_nc_resources" {
  type        = string
  default     = "cloud_custodian_nc_resources"
  description = "Name of cloud custodian non-compliant resources RDS table"
}

variable "rds_view_compl_waiver_reqs" {
  type        = string
  default     = "compliance_waiver_request_view"
  description = "Name of compliance waiver request RDS view"
}

variable "rds_view_nc_resources" {
  type        = string
  default     = "nc_resources_view"
  description = "Name of non-compliant resources RDS view"
}

variable "rds_view_aws_cam" {
  type        = string
  default     = "aws_cam_view"
  description = "Name of aws cam RDS view"
}

variable "rds_view_cloud_accounts" {
  type        = string
  default     = "cloud_accounts_view"
  description = "Name of cloud accounts RDS view"
}

variable "rds_view_users" {
  type        = string
  default     = "users_view"
  description = "Name of active users RDS view"
}

variable "rds_view_compliance_waiver_history" {
  type        = string
  default     = "compliance_waiver_history_view"
  description = "Name of compliance waiver history RDS view"
}

variable "rds_view_nc_policies" {
  type        = string
  default     = "nc_policies_view"
  description = "Name of non-compliant policies RDS view"
}

variable "rds_view_cs_portal_home" {
  type        = string
  default     = "cs_portal_home_view"
  description = "Name of cloud services portal home RDS view"
}

variable "rds_view_active_compliance_waivered" {
  type        = string
  default     = "active_compliance_waivered_view"
  description = "Name of active compliance waivered RDS view"
}

variable "saml_metadata_url" {
  type        = string
  default     = "https://login.microsoftonline.com/ecdd899a-33be-4c33-91e4-1f1144fc2f56/federationmetadata/2007-06/federationmetadata.xml?appid=babe0827-f141-40d6-a8c5-876e4a76d121"
  description = "SAML metadata URL for Cognito to enable SSO"
}

variable "saml_redirect_uri" {
  type        = string
  default     = "https://login.microsoftonline.com/ecdd899a-33be-4c33-91e4-1f1144fc2f56/saml2"
  description = "SAML redirect URI for Cognito to enable SSO"

}

# custom domain can be disabled in dev envs since AWS has a max limit on number of custom domains
variable "enable_cognito_custom_domain" {
  type        = bool
  default     = true
  description = "Toggle to create custom domain for Cognito Userpool"
}

# This var could be used in dev env to set cache as 1 second for testing the authorizer
variable "api_gw_authorizer_cache_ttl" {
  type        = number
  default     = 0
  description = "API Gateway Authorizer Cache TTL in seconds"
}

# This var could be used in dev env to allow localhost:3000
variable "api_gw_additional_cors_origins" {
  type        = list(string)
  default     = []
  description = "List of additional CORS origins for API Gateway"
}

# This var could be used in dev env to allow localhost:3000
variable "cognito_additional_callback_urls" {
  type        = list(string)
  default     = []
  description = "List of additional callback URLs for Cognito appclient"
}

# This var could be used in dev env to allow localhost:3000
variable "cognito_additional_logout_urls" {
  type        = list(string)
  default     = []
  description = "List of additional logout URLs for Cognito appclient"
}

variable "lambda_log_level" {
  type        = string
  default     = "DEBUG"
  description = "The log level of Lambda functions"
}

variable "additional_layers" {
  type = list(string)
  default = [
    "arn:aws:lambda:us-east-1:017000801446:layer:AWSLambdaPowertoolsPython:3"
  ]
  description = "List of Lambda Layer Version ARNs (maximum of 3) to attach to your Lambda Function."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Map of default tags for all resources"
}
