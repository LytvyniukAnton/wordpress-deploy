resource "aws_security_group" "nginx_security_group" {
  name = "nginx-sg"
  description = "Security group for Nginx web server"
  vpc_id      = data.aws_vpc.default.id #aws_vpc.main_vpc.id // Replace with your VPC ID or reference

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
    description = "Allow HTTPS traffic"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = var.allowed_ips
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  ingress {
    from_port   = 8443 # Port for access to Plesk
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    from_port   = 8447 # Port fot access to admin-panel
    to_port     = 8447
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
  

  tags = {
    Name = "Nginx-Security-Group"
  }
}