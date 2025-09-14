data "aws_security_group" "nginx" {
  count = 1
  filter {
    name   = "group-name"
    values = ["nginx-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "nginx_security_group" {
  count       = local.existing_sg_id == null ? 1 : 0
  name        = "nginx-sg"
  description = "Security group for Nginx web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips_list
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips_list
    description = "Allow HTTPS traffic"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips_list
    description = "Allow HTTPS traffic"
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips_list
  }

  ingress {
    from_port   = 8889
    to_port     = 8889
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Nginx-Security-Group"
  }
}
