module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  domain_name = local.hosted_zone_name
  zone_id     = aws_route53_zone.cs_portal.id

  subject_alternative_names = ["*.${local.hosted_zone_name}"]

  tags = local.default_tags

  depends_on = [aws_route53_record.cs_portal_nameservers]
}
