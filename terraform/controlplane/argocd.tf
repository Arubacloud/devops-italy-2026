# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      name = "argocd"
    }
  }

  depends_on = [
    arubacloud_kaas.controlplane,
    local_file.kubeconfig,
    terraform_data.wait_for_cluster
  ]
}

# Install ArgoCD using kubectl
resource "terraform_data" "argocd_install" {
  depends_on = [kubernetes_namespace.argocd]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/install-argocd.sh ${local_file.kubeconfig.filename}"
  }
}

# Apply ArgoCD bootstrap manifests
# Applies projects from local filesystem and root app for GitOps
resource "terraform_data" "argocd_bootstrap" {
  depends_on = [terraform_data.argocd_install]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/bootstrap-argocd.sh ${local_file.kubeconfig.filename} ${path.module}"
  }
}

# Output ArgoCD access information
output "argocd_admin_password_command" {
  description = "Command to get ArgoCD admin password"
  value       = "kubectl --kubeconfig=${local_file.kubeconfig.filename} -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_port_forward_command" {
  description = "Command to port forward to ArgoCD UI"
  value       = "kubectl --kubeconfig=${local_file.kubeconfig.filename} port-forward svc/argocd-server -n argocd 8080:443"
}
