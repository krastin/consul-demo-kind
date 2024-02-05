resource "kubernetes_namespace" "hashicups" {
  metadata {
    name = "hashicups"
  }
}

data "kubectl_path_documents" "docs" {
    pattern = "./hashicups-v1.0.3/service*.yaml"
}

resource "kubectl_manifest" "hashicups" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value

    depends_on = [ helm_release.consul, kubernetes_namespace.hashicups ]
}