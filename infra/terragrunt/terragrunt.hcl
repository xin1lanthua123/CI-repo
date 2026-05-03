remote_state {
  backend = "s3"
  config = {
    bucket         = "bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamodblock"
    encrypt        = true
    kms_key_id     = "kmskey"
  }
}

locals {
  aws_region = "us-east-1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
provider "aws" {
  region = "${local.aws_region}"
}
EOT
}
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "s3" {}
}
EOT
}

