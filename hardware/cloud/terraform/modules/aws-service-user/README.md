# AWS Service User Terraform Module

This Terraform module creates an IAM service user with custom permissions, optional access keys, and cost monitoring with email notifications.

## Features

- Creates an IAM user with fully customizable permissions via IAM policy
- Generates access keys and securely stores them in AWS Secrets Manager (optional)
- Sets up CloudWatch alarms to monitor AWS account costs
- Sends cost alert emails via Amazon SNS

## Usage Example

```hcl
module "bedrock_service_user" {
  source = "path/to/this/module"

  user_name = "bedrock-api-user"

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
  notification_email = "alerts@example.com"
  cost_threshold     = 50

  tags = {
    Project     = "AI-Platform"
    Environment = "Development"
    Service     = "Bedrock"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| user_name | Name of the IAM service user | `string` | n/a | yes |
| user_path | Path for the IAM user | `string` | `"/"` | no |
| policy_json | Complete IAM policy document in JSON format | `string` | n/a | yes |
| create_access_key | Whether to create an access key for the user | `bool` | `true` | no |
| store_credentials_in_secrets_manager | Whether to store the access key in AWS Secrets Manager | `bool` | `true` | no |
| create_cost_alarm | Whether to create a CloudWatch alarm for cost monitoring | `bool` | `true` | no |
| cost_threshold | Cost threshold in USD that triggers the cost alarm | `number` | `100` | no |
| notification_email | Email address to send cost alarm notifications to | `string` | `""` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_user_name | Name of the IAM user created |
| iam_user_arn | ARN of the IAM user |
| iam_policy_arn | ARN of the IAM policy created for the user |
| access_key_id | Access key ID (only if create_access_key is true) |
| secret_access_key | Secret access key (only if create_access_key is true) |
| secrets_manager_secret_name | Name of the Secrets Manager secret containing credentials (if enabled) |
| secrets_manager_secret_arn | ARN of the Secrets Manager secret containing credentials (if enabled) |
| cost_alarm_arn | ARN of the cost alarm (if created) |
| sns_topic_arn | ARN of the SNS topic for cost notifications (if notification_email is provided) |

## Important Notes

1. **Billing Alarm Region**: The module creates billing alarms in the us-east-1 region as required by AWS.

2. **Email Confirmation**: When providing a notification_email, the recipient will receive a confirmation email from AWS SNS and must confirm the subscription to receive alerts.

3. **Access Keys**: Best practice is to rotate access keys regularly.

4. **Secrets Manager**: Credentials stored in Secrets Manager incur a small monthly cost.
