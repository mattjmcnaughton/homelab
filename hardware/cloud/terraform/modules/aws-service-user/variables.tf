variable "user_name" {
  description = "Name of the IAM service user"
  type        = string
}

variable "user_path" {
  description = "Path for the IAM user"
  type        = string
  default     = "/"
}

variable "secrets_manager_path_prefix" {
  description = "Prefix for Secrets Manager secret"
  type        = string
  default     = "homelab/service-user"
}

variable "policy_json" {
  description = "Complete IAM policy document in JSON format"
  type        = string
}

variable "create_access_key" {
  description = "Whether to create an access key for the user"
  type        = bool
  default     = true
}

variable "store_credentials_in_secrets_manager" {
  description = "Whether to store the access key in AWS Secrets Manager"
  type        = bool
  default     = true
}

variable "create_cost_alarm" {
  description = "Whether to create a CloudWatch alarm for cost monitoring"
  type        = bool
  default     = true
}

variable "cost_threshold" {
  description = "Cost threshold in USD that triggers the cost alarm"
  type        = number
  default     = 50
}

variable "notification_email" {
  description = "Email address to send cost alarm notifications to"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
