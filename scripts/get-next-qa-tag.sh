#!/bin/bash

set -e

REPO_NAME="$1"
REGION="$2"

if [ -z "$REPO_NAME" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <repository-name> <aws-region>"
  exit 1
fi

TAGS=$(aws ecr describe-images \
  --repository-name "$REPO_NAME" \
  --region "$REGION" \
  --query 'imageDetails[].imageTags[]' \
  --output text | tr '\t' '\n' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+-qa$')

if [ -z "$TAGS" ]; then
  NEW_TAG="v1.0.0-qa"
else
  MAX_TAG=$(echo "$TAGS" | sed 's/-qa$//' | sort -V | tail -n 1)
  IFS='.' read -r MAJOR MINOR PATCH <<< "${MAX_TAG#v}"
  PATCH=$((PATCH + 1))
  NEW_TAG="v$MAJOR.$MINOR.$PATCH-qa"
fi

echo "$NEW_TAG"
