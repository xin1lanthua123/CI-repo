#!/bin/bash

set -e

STATIC_BUCKETS=(
  "myapp-terraform-tf-state"
)

PREFIX="dev-my-log-bucket-"

echo "⚠️ Bắt đầu xoá S3 buckets..."

# Lấy danh sách bucket theo prefix
MATCHING_BUCKETS=$(aws s3api list-buckets \
  --query "Buckets[?starts_with(Name, \`${PREFIX}\`)].Name" \
  --output text)

BUCKETS=("${STATIC_BUCKETS[@]}")

# thêm các bucket match prefix vào mảng
for b in $MATCHING_BUCKETS; do
  BUCKETS+=("$b")
done

echo "Danh sách bucket sẽ xoá:"
printf '%s\n' "${BUCKETS[@]}"

echo "======================================"

for BUCKET in "${BUCKETS[@]}"; do
  echo "🧨 Xử lý bucket: $BUCKET"

  # Xoá object versions
  echo " - Xoá object versions..."
  aws s3api list-object-versions --bucket "$BUCKET" \
    --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
    --output json > /tmp/versions.json

  if [ "$(cat /tmp/versions.json)" != "{\"Objects\":null}" ]; then
    aws s3api delete-objects --bucket "$BUCKET" --delete file:///tmp/versions.json || true
  fi

  # Xoá delete markers
  echo " - Xoá delete markers..."
  aws s3api list-object-versions --bucket "$BUCKET" \
    --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
    --output json > /tmp/delete-markers.json

  if [ "$(cat /tmp/delete-markers.json)" != "{\"Objects\":null}" ]; then
    aws s3api delete-objects --bucket "$BUCKET" --delete file:///tmp/delete-markers.json || true
  fi

  # Xoá bucket
  echo " - Xoá bucket..."
  aws s3 rb "s3://$BUCKET" --force || aws s3api delete-bucket --bucket "$BUCKET"

  echo "✔ Done: $BUCKET"
done

rm -f /tmp/versions.json /tmp/delete-markers.json

echo "🎉 Hoàn tất xoá tất cả bucket!"