output "iam_user_name" {
  description = "Name of the IAM user created"
  value       = aws_iam_user.service_user.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.service_user.arn
}

output "iam_policy_arn" {
  description = "ARN of the IAM policy created for the user"
  value       = aws_iam_policy.service_user_policy.arn
}

output "access_key_id" {
  description = "Access key ID (only if create_access_key is true)"
  value       = var.create_access_key ? aws_iam_access_key.service_user_key[0].id : null
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret access key (only if create_access_key is true)"
  value       = var.create_access_key ? aws_iam_access_key.service_user_key[0].secret : null
  sensitive   = true
}

output "secrets_manager_secret_name" {
  description = "Name of the Secrets Manager secret containing credentials (if enabled)"
  value       = var.create_access_key && var.store_credentials_in_secrets_manager ? aws_secretsmanager_secret.service_user_credentials[0].name : null
}

output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret containing credentials (if enabled)"
  value       = var.create_access_key && var.store_credentials_in_secrets_manager ? aws_secretsmanager_secret.service_user_credentials[0].arn : null
}

output "cost_alarm_arn" {
  description = "ARN of the cost alarm (if created)"
  value       = var.create_cost_alarm ? aws_cloudwatch_metric_alarm.cost_alarm[0].arn : null
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for cost notifications (if notification_email is provided)"
  value       = var.create_cost_alarm && var.notification_email != "" ? aws_sns_topic.cost_alerts[0].arn : null
}
