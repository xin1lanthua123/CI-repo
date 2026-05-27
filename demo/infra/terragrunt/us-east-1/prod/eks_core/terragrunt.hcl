include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/eks_core"
}
inputs = {
    vpc_id             = dependency.vpc.outputs.vpc_id
    vpc_cidr           = dependency.vpc.outputs.vpc_cidr
    tags               = include.env.locals.tags
    env                = include.env.locals.tags.env
    cluster_version    = include.env.locals.eks.cluster_version
    project_name       = include.env.locals.tags.Project
    enable_irsa        = include.env.locals.eks.enable_irsa
    node_groups        = include.env.locals.eks.node_groups
    private_subnet_ids = dependency.vpc.outputs.private_subnet
}

dependency "vpc" {
    config_path = "../vpc"
     mock_outputs = {
     vpc_id = "vpc-0000000000"
     vpc_cidr = "10.0.0.0/16"
     private_subnet = ["subnet-11111111", "subnet-22222222"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}