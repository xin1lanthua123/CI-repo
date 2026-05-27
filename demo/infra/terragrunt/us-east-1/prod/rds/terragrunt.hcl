include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/rds"
}
inputs = {
    tags = include.env.locals.tags
    project_name = include.env.locals.tags.Project
    vpc_id = dependency.vpc.outputs.vpc_id
    private_subnet_ids = dependency.vpc.outputs.private_subnet
    engine_version = include.env.locals.rds.engine_version
    multi_az = include.env.locals.rds.multi_az
    instance_class = include.env.locals.rds.instance_class
    db_name = include.env.locals.rds.db_name
    db_username = include.env.locals.rds.db_username
    db_password = dependency.aws_secret_manager.outputs.db_password
    env         = include.env.locals.tags.env
    allowed_cluster_security_group = [dependency.eks_core.outputs.cluster_security_group_id]

}


dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
    vpc_id          = "vpc-00000000000000000"
  
    private_subnet = ["subnet-11111111", "subnet-22222222"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

dependency "eks_core" {
    config_path = "../eks_core"
    mock_outputs = {
    cluster_security_group_id = "sg-00000000000000000"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

dependency "aws_secret_manager" {
  config_path = "../aws-secret-manager"

  mock_outputs = {
    db_password         = "mock-password-123"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}



