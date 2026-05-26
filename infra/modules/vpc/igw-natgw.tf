resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks.id

  tags = merge(var.tags,{
    Name = "${var.env}-${var.project_name}-igw"
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
