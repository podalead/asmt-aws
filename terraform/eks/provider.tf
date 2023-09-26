terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }

  backend "s3" {}
}

provider "aws" {}

provider "kubernetes" {
  host                   = aws_eks_cluster.asmt_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.asmt_eks_cluster.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.asmt_eks_cluster.name]
    command     = "aws"
  }
}

