resource "aws_instance" "nginx_server" {
  ami           = "ami-0bbdd8c17ed981ef9"
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    local.existing_sg_id != null ? local.existing_sg_id : aws_security_group.nginx_security_group[0].id
  ]

  tags = {
    Name = "Nginx-EC2-Instance"
  }
}
