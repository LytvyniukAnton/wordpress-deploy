resource "aws_instance" "nginx_server" {
  ami           = "ami-0c4f7023847b90238"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.nginx_security_group.name]

  tags = {
    Name = "Nginx-EC2-Instance"
  }
}

#resource "aws_instance" "plesk" {
#  ami           = "ami-094ed3e17f1eb2b3f"
#  instance_type = var.instance_type
#  key_name      = var.key_name
#  security_groups = [aws_security_group.nginx_security_group.name]
#
#  tags = {
#    Name = "Plesk-Server"
#  }
#}