resource "random_uuid" "consul_bootstrap_token" {
}

resource "tls_private_key" "consul_ca_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "consul_ca_cert" {
  private_key_pem = tls_private_key.consul_ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country      = "US"
    province     = "CA"
    locality     = "San Francisco/street=101 Second Street/postalCode=94105"
    common_name  = "Consul Agent CA"
    organization = "HashiCorp Inc."
  }

  validity_period_hours = 43800 //  1825 days or 5 years

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "cert_signing",
    "crl_signing",
    "server_auth",
    "client_auth",
  ]
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
  
  data = {
    "tls.crt" = tls_self_signed_cert.consul_ca_cert.cert_pem
  }

  depends_on = [ kubernetes_namespace.namespace-consul ]
}

resource "kubernetes_secret" "consul-ca-key" {
  metadata {
    namespace = "consul"
    name = "consul-ca-key"
  }
  
  data = {
    "tls.key" = tls_private_key.consul_ca_private_key.private_key_pem
  }

  depends_on = [ kubernetes_namespace.namespace-consul ]
}

resource "kubernetes_secret" "consul_bootstrap_token" {
  metadata {
    namespace = "consul"
    name = "consul-consul-bootstrap-acl-token"
  }

  data = {
    "token" = random_uuid.consul_bootstrap_token.result
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
    kubernetes_secret.consul_bootstrap_token,
    kubernetes_namespace.namespace-consul,
  ]
}

resource "local_file" "consul_client_key" {
    content  = tls_self_signed_cert.consul_ca_cert.cert_pem
    filename = "./consul-ca.pem"
    file_permission = "0400"
}