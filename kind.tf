resource "random_pet" "cluster" {
}

resource "kind_cluster" "cluster" {
  name           = random_pet.cluster.id
  node_image     = "kindest/node:v1.27.1"
  wait_for_ready = true
  kubeconfig_path = "kind-kubeconfig"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
      extra_port_mappings { # for demo nginx workload 80
        container_port = 30080
        host_port      = 30080
      }
      extra_port_mappings { # for Consul RPC 8300
        container_port = 30300
        host_port      = 30300
      }
      extra_port_mappings { # for Consul Serf 8301
        container_port = 30301
        host_port      = 30301
      }
      extra_port_mappings { # for Consul HTTPS 8501
        container_port = 30501
        host_port      = 30501
      }
      extra_port_mappings { # for Consul gRPC 8502
        container_port = 30502
        host_port      = 30502
      }
      extra_port_mappings { # for Consul UI 443
        container_port = 30443
        host_port      = 30443
      }
    }
  }
}
