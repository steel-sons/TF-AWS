#### Security group for EKS cluster
resource "aws_security_group" "eks_cluster_security_group" {
  name        = "EKS-Security-Group"
  description = "EKS Cluster communication with worker nodes"
  vpc_id      = aws_vpc.bastion.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "eks-cluster-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

}

resource "aws_security_group_rule" "eks-ingress-node-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  type              = "ingress"
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
  security_group_id = aws_security_group.eks_cluster_security_group.id
}
