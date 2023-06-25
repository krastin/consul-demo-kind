output "kubeconfig" {
    value = kind_cluster.cluster.kubeconfig
    sensitive = true
}

output "cluster-name"  {
    value = kind_cluster.cluster.name
}

output "consul-token" {
    value = random_uuid.consul-bootstrap-token.result
    sensitive = true
}

output "kubeconfig-file" {
    value =<<-EOT
    To use kubectl with this K8s cluster:
    export KUBECONFIG="$(pwd)/kind-kubeconfig" # to configure kubectl

    To use the Consul CLI:
    export CONSUL_HTTP_ADDR=https://localhost:30501 # configure Consul target
    export CONSUL_HTTP_TOKEN=$(terraform output -raw consul-token) # configure Consul token
    export CONSUL_CACERT=$(pwd)/consul-agent-ca.pem # configure Consul certificate

    To access the Consul web UI:
    https://localhost:30443/ui/

    EOT
}