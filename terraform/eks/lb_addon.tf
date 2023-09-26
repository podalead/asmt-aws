data "http" "aws-lb-controller-policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v${var.eks_addon_lb_version}/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "load-balancer-controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = tostring(data.http.aws-lb-controller-policy.response_body)
  description = "Load Balancer Controller add-on for EKS"
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

resource "aws_iam_role_policy_attachment" "inline-AWSLoadBalancerControllerIAMPolicy" {
  role       = aws_iam_role.aws-node.name
  policy_arn = aws_iam_policy.load-balancer-controller.arn
}

resource "kubernetes_service_account_v1" "kube_serviceaccount_lb" {
  metadata {
    labels = {
      "app.kubernetes.io/component": "controller"
      "app.kubernetes.io/name": "aws-load-balancer-controller"
    }
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn": aws_iam_role.aws-node.arn
    }
  }
}

#resource "helm_release" "eks_cluster_lb_crd" {
#  name  = ""
#  repository = "https://aws.github.io/eks-charts"
#  chart = ""
#}

resource "helm_release" "eks_cluster_lb_controller" {
  name  = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = local.eks_cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}


