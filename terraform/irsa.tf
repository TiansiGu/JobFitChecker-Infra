data "aws_caller_identity" "current" {}

locals {
  oidc_provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

##########################
# UAT IRSA Role + Policy #
##########################

resource "aws_iam_role" "uat_irsa_role" {
  name = "eks-irsa-uat-s3-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_url}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url}:sub" = "system:serviceaccount:uat:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "uat_irsa_policy" {
  name = "eks-irsa-uat-s3-sqs-policy"
  role = aws_iam_role.uat_irsa_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",         // To fetch the message
          "sqs:DeleteMessage",          // To delete it after processing (very common)
          "sqs:GetQueueAttributes"      // To get queue metadata (used internally by SDK)
        ]
        Resource = "*"
      }
    ]
  })
}

#########################
# GA IRSA Role + Policy #
#########################

resource "aws_iam_role" "ga_irsa_role" {
  name = "eks-irsa-ga-s3-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_url}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url}:sub" = "system:serviceaccount:ga:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ga_irsa_policy" {
  name = "eks-irsa-ga-s3-sqs-policy"
  role = aws_iam_role.ga_irsa_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",         // To fetch the message
          "sqs:DeleteMessage",          // To delete it after processing (very common)
          "sqs:GetQueueAttributes"      // To get queue metadata (used internally by SDK)
        ]
        Resource = "*"
      }
    ]
  })
}