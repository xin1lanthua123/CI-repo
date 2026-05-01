output "vpc_id" {
  value = aws_vpc.eks.id
}

output "private_subnet" {
    value = [for private_subnet in aws_subnet.private : private_subnet.id]
}
output "public_subnet" {
    value = [for public_subnet in aws_subnet.public : public_subnet.id]
}
output "vpc_cidr" {
  value = aws_vpc.eks.cidr_block
}