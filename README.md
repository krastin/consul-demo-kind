# consul-demo-kind
A repository to hold Terraform code for a Consul cluster running locally on kind (k8s in docker)

This repository is currently a work-in-progress. To use the project in its unfinished state, you need to:

- install [consul](https://www.consul.io/)
- install [terraform](https://www.terraform.io/)
- install [docker](https://www.docker.com/) and run it
- install [kind](https://kind.sigs.k8s.io/)
- run `consul tls ca create` to generate `consul-agent-ca.pem` and `consul-agent-ca-key.pem`
- paste the related files on lines [19](https://github.com/krastin/consul-demo-kind/blob/2b01c7e3e4a401415d17981ca5af81e8443da580/consul.tf#L19) and [35](https://github.com/krastin/consul-demo-kind/blob/2b01c7e3e4a401415d17981ca5af81e8443da580/consul.tf#L35) of `consul.tf`
- run `terraform init` followed by `terraform apply`
