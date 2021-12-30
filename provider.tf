provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = local.pipeline_role_main_arn
  }
}

provider "aws" {
  alias  = "cst"
  region = "us-east-1"
  assume_role {
    role_arn = local.pipeline_role_cst_arn
  }
}


terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.25.0"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = ">= 1.9.0"
    }
  }
  backend "s3" {
    bucket         = "example-terraform-remote-state"
    region         = "us-east-1"
    dynamodb_table = "terraform_statelock"
  }
}


# provider mysql
provider "mysql" {
  endpoint = data.aws_rds_cluster.cs_portal.endpoint
  username = data.aws_rds_cluster.cs_portal.master_username
  password = data.aws_secretsmanager_secret_version.dbpass.secret_string
}
# provider mysql END
