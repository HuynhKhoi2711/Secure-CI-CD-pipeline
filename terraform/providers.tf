terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path = "~/.kube/config"
}

provider "aws" {
  region = "us-east-1"

}

