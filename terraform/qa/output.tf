output "qa_ec2_instance_id" {
  value = aws_instance.ec2[0].id
}

output "qa_ec2_public_ip" {
  value = aws_instance.ec2[0].public_ip
}

output "qa_ec2_private_ip" {
  value = aws_instance.ec2[0].private_ip
}

output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.put_resume_sqs.id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.resume_bucket.bucket
}

output "ec2_key_name" {
  value = aws_instance.ec2[0].key_name
}
