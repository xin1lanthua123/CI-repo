data "aws_availability_zones" "available" {}

# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-${var.project_name}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    
    subnet_ids = var.private_subnet_ids
    endpoint_public_access  = true
    endpoint_private_access  = true
   # public_access_cidrs = ["203.0.113.10/32", "198.51.100.0/24"]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
  tags = merge (var.tags,{
    Name = "${var.project_name}-eks"
})
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "eks_cluster_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "eks_nodes_sg" {
  vpc_id = var.vpc_id

 
  ingress {
    description = "Node to node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "ALB to nodes"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "EKS control plane to kubelet"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# NodeGroup
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.env}-${var.project_name}-eks-node"
  image_id      = null # EKS tự chọn AMI

  vpc_security_group_ids = [
    aws_security_group.eks_nodes_sg.id
  ]
}


resource "aws_eks_node_group" "nodes" {
  for_each        = var.node_groups 
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.project_name}-${each.key}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [each.value.node_instance_type]
  ami_type = "AL2_x86_64"

  scaling_config {
    desired_size       = each.value.desired_size
    min_size           = each.value.min_size
    max_size           = each.value.max_size
  }
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }
  tags = merge (var.tags,{
    Name = "${var.project_name}-node-${each.key}"
})
  depends_on = [
    aws_iam_role_policy_attachment.node_worker_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy
  ]
}
