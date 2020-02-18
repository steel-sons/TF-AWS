output "eks_kubeconfig" {
  value      = local.kubeconfig
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}
