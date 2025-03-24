locals {
  secret_names = {
    for node_name, _ in module.tailscale.secret_arns :
    node_name => "${module.tailscale.secrets_prefix}/${node_name}"
  }
}

# We deploy open-webui on EC2 because we want to use Amazon Bedrock Access
# Gateway as a sidecar. It's trivial to grant the necessary
# IAM permissions for Bedrock to the EC2 instance.
module "ec2-open-webui" {
  count = 1

  source = "../../modules/ec2-homelab"

  vpc_id      = module.vpc.vpc_id
  alert_email = "auto+aws@mattjmcnaughton.com"

  instance_name = "ec2-open-webui"
  username      = "mattjmcnaughton"

  root_volume_size = 10
  data_volume_size = 20

  secrets_manager_ts_auth_key_name = local.secret_names["ec2-open-webui"]

  instance_type = "t4g.small" # 2 Cpus and 2GB memory - ~$12 per month

  additional_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
  ]

  tags = {
    environment  = "prod"
    status       = "experimental"
    machineclass = "pet"
  }
}
