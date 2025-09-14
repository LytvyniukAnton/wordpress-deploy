variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ips" {
  description = "Allowed IPs for HTTP/HTTPS"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small" # free tier
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

data "aws_vpc" "default" {
  default = true
}

variable "use_existing_sg" {
  description = "Use existing Nginx Security Group if true"
  type        = bool
  default     = false
}

variable "existing_sg_id" {
  description = "ID of existing Nginx Security Group (if any)"
  type        = string
  default     = ""
}
