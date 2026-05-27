data "aws_availability_zones" "available" {}
# ----------------------------
# VPC
# ----------------------------
resource "aws_vpc" "eks" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

tags = merge(var.tags,{
    Name = "${var.env}-${var.project_name}-eks-vpc"
})
}
