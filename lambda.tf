##### Create VPC SG  #####
resource "aws_security_group" "lambda_sg" {
  count       = var.create_lambda_security_group ? 1 : 0
  name_prefix = "${var.application_name}-lambdas-sg-"
  description = local.lambda_security_group_desc
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

module "function_cloud_accounts_post" {
  source = "git::https://git@github.com/jeevan-cyriac/tf-lambda.git?ref=v0.6.12"

  application_name = var.application_name
  application_role = "cloud-accounts-post"
  timeout          = local.lambda_default_timeout
  env              = var.env
  lambda_file      = local.lambda_default_file
  package_path     = "${path.module}/functions/cloud_accounts/post"
  memory_size      = local.lambda_default_memory

  vpc_id                 = var.vpc_id
  vpc_security_group_ids = local.lambda_security_group_id

  additional_layers = var.additional_layers

  rds_cluster = var.rds_cluster_name

  enable_tracing = true

  tags = local.lambda_default_tags
}


module "function_cloud_accounts_get" {
  source = "git::https://git@github.com/jeevan-cyriac/tf-lambda.git?ref=v0.6.12"

  application_name = var.application_name
  application_role = "cloud-accounts-get"
  timeout          = local.lambda_default_timeout
  env              = var.env
  lambda_file      = local.lambda_default_file
  package_path     = "${path.module}/functions/cloud_accounts/get"
  memory_size      = local.lambda_default_memory

  vpc_id                 = var.vpc_id
  vpc_security_group_ids = local.lambda_security_group_id

  additional_layers = var.additional_layers

  rds_cluster = var.rds_cluster_name

  enable_tracing = true

  tags = local.lambda_default_tags
}
