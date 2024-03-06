output "aws_instance_ids" {
  value = [
    aws_instance.heating_instance.id, 
    aws_instance.lighting_instance.id, 
    aws_instance.status_instance.id, 
    aws_instance.auth_instance.id
    ]
}

output "auth_instance_private_ip" {
  value = aws_instance.auth_instance.private_ip
}