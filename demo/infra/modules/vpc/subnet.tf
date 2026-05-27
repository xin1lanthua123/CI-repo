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
