resource "aws_instance" "plesk" {
  ami           = "ami-094ed3e17f1eb2b3f"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.nginx_security_group.name]

  tags = {
    Name = "Plesk-Server"
  }
}