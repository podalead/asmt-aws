terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }

  backend "s3" {}
}

provider "aws" {}

provider "helm" {
  kubernetes {
    host                   = module.eks_master.eks_cluster_host
    cluster_ca_certificate = base64decode(module.eks_master.eks_cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_master.eks_cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks_master.eks_cluster_host
  cluster_ca_certificate = base64decode(module.eks_master.eks_cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks_master.eks_cluster_name]
    command     = "aws"
  }
}

