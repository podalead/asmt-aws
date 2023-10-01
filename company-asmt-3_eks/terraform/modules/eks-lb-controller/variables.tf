variable "eks_cluster_name" {
  type = string
}

variable "eks_lb_addon_version" {
  type = string
}

variable "eks_oidc_role_name" {
  type = string
}

variable "eks_oidc_role_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
