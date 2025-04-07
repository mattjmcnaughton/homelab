# We also enable HTTPS certificates. Currently, this is not possible to manage
# via Terraform, and must be done via the UI.

module "tailscale" {
  source = "../../modules/tailscale"

  auth_key_nodes = []
}
