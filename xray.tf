resource "aws_xray_group" "main" {
  group_name        = var.application_name
  filter_expression = "annotation.application_name = \"${var.application_name}\""
}