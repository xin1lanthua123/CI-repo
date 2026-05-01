resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group-${var.env}"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags,{
    Name = "${var.project_name}-subnet-group"
})
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg-${var.env}"
  description = "Allow EKS nodes to access RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Postgres from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = var.allowed_cluster_security_group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,{
    Name = "${var.project_name}rds-security-group"
})
}

resource "aws_db_instance" "postgres" {
  identifier = "myapppostgres${var.env}"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az               = var.multi_az
  publicly_accessible    = false

  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = merge(var.tags,{
    Name = "${var.project_name}-db-instance"
})
}