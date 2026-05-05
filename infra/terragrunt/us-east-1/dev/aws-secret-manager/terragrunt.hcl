include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/aws-secret-manager"
}
inputs = {
    env          = include.env.locals.tags.env
    project_name = include.env.locals.tags.Project
    db_name      = include.env.locals.aws_secret_manager.secret_for_rds.db_name
    username     = include.env.locals.aws_secret_manager.secret_for_rds.username
}

