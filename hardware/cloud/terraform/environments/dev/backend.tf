terraform {
  backend "s3" {
    bucket         = "g-mattjmcnaughton-homelab-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "g-mattjmcnaughton-homelab-terraform-state-lock"
  }
}
