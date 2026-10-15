locals {
  create_domain_identity = var.domain_identity != null
  create_email_identity  = var.email_identity != null
  mail_from_domain = (
    var.mail_from_domain != null ? var.mail_from_domain :
    local.create_domain_identity ? "bounce.${var.domain_identity}" : null
  )
}

resource "aws_sesv2_email_identity" "domain" {
  count          = local.create_domain_identity ? 1 : 0
  email_identity = var.domain_identity

  dynamic "dkim_signing_attributes" {
    for_each = var.enable_dkim ? [1] : []
    content {
      next_signing_key_length = var.dkim_signing_key_length
    }
  }

  tags = var.tags
}

resource "aws_sesv2_email_identity" "email" {
  count          = local.create_email_identity ? 1 : 0
  email_identity = var.email_identity
  tags           = var.tags
}

resource "aws_sesv2_email_identity_mail_from_attributes" "mail_from" {
  count                  = local.create_domain_identity ? 1 : 0
  email_identity         = aws_sesv2_email_identity.domain[0].email_identity
  mail_from_domain       = local.mail_from_domain
  behavior_on_mx_failure = var.behavior_on_mx_failure
}

resource "aws_sesv2_configuration_set" "config" {
  count                  = var.enable_notifications ? 1 : 0
  configuration_set_name = local.create_domain_identity ? "${replace(var.domain_identity, ".", "-")}-config" : "ses-config"
  tags                   = var.tags
}

resource "aws_sns_topic" "notifications" {
  count = var.enable_notifications ? 1 : 0
  name  = local.create_domain_identity ? "${replace(var.domain_identity, ".", "-")}-ses-notifications" : "ses-notifications"
  tags  = var.tags
}

resource "aws_sesv2_configuration_set_event_destination" "notifications" {
  count                  = var.enable_notifications ? 1 : 0
  configuration_set_name = aws_sesv2_configuration_set.config[0].configuration_set_name
  event_destination_name = "sns-bounce-complaint"

  event_destination {
    sns_destination {
      topic_arn = aws_sns_topic.notifications[0].arn
    }
    matching_event_types = ["BOUNCE", "COMPLAINT"]
    enabled              = true
  }
}
