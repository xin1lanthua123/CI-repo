

#IAM Policy (S3 + KMS + Terraform State)

resource "aws_iam_policy" "github_actions_bootstrap_policy" {
  name        = "${var.project_name}-github-actions-bootstrap-policy"
  description = "GitHub Actions deploy bootstrap to AWS infrastructure"

policy = jsonencode({
  Version = "2012-10-17",
  Statement = [

    {
      Sid    = "S3Bootstrap",
      Effect = "Allow",
      Action = [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:ListBucket",
        "s3:PutBucketVersioning",
        "s3:GetBucketVersioning",
        "s3:PutBucketEncryption",
        "s3:GetBucketEncryption",
        "s3:PutBucketOwnershipControls",
        "s3:PutBucketAcl",
        "s3:GetBucketAcl",
        "s3:PutPublicAccessBlock",
        "s3:GetPublicAccessBlock"
      ],
      Resource = "*"
    },

    {
      Sid    = "KMSBootstrap",
      Effect = "Allow",
      Action = [
        "kms:CreateKey",
        "kms:CreateAlias",
        "kms:DescribeKey",
        "kms:EnableKeyRotation",
        "kms:PutKeyPolicy",
        "kms:ScheduleKeyDeletion"
      ],
      Resource = "*"
    },

    {
      Sid    = "DynamoDBBootstrap",
      Effect = "Allow",
      Action = [
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:DescribeTable",
        "dynamodb:UpdateTable"
      ],
      Resource = "*"
    }

  ]
})
}

# data "aws_iam_policy_document" "kms" {

#   statement {
#     sid = "AllowRootAccess"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }

#     actions = ["kms:*"]

#     resources = ["*"]
#   }

#   statement {
#     sid = "AllowTerraformRoleUseKey"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.github_actions_bootstrap.arn]
#     }

#     actions = [
#       "kms:Encrypt",
#       "kms:Decrypt",
#       "kms:GenerateDataKey",
#       "kms:DescribeKey"
#     ]

#     resources = ["*"]
#   }
# }
# resource "aws_kms_key_policy" "this" {
#   key_id = aws_kms_key.tf_state[0].arn
#   policy = data.aws_iam_policy_document.kms.json
# }


