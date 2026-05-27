
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.eks.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = toset([aws_route_table.private.id])
 

  tags = merge(var.tags , {
    Name = "${var.project_name}-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.eks.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = [ for s in aws_subnet.private : s.id]

  tags = merge(var.tags, {
    Name = "${var.project_name}-logs-endpoint"
  })
}

