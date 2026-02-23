# VPC - Virtual Private Cloud Network
resource "arubacloud_vpc" "test" {
  name       = "${var.name}-vpc"
  location   = var.location
  project_id = arubacloud_project.test.id
  tags       = var.tags
}

# Subnet 
resource "arubacloud_subnet" "test" {
  name       = "${var.name}-subnet"
  location   = var.location
  project_id = arubacloud_project.test.id
  vpc_id     = arubacloud_vpc.test.id
  type       = "Basic"  # Required: "Basic" or "Advanced"
  tags       = var.tags
}


# Security Group - For KaaS
resource "arubacloud_securitygroup" "kaas" {
  name       = "${var.name}-sg"
  location   = var.location
  project_id = arubacloud_project.test.id
  vpc_id     = arubacloud_vpc.test.id
  tags       = var.tags
}

# Security Rule - Allow all outbound traffic for KaaS
resource "arubacloud_securityrule" "kaas_egress" {
  name       = "${var.name}-egress"
  location   = var.location
  project_id        = arubacloud_project.test.id
  vpc_id            = arubacloud_vpc.test.id
  security_group_id = arubacloud_securitygroup.kaas.id
  # Note: tags not supported on security rules (provider bug)
  properties = {
    direction = "Egress"
    protocol  = "ANY"
    port      = "*"
    target = {
      kind  = "Ip"
      value = "0.0.0.0/0"
    }
  }
}
