resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "${var.env}-argocd"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_argocd_version # "7.8.2"
  create_namespace = false

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = var.server_insecure
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd
  ]
}