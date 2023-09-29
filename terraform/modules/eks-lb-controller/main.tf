data "http" "aws-lb-controller-policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v${var.eks_lb_addon_version}/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "load-balancer-controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  policy      = tostring(data.http.aws-lb-controller-policy.response_body)
  description = "Load Balancer Controller add-on for EKS"

  tags = merge(
    { Name = "${var.eks_cluster_name}-lb-controller-policy" },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "lb_policies_permissions" {
  role       = var.eks_oidc_role_name
  policy_arn = aws_iam_policy.load-balancer-controller.arn
}

resource "kubernetes_service_account_v1" "kube_serviceaccount_lb" {
  metadata {
    labels = {
      "app.kubernetes.io/component" : "controller"
      "app.kubernetes.io/name" : "aws-load-balancer-controller"
    }
    name        = "aws-load-balancer-controller"
    namespace   = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" : var.eks_oidc_role_arn
    }
  }
}

resource "helm_release" "eks_cluster_lb_controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
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


