resource "random_uuid" "consul-bootstrap-token" {
}

resource "kubernetes_namespace" "namespace-consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_secret" "consul-ca-cert" {
  metadata {
    namespace = "consul"
    name = "consul-ca-cert"
  }
  
  data = { # TODO-generate automatically via Terraform
    # contents of consul-agent-ca.pem
    "tls.crt" = <<-EOT
    PASTE CA CERT HERE
    EOT
  }

  depends_on = [ kubernetes_namespace.namespace-consul ]
}

resource "kubernetes_secret" "consul-ca-key" {
  metadata {
    namespace = "consul"
    name = "consul-ca-key"
  }
  
  data = { # TODO-generate automatically via Terraform
    # contents of consul-agent-ca-key.pem
    "tls.key" = <<-EOT
    PASTE CA PRIVATE KEY HERE
    EOT
  }

  depends_on = [ kubernetes_namespace.namespace-consul ]
}

resource "kubernetes_secret" "consul-bootstrap-token" {
  metadata {
    namespace = "consul"
    name = "consul-consul-bootstrap-acl-token"
  }

  data = {
    "token" = random_uuid.consul-bootstrap-token.result
  }

  depends_on = [ kubernetes_namespace.namespace-consul ]
}

resource "helm_release" "consul" {
  name = "consul"
  namespace = "consul"
  create_namespace = true

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    "${file("consul-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "NodeIP"
  }

  depends_on = [
    kind_cluster.cluster,
    kubernetes_secret.consul-ca-cert,
    kubernetes_secret.consul-ca-key,
    kubernetes_secret.consul-bootstrap-token,
    kubernetes_namespace.namespace-consul,
  ]
}
