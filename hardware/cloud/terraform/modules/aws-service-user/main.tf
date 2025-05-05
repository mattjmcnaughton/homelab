# Create IAM user
resource "aws_iam_user" "service_user" {
  name = var.user_name
  path = var.user_path
  tags = var.tags
}

# Create IAM policy using the provided policy JSON
resource "aws_iam_policy" "service_user_policy" {
  name        = "${var.user_name}-policy"
  description = "Policy for service user ${var.user_name}"
  policy      = var.policy_json
  tags        = var.tags
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "service_user_policy_attachment" {
  user       = aws_iam_user.service_user.name
  policy_arn = aws_iam_policy.service_user_policy.arn
}

# Create access key for the user if enabled
resource "aws_iam_access_key" "service_user_key" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.service_user.name
}

# Store access key in Secrets Manager if enabled
resource "aws_secretsmanager_secret" "service_user_credentials" {
  count       = var.create_access_key && var.store_credentials_in_secrets_manager ? 1 : 0
  name        = "${var.secrets_manager_path_prefix}/${var.user_name}"
  description = "Access credentials for service user ${var.user_name}"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "service_user_credentials_version" {
  count     = var.create_access_key && var.store_credentials_in_secrets_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.service_user_credentials[0].id
  secret_string = jsonencode({
    username              = aws_iam_user.service_user.name
    aws_access_key_id     = aws_iam_access_key.service_user_key[0].id
    aws_secret_access_key = aws_iam_access_key.service_user_key[0].secret
    creation_date         = timestamp()
  })
}

# Create SNS topic for cost alerts if notification email is provided
resource "aws_sns_topic" "cost_alerts" {
  count = var.create_cost_alarm && var.notification_email != "" ? 1 : 0
  name  = "${var.user_name}-cost-alerts"
  tags  = var.tags
}

# Subscribe the provided email to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.create_cost_alarm && var.notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.cost_alerts[0].arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Create CloudWatch alarm for cost monitoring
resource "aws_cloudwatch_metric_alarm" "cost_alarm" {
  count               = var.create_cost_alarm ? 1 : 0
  alarm_name          = "${var.user_name}-cost-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 86400 # 24 hours
  statistic           = "Maximum"
  threshold           = var.cost_threshold
  alarm_description   = "This alarm triggers when the estimated charges for ${var.user_name} exceed ${var.cost_threshold}"

  # Use the created SNS topic if email provided, otherwise use the provided alarm_actions
  alarm_actions = var.notification_email != "" ? [aws_sns_topic.cost_alerts[0].arn] : []

  dimensions = {
    LinkedAccount = data.aws_caller_identity.current.account_id
    Currency      = "USD"
  }

  tags = var.tags
}

# Get current account ID for CloudWatch Alarm
data "aws_caller_identity" "current" {}
