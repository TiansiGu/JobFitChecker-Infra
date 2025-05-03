#!/bin/bash

set -e

REPO_NAME="$1"
CUR_IMAGE_TAG="$2"
NEW_IMAGE_TAG="$3"

if [ -z "$REPO_NAME" ] || [ -z "$CUR_IMAGE_TAG" ] || [ -z "$NEW_IMAGE_TAG" ]; then
  echo "Usage: $0 <repository-name> <current-image-tag> <new-image-tag>"
  exit 1
fi

MANIFEST=$(aws ecr batch-get-image --repository-name "$REPO_NAME" --image-ids imageTag="$CUR_IMAGE_TAG" \
--output text --query 'images[].imageManifest')

if [ -z "$MANIFEST" ]; then
  echo "Error: Could not retrieve image manifest for tag '$CUR_IMAGE_TAG' in repository '$REPO_NAME'"
  exit 2
fi

aws ecr put-image --repository-name "$REPO_NAME" --image-tag "$NEW_IMAGE_TAG" --image-manifest "$MANIFEST"