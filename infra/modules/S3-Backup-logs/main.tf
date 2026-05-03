resource "random_id" "this" {
  byte_length = 4
}
resource "aws_kms_key" "name" {
  count = var.enable_kms ? 1 : 0
  description = "KMS key for remote state encryption"
  deletion_window_in_days = 7
  enable_key_rotation = true
  tags = var.kms_s3_tags
}
resource "aws_kms_alias" "name" {
  count = var.enable_kms ? 1 : 0
  name          = "${var.kms_key_alias}-${var.env}-${random_id.this.hex}"    #"alias/s3-logs-key"
  target_key_id = aws_kms_key.name[0].key_id
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.env}-my-log-bucket-${random_id.this.hex}"
  tags = merge(var.tags,{
    Name = "${var.project_name}-s3-bucket-logs"
})
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs" {
  depends_on = [aws_s3_bucket_ownership_controls.logs]

  bucket = aws_s3_bucket.logs.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.enable_kms ? "aws:kms" : "AES256"
      kms_master_key_id =  var.enable_kms ? aws_kms_key.name[0].arn : null

    }
  }
}


