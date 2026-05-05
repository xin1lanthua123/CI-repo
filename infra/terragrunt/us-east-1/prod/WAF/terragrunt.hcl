include "root" {
    path = find_in_parent_folders("root.hcl")
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
}

     
