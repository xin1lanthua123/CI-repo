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
    condition {
    test     = "StringEquals"
    variable = "aws:SourceAccount"
    values   = [data.aws_caller_identity.current.account_id]
  }

    condition {
    test     = "ArnLike"
    variable = "aws:SourceArn"
    values   = [
      aws_s3_bucket.tf_state.arn
    ]
  }
    condition { 
    test = "StringEquals" 
    variable = "kms:ViaService" 
    values = ["s3.us-east-1.amazonaws.com"] 
    }

    resources = ["*"]
  }
}

resource "aws_kms_key_policy" "this" {
  key_id = var.enable_kms ? aws_kms_key.tf_state[0].arn : null
  policy = data.aws_iam_policy_document.kms.json
}