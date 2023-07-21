output "public_ip" {
  value       = aws_instance.IAC-ec2-Standalone.public_ip
  description = "The public IP address of the web server"
}

output "private_ip" {
  value       = aws_instance.IAC-ec2-Standalone.private_ip
  description = "The public IP address of the web server"
}