set -euo pipefail


cat > ../../../bootstrap/backend.tf <<EOF
terraform {
  backend "s3" {
  }
}
EOF

echo "Successfully generated root hcl"

cat > terragrunt.hcl <<EOF
remote_state {
  backend = "s3"
  config = {
    bucket         = "myapp-terraform-tf-state"
    key            = "\${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "myapp-terraform-locks"
    encrypt        = true
    kms_key_id     = "alias/tfstate-key"
  }
}

terraform {
    source = "../../../bootstrap"
}

include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
inputs = {
   region       = include.env.locals.bootstrap.region
   enable_kms   = include.env.locals.bootstrap.enable_kms
   project_name = include.env.locals.bootstrap.project_name
   github_org     = include.env.locals.bootstrap.github_org
   github_repo    = include.env.locals.bootstrap.github_repo
   env            = include.env.locals.bootstrap.env
}
EOF

echo "successfully generated remote boostrap state"

