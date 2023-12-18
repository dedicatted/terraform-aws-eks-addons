locals {
  metrics_server_docker_image = "k8s.gcr.io/metrics-server-amd64:v${var.metrics_server_version}"
}

resource "kubernetes_cluster_role" "aggregated_metrics_reader" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    labels = {
      "app.kubernetes.io/name"                       = "metrics-server"
      "app.kubernetes.io/managed-by"                 = "terraform"
      "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
    name = "system:aggregated-metrics-reader"
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "auth_delegator" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name = "metrics-server:system:auth-delegator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.metrics_server_service_account.metadata[0].name
    namespace = kubernetes_service_account.metrics_server_service_account.metadata[0].namespace
  }
}

resource "kubernetes_role_binding" "metrics_server_auth_reader" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name      = "metrics-server:system:auth-delegator"
    namespace = local.k8s_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.metrics_server_service_account.metadata[0].name
    namespace = kubernetes_service_account.metrics_server_service_account.metadata[0].namespace
  }
}

resource "kubernetes_api_service" "metrics_server_api" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name = "v1beta1.metrics.k8s.io"
  }
  spec {
    service {
      name      = kubernetes_service.metrics_server_service.metadata[0].name
      namespace = kubernetes_service.metrics_server_service.metadata[0].namespace
    }
    group                    = "metrics.k8s.io"
    version                  = "v1beta1"
    insecure_skip_tls_verify = true
    group_priority_minimum   = 100
    version_priority         = 100
  }
}

resource "kubernetes_service_account" "metrics_server_service_account" {
  count  = var.metrics_server_enabled ? 1 : 0
  automount_service_account_token = true
  metadata {
    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name      = "metrics-server"
    namespace = var.metrics_server_namespace
  }
}

resource "kubernetes_deployment" "metrics_server_deployment" {
  count  = var.metrics_server_enabled ? 1 : 0
  depends_on = [
    kubernetes_cluster_role_binding.auth_delegator,
    kubernetes_role_binding.metrics_server_auth_reader,
    kubernetes_cluster_role_binding.metrics_server_cluster_role_binding
  ]

  metadata {
    name      = "metrics-server"
    namespace = var.metrics_server_namespace

    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/version"    = "v${var.metrics_server_version}"
      "app.kubernetes.io/managed-by" = "terraform"
      "k8s-app"                      = "metrics-server"
    }

    annotations = {
      "field.cattle.io/description" = "metrics-server"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "metrics-server"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        annotations = var.metrics_server_pod_annotations
        labels = {
          "app.kubernetes.io/name"    = "metrics-server"
          "app.kubernetes.io/version" = var.metrics_server_version
          "k8s-app"                   = "metrics-server"
        }
      }

      spec {
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["metrics-server"]
                  }
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        automount_service_account_token = true

        dns_policy = "ClusterFirst"

        restart_policy = "Always"

        container {
          args = [
            "--logtostderr",
            "--cert-dir=/tmp",
            "--secure-port=4443",
            "--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP"
          ]

          command = [
            "/metrics-server"
          ]
          image             = var.metrics_server_docker_image
          image_pull_policy = "IfNotPresent"
          name = "metrics-server"
          termination_message_path = "/dev/termination-log"
          port {
            name           = "main-port"
            container_port = 4443
            protocol       = "TCP"
          }
          volume_mount {
            name       = "tmp-dir"
            mount_path = "/tmp"
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        priority_class_name = "system-node-critical"

        service_account_name             = kubernetes_service_account.metrics_server_cluster_role_binding.metadata[0].name
        termination_grace_period_seconds = 60

        volume {
          name = "tmp-dir"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "metrics_server_service" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    name      = "metrics-server"
    namespace = var.metrics_server_namespace

    labels = {
      "app.kubernetes.io/name"        = "metrics-server"
      "app.kubernetes.io/managed-by"  = "terraform"
      "k8s-app"                       = "metrics-server"
      "kubernetes.io/name"            = "Metrics-server"
      "kubernetes.io/cluster-service" = "true"
    }

    annotations = {
      "field.cattle.io/description" = "metrics-server"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = "metrics-server"
    }
    port {
      port        = 443
      protocol    = "TCP"
      target_port = "main-port"
    }
  }
}

resource "kubernetes_cluster_role" "metrics_server_cluster_role" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    name = "system:metrics-server"

    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  rule {
    api_groups = [""]
    resources = [
      "pods",
      "nodes",
      "nodes/stats",
      "namespaces",
      "configmaps"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "metrics_server_cluster_role_binding" {
  count  = var.metrics_server_enabled ? 1 : 0
  metadata {
    name = "system:metrics-server"

    labels = {
      "app.kubernetes.io/name"       = "metrics-server"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.metrics_server_cluster_role.metadata[0].name
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.metrics_server_service_account.metadata[0].name
    namespace = kubernetes_service_account.metrics_server_service_account.metadata[0].namespace
  }
}