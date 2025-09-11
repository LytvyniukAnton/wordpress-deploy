variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ips" {
  description = "Allowed IPs for HTTP/HTTPS"
  type        = list(string)
}

#variable "instance_type" {
#  description = "EC2 instance type"
#  type        = string
#  default     = "t3.micro" # free tier
#}

data "aws_vpc" "default" {
  default = true
}