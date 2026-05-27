resource "aws_ssm_parameter" "kms_key_arn" {
  name  = "/terraform/kms_key_id"
  type  = "String"
  overwrite = true
  value = aws_kms_key.tf_state[0].key_id
}
