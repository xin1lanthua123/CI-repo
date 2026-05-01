include "root" {
    path = find_in_parent_folders()
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
    db_name = "prod-postgres-db"
    username = "my-app-db"
}

# dependency "rds" {
#     config_path = "../rds"
#       mock_outputs = {
#       db_name  = "database123214"
#       username = "mockname"
#   }

#   mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
# }