output "domain_identity_arn" {
  value       = module.ses.domain_identity_arn
  description = "ARN of the SES domain identity."
}

output "dkim_tokens" {
  value       = module.ses.dkim_tokens
  description = "DKIM tokens published as CNAME DNS records."
}

output "mail_from_domain" {
  value       = module.ses.mail_from_domain
  description = "The MAIL FROM domain."
}

output "configuration_set_name" {
  value       = module.ses.configuration_set_name
  description = "Name of the SES configuration set."
}

output "notifications_topic_arn" {
  value       = module.ses.notifications_topic_arn
  description = "ARN of the SNS topic for bounce and complaint notifications."
}
