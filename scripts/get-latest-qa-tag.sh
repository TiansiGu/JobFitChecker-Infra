#!/bin/bash
set -e

REPO_NAME="$1"
REGION="$2"
ACCOUNT_ID="$3"

if [ -z "$REPO_NAME" ] || [ -z "$REGION" ] || [ -z "$ACCOUNT_ID" ]; then
  echo "Usage: $0 <repository-name> <aws-region> <aws-account-id>"
  exit 1
fi

# Fetch tags matching vX.Y.Z-qa
TAGS=$(aws ecr describe-images \
  --repository-name "$REPO_NAME" \
  --region "$REGION" \
  --query 'imageDetails[].imageTags[]' \
  --output text | tr '\t' '\n' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+-qa$' || true)

if [ -z "$TAGS" ]; then
  LATEST_TAG="v1.0.0-qa"
else
  MAX_TAG=$(echo "$TAGS" | sed 's/-qa$//' | sort -V | tail -n 1)
  IFS='.' read -r MAJOR MINOR PATCH <<< "${MAX_TAG#v}"
  LATEST_TAG="v$MAJOR.$MINOR.$PATCH-qa"
fi

echo "$LATEST_TAG"
