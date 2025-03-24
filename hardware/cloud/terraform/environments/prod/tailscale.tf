# We also enable HTTPS certificates. Currently, this is not possible to manage
# via Terraform, and must be done via the UI.

module "tailscale" {
  source = "../../modules/tailscale"

  auth_key_nodes = [
    {
      name        = "ec2-open-webui"
      description = "Open Webui on EC2"
      reusable    = true
      ephemeral   = false
      expiry      = 86400 * 30 # 30 days
      tags        = ["tag:homelab-auto-provision"]
    }
  ]
}
