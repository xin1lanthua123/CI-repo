
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
variable "enable_kms" {
  type = bool
  description = "create kms based on this variable permission"
  default = true
}