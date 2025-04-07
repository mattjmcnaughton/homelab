locals {
  secret_names = {
    for node_name, _ in module.tailscale.secret_arns :
    node_name => "${module.tailscale.secrets_prefix}/${node_name}"
  }
}
