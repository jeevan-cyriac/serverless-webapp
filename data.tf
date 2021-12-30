data "aws_rds_cluster" "cs_portal" {
  cluster_identifier = var.rds_cluster_name
}

data "aws_secretsmanager_secret" "dbpass" {
  name = "/finops/rds/${var.rds_cluster_name}/db_password"
}

data "aws_secretsmanager_secret_version" "dbpass" {
  secret_id = data.aws_secretsmanager_secret.dbpass.id
}
