include "root" {
    path = find_in_parent_folders()
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/vpc"
}
inputs = {
    tags         = include.env.locals.tags
    project_name = include.env.locals.tags.Project
    single_nat_gateway = include.locals.vpc.single_nat_gateway
    env            = include.env.locals.tags.env
}

     
