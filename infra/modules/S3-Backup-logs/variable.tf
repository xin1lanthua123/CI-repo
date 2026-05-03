
variable "project_name" {
  description = "Project name"
  type        = string
}
variable "env" {
  type = string 
}
variable "tags" {
  type = map(string)
  default = {
  Environment = "prod"
  Project     = "my-app"
  ManagedBy   = "terraform"
  }
}
variable "kms_key_alias" {
  type = string
}
variable "kms_s3_tags" {
  type = map(string)
  default = {
    Name        = "s3-logs-kms"
    Project     = "my-app"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

variable "enable_kms" {
  type = bool
  description = "create kms based on this variable permission"
  default = true
}