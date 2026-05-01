include "root" {
    path = find_in_parent_folders()
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/WAF"
}
inputs = {
    project_name = include.env.locals.tags.Project
    tags         = include.env.locals.tags
    env          = include.env.locals.tags.env
    # cluster_name = dependency.eks_core.outputs.cluster_name
}

     
# dependency "eks_core" {
#  config_path = "../eks_core"  
#    mock_outputs = {
#    cluster_name = "mock-eks-cluster"
#   }

#   mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"] 
# }