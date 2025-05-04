#############################
# SQS Queue
#############################
resource "aws_sqs_queue" "put_resume_sqs" {
  name                      = "putResumeSQS-uat"
  message_retention_seconds = 345600  # 4 days
  visibility_timeout_seconds = 30     # 30 seconds
}

#############################
# SQS Policy: Allow S3 to Send Messages
#############################
data "aws_iam_policy_document" "sqs_policy" {
  statement {
    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [aws_sqs_queue.put_resume_sqs.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.resume_bucket.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.put_resume_sqs.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

#############################
# S3 Bucket
#############################

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "uat-resume-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

#############################
# S3 Notification to SQS
#############################
resource "aws_s3_bucket_notification" "resume_events" {
  bucket = aws_s3_bucket.resume_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.put_resume_sqs.arn
    events        = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.allow_s3]
}
