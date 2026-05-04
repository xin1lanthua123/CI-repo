set -euo pipefail

BUCKET=$(terragrunt output -raw tfstate_bucket_name)
DYNAMODB_LOCK=$(terragrunt output -raw lock_table_name)
KMS_KEY=$(terragrunt output -raw aws_kms_key)
echo "S3 bucket : $BUCKET"
echo "DynamoDB lock :$DYNAMODB_LOCK"
echo "KMS key : $KMS_KEY"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../" && pwd)"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ROOT_DIR:   $ROOT_DIR"

cat > "$ROOT_DIR/terragrunt.hcl" <<EOF
remote_state {
  backend = "s3"
  config = {
    bucket         = "$BUCKET"
    key            = "\${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "$DYNAMODB_LOCK"
    encrypt        = true
    kms_key_id     = "$KMS_KEY"
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
  region = "\${local.aws_region}"
}
EOT
}


EOF

echo "successfully generated remote root state"



# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOT
# terraform {
#   backend "s3" {}
# }
# EOT
# }