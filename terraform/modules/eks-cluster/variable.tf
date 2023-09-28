variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_role_name" {
  type = string
}

variable "eks_cluster_sg_name" {
  type = string
}

variable "eks_cluster_log_policy_name" {
  type = string
}

variable "eks_ip_family" {
  type = string
  default = "ipv4"

  validation {
    condition = var.eks_ip_family == "ipv4" || var.eks_ip_family == "ipv6"
    error_message = "Your ip family is wrong type"
  }
}

variable "eks_service_ipv4_cidr" {
  type = string
}

variable "eks_private_subnet_ids" {
  type = list(string)
}

variable "eks_log_types" {
  type = list(string)
  default = []
}
