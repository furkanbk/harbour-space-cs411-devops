output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.my_ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.my_ec2.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.my_ec2_sg.id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.my_ec2_key.key_name
}

output "private_key_pem" {
  description = "Private key for SSH access (sensitive)"
  value       = tls_private_key.my_ec2_key.private_key_pem
  sensitive   = true
}
