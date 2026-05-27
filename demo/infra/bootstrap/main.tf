resource "random_id" "suffix" {
  byte_length = 8
}
resource "aws_kms_key" "tf_state" {
  count = var.enable_kms ? 1 : 0
  description = "KMS key for remote state encryption"
  deletion_window_in_days = 7
  enable_key_rotation = true
  rotation_period_in_days = 90
  tags = var.kms_state_tags
}
# resource "aws_kms_alias" "tfstate" {
#   count = var.enable_kms ? 1 : 0
#   name          = "alias/tfstate-key-${random_id.suffix.hex}"
#   target_key_id = aws_kms_key.tf_state[0].key_id
# }
resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.project_name}-terraform-tf-state"
    tags = {
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_ownership_controls" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_state" {
  depends_on = [aws_s3_bucket_ownership_controls.tf_state]

  bucket = aws_s3_bucket.tf_state.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_enc" {
  bucket = aws_s3_bucket.tf_state.id
  depends_on = [aws_kms_key.tf_state]

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.enable_kms ? aws_kms_key.tf_state[0].arn : null
      sse_algorithm =  var.enable_kms ?  "aws:kms" : "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_block" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "${var.project_name}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Project = var.project_name
  }
}