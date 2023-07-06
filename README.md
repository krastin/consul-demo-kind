# consul-demo-kind
A repository to hold Terraform code for a Consul cluster running locally on kind (k8s in docker)

To use this project, you need to:

- install [consul](https://www.consul.io/)
- install [terraform](https://www.terraform.io/)
- install [docker](https://www.docker.com/) and run it
- install [kind](https://kind.sigs.k8s.io/)
- run `terraform init` followed by `terraform apply`
- run `export KUBECONFIG="$(pwd)/kind-kubeconfig"` to configure `kubectl`
- observe the Terraform output on how to configure Consul CLI to communicate with your cluster:

    To use kubectl with this K8s cluster:
    export KUBECONFIG="$(pwd)/kind-kubeconfig" # to configure kubectl

    To use the Consul CLI:
    export CONSUL_HTTP_ADDR=https://localhost:30501 # configure Consul target
    export CONSUL_HTTP_TOKEN=$(terraform output -raw consul-token) # configure Consul token
    export CONSUL_CACERT=$(pwd)/consul-agent-ca.pem # configure Consul certificate

    To access the Consul web UI:
    https://localhost:30443/ui/