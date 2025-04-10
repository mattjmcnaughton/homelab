terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.18.0"
    }
  }
}
