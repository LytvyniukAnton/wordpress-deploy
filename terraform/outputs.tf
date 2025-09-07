output "nginx_public_ip" {
  description = "The public IP address of the Nginx server."
  value       = aws_instance.nginx_server.public_ip # Assuming 'aws_instance.nginx_server' is your Nginx EC2 instance
}

output "nginx_security_group_id" {
  description = "The ID of the security group associated with the Nginx server."
  value       = aws_security_group.nginx_security_group.id # Assuming 'aws_security_group.nginx_sg' is your Nginx security group
}

output "aws_instance_public_dns" {
  description = "The public DNS name of the Nginx server."
  value       = aws_instance.nginx_server.public_dns
}