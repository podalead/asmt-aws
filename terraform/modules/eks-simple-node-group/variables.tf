variable "product" {
  type = string
}

variable "environment" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_node_group_name" {
  type = string
}

variable "vpc_private_subnet_ids" {
  type = list(string)
}

variable "eks_ng_instance_types" {
  type = list(string)
  default = ["t3.small", "t3a.small"]
}

variable "eks_node_group_role_name" {
  type = string
}

variable "tags" {
  type = map(string)
}
