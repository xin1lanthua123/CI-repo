data "aws_ssm_parameter" "kms_key_id" {
  name = "/terraform/kms_key_id"
}
