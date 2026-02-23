# Step 1: Create a Project (Foundation for all resources)
resource "arubacloud_project" "test" {
  name        = var.name
  description = "Project for testing Terraform container resources"
  tags        = var.tags
}
