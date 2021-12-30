resource "aws_wafv2_web_acl" "main" {
  name        = var.application_name
  description = var.description
  scope       = "CLOUDFRONT"

  default_action {
    block {
      custom_response {
        response_code = "403"

        # As of Aug 2021, Terraform does not support Custom Response Body, therefore response header is used
        # https://github.com/hashicorp/terraform-provider-aws/pull/19764
        # Once this feature request is merged, we should swap response header with response html body
        response_header {
          name  = "x-waf-response"
          value = "You need to be inside example VPN to access this website"
        }
      }
    }
  }

  rule {
    name     = local.waf_rule_example_vpn
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.main.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = local.waf_rule_example_vpn
      sampled_requests_enabled   = false
    }
  }

  tags = local.default_tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.application_name
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "main" {
  name               = local.waf_rule_example_vpn
  description        = local.waf_rule_example_vpn # TODO: add a better description
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.whitelisted_cidr_list

  tags = local.default_tags

}