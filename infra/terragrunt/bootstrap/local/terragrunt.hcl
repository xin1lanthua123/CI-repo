remote_state {
  backend = "s3"
  config = {
    bucket         = "myapp-tf-state-34d0696a"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "myapp-terraform-locks-34d0696a"
    encrypt        = true
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
