variable "project_name" {
  type = string
  default = "my-app"
}
variable "env" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {
  Environment = "prod"
  ManagedBy   = "terraform"
  }
}
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "cluster_version" {
  type    = string
  default = "1.30"
}
variable "node_groups" {
  description = "groups of node"
  type = map(object({
    node_instance_type = string
    desired_size = number
    min_size = number
    max_size = number
  }))
  default = {
    "group1" = {
      node_instance_type = "t3.medium"
      desired_size = 2
      min_size = 1
      max_size = 3
    }
  }

}

variable "private_subnet_ids"{
    type = list(string)
}

variable "enable_irsa" {
  description = "modifying whether do you like to change it or not"
  type = bool
  default = true
}