resource "aws_dynamodb_table" "rbac_roles" {
  name           = local.rbac_roles_datastore_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "role"

  attribute {
    name = "role"
    type = "S"
  }

  tags = local.default_tags
}

resource "aws_dynamodb_table" "rbac_perms" {
  name           = local.rbac_perms_datastore_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "permission"

  attribute {
    name = "permission"
    type = "S"
  }

  tags = local.default_tags
}
