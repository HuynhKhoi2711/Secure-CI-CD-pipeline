#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
# resource "aws_vpc" "main_vpc" {

#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "DevSecOps-VPC-Week1"
#     Owner = "Truong"
#   }
# }

#isolate own namespace to avoid conflict with default namespace 
resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging-env"
  }
}

resource "kubernetes_secret" "ghct_secret" {
  metadata {
    name      = "ghcr-secret"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          auth = base64encode("username:${var.ghcr_pat}") 
        }
      }
    })
  }

}


# 
resource "kubernetes_deployment" "nodegoat" {
  metadata {
    name      = "staging"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  spec {
    #Use the "replicas" field to specify the number of desired replicas for the deployment. In this example, we set it to 3, which means that Kubernetes will maintain 3 running instances of the application at all times. If any of the instances fail or are terminated, Kubernetes will automatically create new ones to replace them, ensuring high availability for the application.
    replicas = 3

    selector {
      match_labels = {
        app = "nodegoat"
      }
    }

    template {
      metadata {
        labels = {
          app = "nodegoat"
        }
      }

      spec {
        image_pull_secrets {
          name = kubernetes_secret.ghct_secret.metadata[0].name
        }

        container {
          name              = "nodegoat" #rename later
          security_context {
            run_as_non_root = true
            allow_privilege_escalation = false
          }
          image             = "nodegoat:latest"
          image_pull_policy = "IfNotPresent"
          command           = ["sh", "-c", "until nc -z -w 2 mongo 27017 && echo 'mongo is ready for connections' && node artifacts/db-reset.js && npm start; do sleep 2; done"]
          port {
            container_port = 4000
          }
          env {
            name = "MONGODB_URI"
            # "mongo" là tên của kubernetes_service mà bạn đã đặt bên dưới
            value = "mongodb://mongo:27017/nodegoat"
          }
          env {
            name  = "NODE_ENV"
            value = ""
          }
        }

      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "nodegoat-service"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  spec {
    selector = {
      app = "nodegoat"
    }

    port {
      port        = 4000
      target_port = 4000
      #K8s stipulates that NodePort must be within the range of 30000-32767. By specifying node_port = 30080, we are explicitly assigning the NodePort to 30080, which is within the allowed range. This means that the service will be accessible on port 30080 on each node in the cluster, and traffic sent to this port will be forwarded to the target port (80) of the selected pods.
      node_port = 30080
    }
    #directly expose on the server (node) of Minikube
    type = "NodePort"
  }
}

# Deployment cho MongoDB
resource "kubernetes_deployment" "mongo_deploy" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }
  spec {
    selector { match_labels = { app = "mongo" } }
    template {
      metadata { labels = { app = "mongo" } }
      spec {
        container {
          name  = "mongo"
          image = "mongo:4.4"
          port { container_port = 27017 }
        }
      }
    }
  }
}

# Service cho MongoDB để Web gọi qua DNS "mongo"
resource "kubernetes_service" "mongo_service" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }
  spec {
    selector = { app = "mongo" }
    port {
      port        = 27017
      target_port = 27017
    }
  }
}

