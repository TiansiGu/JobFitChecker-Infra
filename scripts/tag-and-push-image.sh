#!/bin/bash

set -e

IMAGE_NAME="$1"         # e.g., frontend
TAG="$2"                # e.g., v1.0.2-qa
ECR_NAMESPACE="$3"      # e.g., job-fit-checker
ACCOUNT_ID="$4"         # aws account id
REGION="$5"

if [ -z "$IMAGE_NAME" ] || [ -z "$TAG" ] || [ -z "$ECR_NAMESPACE" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <image-name> <tag> <ecr-namespace> <account-id> <region>"
  exit 1
fi

FULL_IMAGE="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_NAMESPACE/$IMAGE_NAME:$TAG"
echo "📦 Tagging $IMAGE_NAME → $FULL_IMAGE"
docker tag "$IMAGE_NAME" "$FULL_IMAGE"
docker push "$FULL_IMAGE"
