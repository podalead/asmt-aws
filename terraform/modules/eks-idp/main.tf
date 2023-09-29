locals {
  eks_idp_name = "${var.eks_cluster_idp_name}-iam"
  iam_openid_provider_connect_name = var.eks_cluster_idp_name
  oidc_uri = replace(aws_iam_openid_connect_provider.demo.url, "https://", "")
}

data "tls_certificate" "demo" {
  url = var.eks_cluster_oidc_issuer
}

data "aws_iam_policy_document" "eks_lb_trust_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.demo.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_uri}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_uri}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_openid_connect_provider" "demo" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.demo.certificates[0].sha1_fingerprint]
  url             = var.eks_cluster_oidc_issuer

  tags = merge(
    { Name = local.iam_openid_provider_connect_name },
    var.tags
  )
}

resource "aws_iam_role" "aws-node" {
  name               = var.eks_cluster_idp_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_lb_trust_policy.json
}

resource "aws_eks_identity_provider_config" "demo" {
  cluster_name = var.eks_cluster_name

  oidc {
    client_id                     = var.eks_cluster_client_id
    identity_provider_config_name = var.eks_cluster_idp_name
    issuer_url                    = "https://${aws_iam_openid_connect_provider.demo.url}"
  }

  tags = merge(
    { Name = local.eks_idp_name },
    var.tags
  )

  depends_on = [
    aws_iam_role.aws-node
  ]
}
