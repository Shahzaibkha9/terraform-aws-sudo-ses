locals {
  zone_name      = var.zone_name != null ? var.zone_name : var.domain_identity
  dkim_tokens    = module.ses.dkim_tokens
}

data "aws_route53_zone" "zone" {
  name     = local.zone_name
  provider = aws.route53
}

data "aws_region" "current" {}

module "ses" {
  source                  = "../../"
  domain_identity         = var.domain_identity
  email_identity          = var.email_identity
  enable_dkim             = var.enable_dkim
  dkim_signing_key_length = var.dkim_signing_key_length
  mail_from_domain        = var.mail_from_domain
  behavior_on_mx_failure  = var.behavior_on_mx_failure
  enable_notifications    = var.enable_notifications
  tags                    = var.tags
}

# SESv2 uses DKIM CNAME records for both verification and signing — no separate TXT record needed
resource "aws_route53_record" "dkim" {
  count    = var.enable_dkim ? 3 : 0
  zone_id  = data.aws_route53_zone.zone.zone_id
  name     = "${local.dkim_tokens[count.index]}._domainkey.${var.domain_identity}"
  type     = "CNAME"
  ttl      = 600
  records  = ["${local.dkim_tokens[count.index]}.dkim.amazonses.com"]
  provider = aws.route53
}

resource "aws_route53_record" "mail_from_mx" {
  zone_id  = data.aws_route53_zone.zone.zone_id
  name     = module.ses.mail_from_domain
  type     = "MX"
  ttl      = 600
  records  = ["10 feedback-smtp.${data.aws_region.current.region}.amazonses.com"]
  provider = aws.route53
}

resource "aws_route53_record" "mail_from_spf" {
  zone_id  = data.aws_route53_zone.zone.zone_id
  name     = module.ses.mail_from_domain
  type     = "TXT"
  ttl      = 600
  records  = ["v=spf1 include:amazonses.com -all"]
  provider = aws.route53
}
