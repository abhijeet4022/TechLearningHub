resource "github_repository" "terraform" {
  name        = "terraform"
  description = "Example repository created using Terraform"
  visibility  = "public"
  auto_init = true
}