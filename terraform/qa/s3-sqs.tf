provider "aws" {
  alias  = "east"
  region = "us-east-2"
}

#############################
# SQS Queue
#############################
resource "aws_sqs_queue" "put_resume_sqs" {
  provider = aws.east
  name                      = "putResumeSQS-qa"
  message_retention_seconds = 345600  # 4 days
  visibility_timeout_seconds = 30     # 30 seconds
}

#############################
# SQS Policy: Allow S3 to Send Messages
#############################
data "aws_iam_policy_document" "sqs_policy" {
  provider = aws.east
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

resource "aws_sqs_queue_policy" "allow_s3_qa" {
  provider = aws.east
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
  provider = aws.east
  bucket = "qa-resume-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

#############################
# S3 Notification to SQS
#############################
resource "aws_s3_bucket_notification" "resume_events" {
  provider = aws.east
  bucket = aws_s3_bucket.resume_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.put_resume_sqs.arn
    events        = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.allow_s3_qa]
}
