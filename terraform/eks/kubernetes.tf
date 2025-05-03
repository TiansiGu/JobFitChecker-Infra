provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

resource "kubernetes_namespace" "uat" {
  metadata {
    name = "uat"
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "ga" {
  metadata {
    name = "ga"
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
  depends_on = [module.eks]
}