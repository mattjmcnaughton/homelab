# tailscale

We use `tailscale` to create a flat, private mesh network.

Currently, we have two different `tailscale` "use-cases": exposing physical
compute nodes and accessing containerized services.

## Physical Compute Nodes

For this approach, we use Terraform to provision a new tailscale_key. See
`prod/tailscale.tf` for an example. This key will be stored in AWS Secrets
Manager. For EC2 instances, we set up the IAM permissions for them to access
this key and auth during boot. For on-prem devices, we are still finalizing our
strategy. I think the easiest option will be duplicating the auth key into a
"homelab" specific Bitwarden account, and then using bitwarden-cli on the target
on-prem machine. TBD the exact plan.

If not already disabled, we need to remember to disable the `Node Key Expiry`,
so that these nodes stay auth'd to the tailnet.

## Containerized Services

For containerized services, we run a tailscale sidecar container.

We will provision a Tailscale Oauth client, with the permissions to create
Tailscale Keys for `tag:homelab-auto-provision`.

We will store that oauth client id/secret on AWS Secrets Manager.

For Docker Compose, we use the oauth client secret to dynamically register the
sidecar container with the appropriate node name, etc.

TBD how this will work on our k3s k8s cluster. We will need to explore the
tailscale provider. It'll likely make similar usage of Oauth.
