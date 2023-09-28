variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_idp_name" {
  type = string
}

variable "eks_cluster_client_id" {
  type = string
}

variable "eks_cluster_idp_role_name" {
  type = string
}

variable "eks_cluster_oidc_issuer" {
  type = string
}

variable "tags" {
  type = map(string)
}
