# Outputs for Aruba Cloud control plane infrastructure

output "cluster_id" {
  description = "ID of the created Kubernetes cluster"
  value       = arubacloud_kaas.controlplane.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = arubacloud_kaas.controlplane.name
}

output "kubeconfig" {
  description = "Kubeconfig file content"
  value       = arubacloud_kaas.controlplane.kubeconfig
  sensitive   = true
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = local_file.kubeconfig.filename
}

output "argocd_namespace" {
  description = "ArgoCD namespace name"
  value       = kubernetes_namespace.argocd.metadata[0].name
  depends_on  = [terraform_data.argocd_bootstrap]
}
