# variable "alb_arn" {
#   type = string
# }
variable "env" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
  }
}
variable "project_name" {
  type = string
}
# variable "cluster_name" {
#   type = string
# }