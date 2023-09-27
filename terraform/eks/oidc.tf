data "tls_certificate" "demo" {
  url = local.eks_cluster_oidc_issuer
}

resource "aws_iam_openid_connect_provider" "demo" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.demo.certificates[0].sha1_fingerprint]
  url             = local.eks_cluster_oidc_issuer
}

resource "aws_iam_role" "aws-node" {
  name               = local.eks_cluster_idp_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_lb_trust_policy.json
}

resource "aws_eks_identity_provider_config" "demo" {
  cluster_name = aws_eks_cluster.asmt_eks_cluster.name

  oidc {
    client_id                     = substr(local.eks_cluster_oidc_issuer, -32, -1)
    identity_provider_config_name = local.eks_cluster_idp_name
    issuer_url                    = "https://${aws_iam_openid_connect_provider.demo.url}"
  }

  depends_on = [
    aws_eks_cluster.asmt_eks_cluster,
    aws_iam_role.aws-node
  ]
}
