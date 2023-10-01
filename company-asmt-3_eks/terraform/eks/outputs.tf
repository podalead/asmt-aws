output "eks_cluster_name" {
  value = module.eks_master.eks_cluster_name
}

output "eks_host" {
  value = module.eks_master.eks_cluster_host
}

output "eks_ca_cert_base64" {
  value     = module.eks_master.eks_cluster_ca_certificate
  sensitive = true
}

output "eks_oidc_arn" {
  value = module.eks_oidc.eks_oidc_arn
}
