variable "auth_key_nodes" {
  description = "List of nodes to create auth keys for"
  type = list(object({
    name        = string
    description = string
    reusable    = bool
    ephemeral   = bool
    expiry      = number
    tags        = list(string)
  }))
  default = []
}

variable "store_keys_in_secrets_manager" {
  description = "Whether to store generated auth keys in AWS Secrets Manager"
  type        = bool
  default     = true
}

variable "secrets_prefix" {
  description = "Prefix for stored secrets in AWS Secrets Manager"
  type        = string
  default     = "homelab/tailscale"
}
