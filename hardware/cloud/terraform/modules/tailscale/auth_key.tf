# Create auth keys dynamically based on the input list
resource "tailscale_tailnet_key" "node_auth_keys" {
  for_each = { for node in var.auth_key_nodes : node.name => node }

  reusable      = each.value.reusable
  ephemeral     = each.value.ephemeral
  preauthorized = true
  expiry        = each.value.expiry
  tags          = each.value.tags
  description   = each.value.description
}

# Store the generated auth keys in AWS Secrets Manager
resource "aws_secretsmanager_secret" "auth_key_secrets" {
  for_each = var.store_keys_in_secrets_manager ? { for node in var.auth_key_nodes : node.name => node } : {}

  name        = "${var.secrets_prefix}/${each.key}"
  description = "Tailscale auth key for ${each.value.description}"
}

resource "aws_secretsmanager_secret_version" "auth_key_secrets" {
  for_each = var.store_keys_in_secrets_manager ? { for node in var.auth_key_nodes : node.name => node } : {}

  secret_id = aws_secretsmanager_secret.auth_key_secrets[each.key].id
  secret_string = jsonencode({
    ts_auth_key = tailscale_tailnet_key.node_auth_keys[each.key].key
  })
}
