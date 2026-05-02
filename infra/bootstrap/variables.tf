variable "project_name" {
  type = string
  default = "my-app"
}

variable "region" {
  type = string
  default = "us-east-1"
}
variable "enable_kms" {
  type = bool
  default = true
}
variable "github_org" {
  type = string
}
variable "github_repo" {
  type = string
}
variable "env" {
  type = string
}
variable "kms_state_tags" {
  type = map(string)
  default = {
    Name        = "tfstate-key"
    Project     = "my-app"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
