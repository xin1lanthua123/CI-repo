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
variable "single_nat_gateway" {
  type = bool
  default = true 
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}
