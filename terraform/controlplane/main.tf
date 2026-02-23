# Main Terraform configuration for Aruba Cloud control plane infrastructure

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    arubacloud = {
      source  = "arubacloud/arubacloud" # Uses public registry by default
      version = "~> 0.1.1"              # Use v0.0.1 or override with local build via .terraformrc
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  # Uncomment and configure for remote state
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "controlplane/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Aruba Cloud Provider Configuration
provider "arubacloud" {
  api_key    = var.arubacloud_api_key
  api_secret = var.arubacloud_api_secret
}

# Write kubeconfig to local file
resource "local_file" "kubeconfig" {
  content         = arubacloud_kaas.controlplane.kubeconfig
  filename        = "${path.module}/kubeconfig"
  file_permission = "0600"
}

# Wait for cluster API to be ready before attempting kubernetes operations
resource "terraform_data" "wait_for_cluster" {
  depends_on = [local_file.kubeconfig]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/wait-for-cluster.sh ${local_file.kubeconfig.filename}"
  }
}

# Configure Kubernetes provider to use the generated kubeconfig
provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}
