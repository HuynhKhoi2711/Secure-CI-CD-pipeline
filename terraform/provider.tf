terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Chạy tại vùng Bắc Virginia để áp dụng AMI Ubuntu phía trên
}