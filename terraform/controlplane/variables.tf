# ArubaCloud API credentials
variable "arubacloud_api_key" {
  description = "ArubaCloud API Key"
  type        = string
  sensitive   = true
}

variable "arubacloud_api_secret" {
  description = "ArubaCloud API Secret"
  type        = string
  sensitive   = true
}

# Common 
variable "name" {
  description = "Name of the KaaS cluster"
  type        = string
  default     = "devops-italy-2026"
}

variable "location" {
  description = "KaaS cluster location (region)"
  type        = string
  default     = "ITBG-Bergamo"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = list(string)
  default     = ["devops-italy", "platform", "gitops"]
}

# KaaS
variable "kaas_billing_period" {
  description = "Billing period for KaaS cluster"
  type        = string
  default     = "Hour"
}

variable "kaas_security_group_name" {
  description = "Security group name for KaaS cluster"
  type        = string
  default     = "kaas-security-group"
}

variable "kaas_node_cidr_address" {
  description = "Node CIDR address for KaaS cluster"
  type        = string
  default     = "10.0.0.0/24"
}

variable "kaas_node_cidr_name" {
  description = "Node CIDR name for KaaS cluster"
  type        = string
  default     = "kaas-node-cidr"
}

variable "kaas_pod_cidr" {
  description = "Pod CIDR for KaaS cluster"
  type        = string
  default     = "10.0.3.0/24"
}

variable "kaas_kubernetes_version" {
  description = "Kubernetes version for KaaS cluster"
  type        = string
  default     = "1.33.2"
}

variable "kaas_node_pool_name" {
  description = "Node pool name"
  type        = string
  default     = "pool-1"
}

variable "kaas_node_pool_nodes" {
  description = "Number of nodes in node pool"
  type        = number
  default     = 3
}

variable "kaas_node_pool_instance" {
  description = "Node pool instance type"
  type        = string
  default     = "K2A4"
}

variable "kaas_node_pool_zone" {
  description = "Node pool zone"
  type        = string
  default     = "ITBG-1"
}

variable "kaas_node_pool_autoscaling" {
  description = "Enable autoscaling for node pool"
  type        = bool
  default     = true
}

variable "kaas_node_pool_min_count" {
  description = "Minimum node count for autoscaling"
  type        = number
  default     = 1
}

variable "kaas_node_pool_max_count" {
  description = "Maximum node count for autoscaling"
  type        = number
  default     = 5
}

variable "kaas_ha" {
  description = "Enable high availability for KaaS cluster"
  type        = bool
  default     = true
}
