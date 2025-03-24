output "secret_arns" {
  description = "ARNs of created secrets in AWS Secrets Manager"
  value       = var.store_keys_in_secrets_manager ? { for name, secret in aws_secretsmanager_secret.auth_key_secrets : name => secret.arn } : {}
}

output "secrets_prefix" {
  description = "Prefix used for secrets in AWS Secrets Manager"
  value       = var.secrets_prefix
}
