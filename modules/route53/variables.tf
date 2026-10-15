variable "domain_identity" {
  type        = string
  description = "Domain to register with SES (e.g. example.com)."
}

variable "email_identity" {
  type        = string
  description = "(Optional) Email identity to configure on SES."
  default     = null
}

variable "zone_name" {
  type        = string
  description = "(Optional) Route53 hosted zone name. Defaults to domain_identity if not set."
  default     = null
}

variable "enable_dkim" {
  type        = bool
  description = "(Optional) Enable DKIM signing. Default: true"
  default     = true
}

variable "dkim_signing_key_length" {
  type        = string
  description = "(Optional) DKIM signing key length. RSA_2048_BIT or RSA_1024_BIT. Default: RSA_2048_BIT"
  default     = "RSA_2048_BIT"
  validation {
    condition     = contains(["RSA_2048_BIT", "RSA_1024_BIT"], var.dkim_signing_key_length)
    error_message = "dkim_signing_key_length must be RSA_2048_BIT or RSA_1024_BIT."
  }
}

variable "mail_from_domain" {
  type        = string
  description = "(Optional) Custom MAIL FROM domain. Defaults to bounce.<domain_identity>."
  default     = null
}

variable "behavior_on_mx_failure" {
  type        = string
  description = "(Optional) Behavior when MAIL FROM MX record is not found. USE_DEFAULT_VALUE or REJECT_MESSAGE. Default: USE_DEFAULT_VALUE"
  default     = "USE_DEFAULT_VALUE"
}

variable "enable_notifications" {
  type        = bool
  description = "(Optional) Create an SNS topic and configuration set for bounce and complaint notifications. Default: false"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Map of tags to apply to all resources."
  default     = {}
}
