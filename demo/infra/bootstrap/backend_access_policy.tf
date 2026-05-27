resource "aws_iam_policy" "github_actions_backend_policy" {
  name = "${var.project_name}-backend-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # -------------------------
      # S3 TFSTATE ACCESS
      # -------------------------
      {
        Sid    = "S3State",
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = aws_s3_bucket.tf_state.arn
      },
      {
        Sid    = "S3StateObjects",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.tf_state.arn}/*"
      },

      # -------------------------
      # DYNAMODB LOCK
      # -------------------------
      {
        Sid    = "DynamoDBLock",
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource = aws_dynamodb_table.tf_lock.arn
      },

      # -------------------------
      # KMS USAGE (NOT CREATE)
      # -------------------------
      {
        Sid    = "KMSUsage",
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.tf_state[0].arn
      }

    ]
  })
}