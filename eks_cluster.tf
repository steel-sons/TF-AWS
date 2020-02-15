#### EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids              = flatten([aws_subnet.subnet-public.*.id, aws_subnet.subnet-private.*.id])
    security_group_ids      = [aws_security_group.eks_cluster_security_group.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSServicePolicy,
  ]

  tags = {
    tag-key = "EKS-cluster"
  }
}
