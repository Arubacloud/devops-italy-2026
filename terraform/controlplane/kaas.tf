# KaaS (Kubernetes as a Service) - Managed Kubernetes cluster
resource "arubacloud_kaas" "controlplane" {
  name           = var.name
  location       = var.location
  project_id     = arubacloud_project.test.id
  tags           = var.tags
  billing_period = var.kaas_billing_period

  network = {
    vpc_uri_ref    = arubacloud_vpc.test.uri
    subnet_uri_ref = arubacloud_subnet.test.uri
    security_group_name = var.kaas_security_group_name
    node_cidr = {
      address = var.kaas_node_cidr_address
      name    = var.kaas_node_cidr_name
    }
    pod_cidr = var.kaas_pod_cidr
  }

  settings = {
    kubernetes_version = var.kaas_kubernetes_version
    node_pools = [
      {
        name        = var.kaas_node_pool_name
        nodes       = var.kaas_node_pool_nodes
        instance    = var.kaas_node_pool_instance
        zone        = var.kaas_node_pool_zone
        autoscaling = var.kaas_node_pool_autoscaling
        min_count   = var.kaas_node_pool_min_count
        max_count   = var.kaas_node_pool_max_count
      }
    ]
    ha = var.kaas_ha
  }
}
