resource "aws_instance" "plesk" {
  ami           = "ami-094ed3e17f1eb2b3f"
  instance_type = "t3.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "Plesk-Server"
  }
}