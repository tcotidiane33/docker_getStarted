variable "cluster_name" { type = string }
variable "enable_prometheus" { type = bool }
variable "enable_grafana" { type = bool }
variable "enable_alertmanager" { type = bool }
variable "alert_email" { type = string }
variable "slack_webhook" { type = string }
variable "tags" { type = map(string) }

# Placeholder for Helm release of Prometheus Stack
resource "helm_release" "prometheus_stack" {
  count      = var.enable_prometheus ? 1 : 0
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = var.enable_grafana
  }

  set {
    name  = "alertmanager.enabled"
    value = var.enable_alertmanager
  }
}
