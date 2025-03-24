variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

variable "key_name" {
  description = "Name of the key pair for SSH access (optional)"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 24.04 (leave null to use the latest official AMI)"
  type        = string
  default     = null
}

variable "enable_cost_alert" {
  description = "Whether to enable the cost budget alert"
  type        = bool
  default     = false
}

variable "enable_runtime_alert" {
  description = "Whether to enable the runtime alert"
  type        = bool
  default     = false
}

variable "alert_email" {
  description = "Email address for receiving alerts"
  type        = string
}

variable "secrets_manager_ts_auth_key_name" {
  description = "Name of the Tailscale auth key in Secrets Manager"
  type        = string
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "max_budget" {
  description = "Maximum monthly budget in USD"
  type        = number
  default     = 20
}

variable "max_runtime_hours" {
  description = "Maximum runtime in hours before alarm triggers"
  type        = number
  default     = 4
}

variable "username" {
  description = "Username for the main user account"
  type        = string
  default     = "ubuntu"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 15
}

variable "data_volume_size" {
  description = "Size of the additional data EBS volume in GB. Set to 0 to disable."
  type        = number
  default     = 0
}

variable "data_volume_mount_point" {
  description = "Mount point for the data volume"
  type        = string
  default     = "/encrypted_fs"
}

variable "data_volume_type" {
  description = "EBS volume type for the data volume"
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "additional_policy_arns" {
  description = "List of IAM policy ARNs to attach to the IAM role"
  type        = set(string)
  default     = []
}

variable "architecture" {
  description = "CPU architecture for the Ubuntu AMI (arm64 or amd64)"
  type        = string
  default     = "arm64"

  validation {
    condition     = contains(["arm64", "amd64"], var.architecture)
    error_message = "Architecture must be either 'arm64' or 'amd64'."
  }
}
