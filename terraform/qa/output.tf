output "qa_ec2_instance_id" {
  value = aws_instance.ec2[0].id
}

output "qa_ec2_public_ip" {
  value = aws_instance.ec2[0].public_ip
}

output "qa_ec2_private_ip" {
  value = aws_instance.ec2[0].private_ip
}
