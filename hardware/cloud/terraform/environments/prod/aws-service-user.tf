module "litellm_service_user" {
  source = "../../modules/aws-service-user"

  user_name = "litellm-aws"

  # IAM policy with full Bedrock access
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["bedrock:*"]
        Resource = "*"
      }
    ]
  })

  # Email notification for cost alerts
  create_cost_alarm  = true
  notification_email = "homelab@mattjmcnaughton.com"
  cost_threshold     = 50
}
