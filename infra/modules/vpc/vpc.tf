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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks.id

  tags = merge(var.tags,{
    Name = "${var.project_name}-igw"
})
}
resource "aws_eip" "nat" {
  for_each = var.single_nat_gateway ? {single = values(local.public_subnet_id)[0]} : local.public_subnet_id

}
locals {
  public_subnet_id = {for k,s in aws_subnet.public: k => s.id }
}
resource "aws_nat_gateway" "nat" {
  for_each = var.single_nat_gateway ?  {single = values(local.public_subnet_id)[0]} : local.public_subnet_id

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value

tags = merge(var.tags,{
    Name = "${var.project_name}-nat-gateway"
})

  depends_on = [aws_internet_gateway.igw]
}
# ----------------------------
# Public Subnets
# ----------------------------
resource "aws_subnet" "public" {
  for_each                = toset(slice(data.aws_availability_zones.available.names,0,2)) 
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 8, index(data.aws_availability_zones.available.names,each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags,{
    Name                     = "${var.project_name}-public-${each.key}"
    "kubernetes.io/role/alb"  = "1"
  })
}


resource "aws_subnet" "private" {
  for_each = toset( slice(data.aws_availability_zones.available.names,0,2) )
  vpc_id = aws_vpc.eks.id
  cidr_block = cidrsubnet(aws_vpc.eks.cidr_block,8,index(data.aws_availability_zones.available.names,each.key) + 100 )
  availability_zone = each.key
  map_public_ip_on_launch = false
  tags = merge(var.tags,{
    Name = "${var.project_name}-private-${each.key}"
    "kubernetes.io/role/internal-lb" = "1"
})
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id
  
  tags = merge(var.tags,{
    Name = "${var.project_name}-private-rt"
  })

}
locals {
  private_subnet_ids = { for k, s in aws_subnet.private : k => s.id }
}
resource "aws_route" "private" {
    for_each = var.single_nat_gateway ? {single = values(local.private_subnet_ids)[0]} : local.private_subnet_ids
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.single_nat_gateway ? aws_nat_gateway.nat["single"].id :aws_nat_gateway.nat[each.key].id
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  tags = merge(var.tags,{
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
