output "plesk_public_ip" {
  description = "The public IP address of the Plesk server."
  value       = aws_instance.plesk.public_ip
}