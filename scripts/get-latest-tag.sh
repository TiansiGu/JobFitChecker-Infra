#!/bin/bash
set -e

REPO_NAME="$1"
REGION="$2"
ACCOUNT_ID="$3"
STAGE="$4"

if [ -z "$REPO_NAME" ] || [ -z "$REGION" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$STAGE" ]; then
  echo "Usage: $0 <repository-name> <aws-region> <aws-account-id> <stage>"
  exit 1
fi

# Fetch tags matching vX.Y.Z-STAGE, like v1.0.0-qa
TAGS=$(aws ecr describe-images \
  --repository-name "$REPO_NAME" \
  --region "$REGION" \
  --query 'imageDetails[].imageTags[]' \
  --output text | tr '\t' '\n' | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+-${STAGE}$" || true)

if [ -z "$TAGS" ]; then
  LATEST_TAG="none"
else
  LATEST_TAG=$(echo "$TAGS" | sed "s/-${STAGE}$//" | sort -V | tail -n 1)
fi

echo "$LATEST_TAG"
