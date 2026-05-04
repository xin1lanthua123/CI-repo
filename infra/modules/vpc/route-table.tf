
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
