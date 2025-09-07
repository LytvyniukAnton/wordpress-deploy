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
  default     = "t3.micro" # free tier
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH"
  type        = string
}

data "aws_vpc" "default" {
  default = true
}