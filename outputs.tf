output "domain_identity_arn" {
  value       = try(aws_sesv2_email_identity.domain[0].arn, null)
  description = "ARN of the SES domain identity."
}

output "dkim_tokens" {
  value       = try(aws_sesv2_email_identity.domain[0].dkim_signing_attributes[0].tokens, [])
  description = "DKIM tokens to publish as CNAME DNS records (also serve as domain verification)."
}

output "mail_from_domain" {
  value       = try(aws_sesv2_email_identity_mail_from_attributes.mail_from[0].mail_from_domain, null)
  description = "The MAIL FROM domain used for bounce handling."
}

output "email_identity_arn" {
  value       = try(aws_sesv2_email_identity.email[0].arn, null)
  description = "ARN of the SES email identity."
}

output "configuration_set_name" {
  value       = try(aws_sesv2_configuration_set.config[0].configuration_set_name, null)
  description = "Name of the SES configuration set (null if enable_notifications is false)."
}

output "notifications_topic_arn" {
  value       = try(aws_sns_topic.notifications[0].arn, null)
  description = "ARN of the SNS topic for bounce and complaint notifications (null if enable_notifications is false)."
}
