include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/S3-Backup-logs"
}
inputs = {
    enable_kms     = include.env.locals.S3_logs.enable_kms
    kms_key_alias  = include.env.locals.kms_tags.kms_key_alias 
    kms_s3_tags    = include.env.locals.kms_tags.kms_s3_tags 
    tags           = include.env.locals.tags
    project_name   = include.env.locals.tags.Project
    env            = include.env.locals.tags.env

}

     
