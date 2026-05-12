terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_context = "minikube"
  #choose default file configuration for kubectl, which is usually located at ~/.kube/config, for easy access to the cluster
  config_path = "~/.kube/config"
}

# provider "aws" {
#   region = "us-east-1"

# }