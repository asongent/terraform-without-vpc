output "vpc_name" {
  value = var.vpc_name
}
# output "vpc_id" {
#   value = vpc.vpc_id
# }
output "cluster_name" {
  value = var.cluster_name
}
output "cluster_endpoint" {
  value = module.eks_cluster.endpoint
}
output "region" {
  description = "AWS region"
  value       = var.region
}

/* output "bastion-host" {
  value = module.bastion-host.public_ip
} */