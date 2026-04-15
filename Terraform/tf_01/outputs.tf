output "instance_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.app.public_ip
}

output "frontend_url" {
  description = "The URL to access the Express frontend"
  value       = "http://${aws_instance.app.public_ip}:3000"
}

output "backend_url" {
  description = "The URL to access the Flask backend"
  value       = "http://${aws_instance.app.public_ip}:5000"
}