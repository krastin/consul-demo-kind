terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.cluster.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = kind_cluster.cluster.kubeconfig_path
}