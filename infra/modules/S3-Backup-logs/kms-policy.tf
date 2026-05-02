data "aws_iam_policy_document" "kms" {

  statement {
    sid = "AllowRootAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["kms:*"]

    resources = ["*"]
  }

  statement {
    sid = "AllowS3UseOfKey"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
      "kms:ReEncrypt*"
    ]

    resources = ["*"]
  }
}

resource "aws_kms_key_policy" "this" {
  key_id = var.enable_kms ? aws_kms_key.name[0].arn : null
  policy = data.aws_iam_policy_document.kms.json
}