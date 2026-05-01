variable "project_name" {
  description = "Project name prefix"
  type        = string
  default = "my-app"
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
variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs list for RDS"
  type        = list(string)
}
variable "engine_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "15"
}
variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}
variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_username" {
  description = "Database username"
  type        = string
}
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  # validation {
  #   condition = length(var.db_password) > 8
  #   error_message = "the length of the password must be more than 8 characters"
  # }
}
variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "allowed_cluster_security_group" {
  type = list(string)
}