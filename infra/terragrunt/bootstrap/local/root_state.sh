set -euo pipefail
KMS_KEY=$(terragrunt output -raw aws_kms_key )

# Kiểm tra nếu KMS_KEY rỗng
if [ -z "$KMS_KEY" ]; then
  echo "KMS key is empty"
  exit 1
fi

echo "KMS arn of tf state: $KMS_KEY"



SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../" && pwd)"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "ROOT_DIR:   $ROOT_DIR"

cat > "$ROOT_DIR/terragrunt.hcl" <<EOF
remote_state {
  backend = "s3"
  config = {
    bucket         = "myapp-terraform-tf-state"
    key            = "\${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "myapp-terraform-locks"
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
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "s3" {}
}
EOT
}

EOF

echo "successfully generated remote root state"