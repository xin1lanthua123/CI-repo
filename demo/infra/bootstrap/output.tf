output "tfstate_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}
output "bucket_tfstate_arn" {
  value = aws_s3_bucket.tf_state.arn
}
output "lock_table_arn" {
  value = aws_dynamodb_table.tf_lock.arn
}
output "lock_table_name" {
  value = aws_dynamodb_table.tf_lock.name
}

output "aws_kms_key" {
  value = try(aws_kms_key.tf_state[0].key_id,null)
}
output "github_action_infra_role_arn" {
  value = aws_iam_role.github_actions_infra.arn
}

output "github_action_bootstrap_role_arn" {
  value = aws_iam_role.github_actions_bootstrap.arn
}