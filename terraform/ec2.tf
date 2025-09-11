resource "aws_instance" "nginx_server" {
  ami           = "ami-0bbdd8c17ed981ef9"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.nginx_security_group.name]

  tags = {
    Name = "Nginx-EC2-Instance"
  }
}
