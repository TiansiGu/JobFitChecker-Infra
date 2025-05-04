output "sqs_queue_url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.put_resume_sqs.id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.resume_bucket.bucket
}
