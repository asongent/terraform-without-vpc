output "endpoint" {
  value = aws_eks_cluster.fred_eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.fred_eks_cluster.certificate_authority[0].data
}

output "identity-oidc-issuer" {
  value = aws_eks_cluster.fred_eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_iam_role_id" {
  value = aws_iam_role.cluster_role.id
}

output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster_role.arn
}

output "cluster_iam_role_name" {
  value = aws_iam_role.cluster_role.name
}

output "cluster_sg_id" {
  value = aws_security_group.cluster_sg.id
}

output "cluster_sg_name" {
  value = aws_security_group.cluster_sg.name
}
