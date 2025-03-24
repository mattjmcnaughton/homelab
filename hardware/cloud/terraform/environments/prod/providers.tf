provider "aws" {
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "tailscale_credentials" {
  name = "homelab/api/tailscale-scope-admin-terraform"
}

data "aws_secretsmanager_secret_version" "tailscale_credentials" {
  secret_id = data.aws_secretsmanager_secret.tailscale_credentials.id
}

locals {
  tailscale_credentials = jsondecode(data.aws_secretsmanager_secret_version.tailscale_credentials.secret_string)
}

provider "tailscale" {
  tailnet = local.tailscale_credentials.tailnet

  oauth_client_id     = local.tailscale_credentials.oauth_client_id
  oauth_client_secret = local.tailscale_credentials.oauth_client_secret
}
