output "eks_kubeconfig" {
  value = templatefile(
    "${path.module}/tmp/kubeconfig.yml",
    {
      eks_cluster_endpoint      = aws_eks_cluster.eks_cluster.endpoint,
      eks_certificate_authority = aws_eks_cluster.eks_cluster.certificate_authority.0.data,
      cluster_name              = var.cluster_name
    }
  )
}
 
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "config_map_aws_auth" {
  value = templatefile(
    "${path.module}/tmp/config_map_aws_auth.yml",
    {
      eks-node-group-role = aws_iam_role.eks-node.arn
    }
  )
}
