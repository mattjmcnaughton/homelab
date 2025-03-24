# Tailscale Homelab Terraform Module

This Terraform module manages Tailscale configuration for a homelab environment, focusing on ACLs and authentication management for a K3s cluster.

## Features

- **Dynamic Auth Keys**: Creates customizable auth keys for different nodes
- **AWS Secrets Integration**: Stores generated auth keys in AWS Secrets Manager
- **ACL Management**: Configures secure access controls and tag ownership

## Usage

```hcl
module "tailscale_homelab" {
  source = "./modules/tailscale-homelab"

  # Dynamic auth key configuration
  auth_key_nodes = [
    {
      name        = "k3s-master"
      description = "K3s master node"
      reusable    = false
      ephemeral   = false
      expiry      = 86400 * 30  # 30 days
      tags        = ["tag:homelab-auto-provision", "tag:k3s-master"]
    },
    {
      name        = "k3s-worker-1"
      description = "K3s worker node 1"
      reusable    = false
      ephemeral   = false
      expiry      = 86400 * 30  # 30 days
      tags        = ["tag:homelab-auto-provision", "tag:k3s-worker"]
    }
  ]

  # AWS Secrets Manager configuration
  store_keys_in_secrets_manager = true
  secrets_prefix                = "homelab/tailscale"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| tailscale | ~> 0.13.7 |
| aws | ~> 5.0 |

## Important Notes

- **Provider Configuration**: This module assumes that the Tailscale provider is configured externally.
- **Secret Format**: Auth keys are stored in AWS Secrets Manager with the format: `{"ts_auth_key": "tskey-..."}`
- **Secret Naming**: Keys are stored under `homelab/tailscale/${node_name}` by default.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auth_key_nodes | List of nodes to create auth keys for | `list(object)` | `[]` | no |
| store_keys_in_secrets_manager | Whether to store keys in AWS Secrets Manager | `bool` | `true` | no |
| secrets_prefix | Prefix for stored secrets in AWS Secrets Manager | `string` | `"homelab/tailscale"` | no |

## Outputs

| Name | Description |
|------|-------------|
| auth_keys | Map of generated auth keys (sensitive) |
| secret_arns | ARNs of created secrets in AWS Secrets Manager |


## Node Configuration

Each node in the `auth_key_nodes` list should have the following properties:

- `name`: Unique identifier for the node (used in secret naming)
- `description`: Human-readable description
- `reusable`: Whether the auth key can be used multiple times
- `ephemeral`: Whether devices using this key will be ephemeral
- `expiry`: Expiry time in seconds
- `tags`: List of Tailscale tags to apply to devices using this key
